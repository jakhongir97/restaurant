//
//  TopInterfaceViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/11/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit

class TopInterfaceViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var nearByLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.infoView.layer.shadowColor = UIColor.black.cgColor
        self.infoView.layer.shadowOpacity = 0.25
        self.infoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.infoView.layer.shadowRadius = 0.5
        
        self.profileButton.layer.cornerRadius = 15
        self.openButton.layer.cornerRadius = 8
    }
    
    
    @IBAction func profileAction(_ sender: Any) {
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }


}
