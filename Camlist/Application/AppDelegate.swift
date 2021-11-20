//
//  AppDelegate.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let client = URLSessionHTTPClient()
        let venueRepo = RemoteVenueLoader(client: client)
        let fetchVenueUseCase = DefaultFetchVenueUseCase(venueRepository: venueRepo)
        let venueImageRepo = RemoteVenueImageLoader(client: client)
        let fetchVenueImageUseCase = DefaultFetchVenueImageUseCase(venueRepository: venueImageRepo)
        let vc = VenueUIComposer.venueComposedWith(fetchVenueUseCase: fetchVenueUseCase, fetchVenueImageUseCase: fetchVenueImageUseCase)
        
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
      
       navigationController.pushViewController(vc, animated: false)
        
        return true
    }



}

