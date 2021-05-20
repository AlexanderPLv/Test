//
//  CurrencyListTableViewController.swift
//  Test
//
//  Created by Alexander Pelevinov on 16.05.2021.
//

import UIKit
import CoreData

class CurrencyListTableViewController: UITableViewController {

    let networkManager: NetworkManager
    let container: NSPersistentContainer
    
    private lazy var resultsController: NSFetchedResultsController<Rate>? = {
        var resultController: NSFetchedResultsController<Rate>?
        
        container.viewContext.performAndWait {
            let fetchRequest: NSFetchRequest<Rate> = Rate.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
            let controller = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            controller.delegate = self
            resultController = controller
        }
        return resultController
    }()
    
    init(style: UITableView.Style,
         container: NSPersistentContainer,
         networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        self.container = container
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CurrencyCell.self,
                           forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
        container.viewContext.perform {
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
        }
        getCurrencyList()
    }
    
    fileprivate func getCurrencyList() {
            networkManager.getCurrencyList { [weak self] response in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let response):
                    guard let self = self else { return }
                    self.saveToStore(response)
                }
            }
        }
    
    fileprivate func saveToStore(_ response: Response) {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        context.parent?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        response.rates.forEach { value in
            let rate = Rate(context: context)
            rate.tp = Int16(value.tp)
            rate.name = value.name
            rate.from = Int16(value.from)
            rate.to = Int16(value.to)
            rate.currMnemFrom = value.currMnemFrom.rawValue
            rate.currMnemTo = value.currMnemTo
            rate.buy = value.buy
            rate.sale = value.sale
            rate.deltaBuy = value.deltaBuy
            rate.deltaSale = value.deltaSale
            rate.basic = value.basic
            rate.downloadDate = response.downloadDate
            rate.ratesDate = response.ratesDate
            do {
                try context.save()
                try context.parent?.save()
            } catch let saveError {
                print("Failed to save rates:", saveError.localizedDescription)
        }
    }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = resultsController?.sections?[section].objects?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseIdentifier,
                                                       for: indexPath) as? CurrencyCell else { fatalError() }
        if let rate = resultsController?.object(at: indexPath) {
            cell.rate = rate
        }
        return cell
    }
    
}
// MARK: - NSFetchedResultsControllerDelegate
extension CurrencyListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError("unknown case frc sectionInfo")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("unknown case frc didChange an object")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
}
