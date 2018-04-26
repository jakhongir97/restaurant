//
//  AppDelegate.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/10/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import Firebase




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainNavigationController()
        
        return true
    }

  


}

