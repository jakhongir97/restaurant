//
//  MainNavigationController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/16/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.checkLoggedIn()   
    }
    
    fileprivate func checkLoggedIn(){
        if isLoggedIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeStoryboard") as! HomeViewController
            viewControllers = [vc]
            
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginStoryboard") as! LoginViewController
            viewControllers = [vc]
        }
    }
    
    
    
    fileprivate func setupAppearance(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = UIColor(named : "awesomeOrange")
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppearace.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
   
    
}
