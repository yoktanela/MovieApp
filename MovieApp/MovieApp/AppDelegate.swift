//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let cache = ImageCache.default

        // Constrain Memory Cache to 10 MB
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10

        // Constrain Disk Cache to 100 MB
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 100
        
        if #available(iOS 13, *) {
            
        } else {
            self.window = UIWindow()
            let navigationController = UINavigationController()
            let mainView = MainViewController(nibName: nil, bundle: nil)
            navigationController.viewControllers = [mainView]
            navigationController.navigationBar.isTranslucent = false
            self.window!.rootViewController = navigationController
            self.window!.makeKeyAndVisible()
            self.window!.backgroundColor = .white
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

