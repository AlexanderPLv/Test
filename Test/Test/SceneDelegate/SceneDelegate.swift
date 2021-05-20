//
//  SceneDelegate.swift
//  Test
//
//  Created by Alexander Pelevinov on 16.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        window?.rootViewController = CurrencyListTableViewController(style: UITableView.Style.plain,
                                                                     container: appDelegate.persistentContainer)
        window?.makeKeyAndVisible()
    }

}

