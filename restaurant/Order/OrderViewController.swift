//
//  OrderViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 4/19/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    let completedLabel : UILabel = {
        var label = UILabel()
        label.text = "Your Order is Delevired !"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let totalCostLabel : UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
   



    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        calculateTotalCost()
        clearCart()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(completedLabel)
        view.addSubview(totalCostLabel)
        
        _ = completedLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        _ = totalCostLabel.anchor(completedLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
    }
    
    private func calculateTotalCost()  {
        let totalCost = CartManager.sharedInstance.totalPriceInCart() 
        self.totalCostLabel.text = "$\(totalCost)"
    }
    
    private func clearCart() {
        CartManager.sharedInstance.clearCart()
    }

   

}
