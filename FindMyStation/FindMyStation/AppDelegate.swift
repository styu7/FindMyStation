//
//  AppDelegate.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let stationsViewModel = StationsViewModel()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard.instantiateViewController(identifier: "ListViewController") { coder in
            return ListViewController(coder: coder, viewModel: stationsViewModel)
        }
        let mapVC = storyboard.instantiateViewController(identifier: "MapViewController") { coder in
            MapViewController(coder: coder, viewModel: stationsViewModel)
        }
        
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [mapVC, listVC]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
