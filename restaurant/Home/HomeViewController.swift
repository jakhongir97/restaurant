//
//  ViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/10/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }

}

