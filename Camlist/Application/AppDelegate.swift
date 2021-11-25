//
//  AppDelegate.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import UIKit



class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var mainAppController: MainAppController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        mainAppController = MainAppController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        
        navigationController.pushViewController(makeRootViewController(), animated: false)
        
        return true
    }

    func makeRootViewController() -> VenueViewController {
        (mainAppController?.makeVenueScene())!
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }
    

}




