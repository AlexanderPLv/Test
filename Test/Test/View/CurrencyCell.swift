//
//  CurrencyCell.swift
//  Test
//
//  Created by Alexander Pelevinov on 19.05.2021.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class CurrencyCell: UITableViewCell, ReusableView {
    
    var rate: Rate? {
        didSet {
            setLabelsText()
        }
    }
    
    private func setLabelsText() {
        guard let rate = rate else { return }
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        
        let tpLabelText = NSMutableAttributedString(string: "Tp: \(rate.tp)",
                                                    attributes: attributes)
        tpLabel.attributedText = tpLabelText
        if let name = rate.name {
            let nameLabelText = NSMutableAttributedString(string: "Name: \(name)",
                                                                  attributes: attributes)
                    nameLabel.attributedText = nameLabelText
        }
        
        let fromLabelText = NSMutableAttributedString(string: "From: \(rate.from)",
                                                      attributes: attributes)
        fromLabel.attributedText = fromLabelText
        
        if let currMnemFrom = rate.currMnemFrom {
            let currMnemFromLabelText = NSMutableAttributedString(string: "CurrMnemFrom: \(currMnemFrom)",
                                                                          attributes: attributes)
                    currMnemFromLabel.attributedText = currMnemFromLabelText
        }
        
        let toLabelText = NSMutableAttributedString(string: "To: \(rate.to)",
                                                    attributes: attributes)
        toLabel.attributedText = toLabelText
        
        if let currMnemTo = rate.currMnemTo {
            let currMnemToLabelText = NSMutableAttributedString(string: "CurrMnemTo: \(currMnemTo)",
                                                                        attributes: attributes)
                    currMnemToLabel.attributedText = currMnemToLabelText
        }
        
        if let basic = rate.basic {
            let basicLabelText = NSMutableAttributedString(string: "Basic: \(basic)",
                                                                   attributes: attributes)
                    basicLabel.attributedText = basicLabelText
        }
        
        if let buy = rate.buy {
            let buyLabelText = NSMutableAttributedString(string: "Buy: \(buy)",
                                                                 attributes: attributes)
                    buyLabel.attributedText = buyLabelText
        }
        
        if let sale = rate.sale {
            let saleLabelText = NSMutableAttributedString(string: "Sale: \(sale)",
                                                                  attributes: attributes)
                    saleLabel.attributedText = saleLabelText
        }
        
        if let deltaBuy = rate.deltaBuy {
            let deltaBuyLabelText = NSMutableAttributedString(string: "Delta Buy: \(deltaBuy)",
                                                                      attributes: attributes)
                    deltaBuyLabel.attributedText = deltaBuyLabelText
        }
        
        if let deltaSale = rate.deltaSale {
            let deltaSaleLabelText = NSMutableAttributedString(string: "Delta Sale: \(deltaSale)",
                                                                       attributes: attributes)
                    deltaSaleLabel.attributedText = deltaSaleLabelText
        }
        
        if let downloadDate = rate.downloadDate, let ratesDate = rate.ratesDate {
            let dateText = NSMutableAttributedString(string: "Download Date: \(downloadDate)",
                                                             attributes: attributes)
                    dateText.append(NSAttributedString(string: "\n\n",
                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
                    dateText.append(NSAttributedString(string: "\(ratesDate)",
                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                    NSAttributedString.Key.foregroundColor: UIColor.gray]))
            dateLabel.attributedText = dateText
        }
        
    }
    
    private let tpLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let currMnemFromLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let currMnemToLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let basicLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let buyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let saleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let deltaBuyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let deltaSaleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        let stackView = UIStackView(arrangedSubviews: [
            tpLabel,
            nameLabel,
            fromLabel,
            toLabel,
            currMnemFromLabel,
            currMnemToLabel,
            basicLabel,
            buyLabel,
            saleLabel,
            deltaBuyLabel,
            deltaSaleLabel,
            dateLabel,
        ])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        let padding: CGFloat = 8
        [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ].forEach { $0.isActive = true }
    }
    
}
