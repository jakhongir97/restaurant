//
//  ReviewViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/10/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController {

   
    @IBOutlet weak var starsView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var fiveStarSlider: UISlider!
    @IBOutlet weak var fourStarSlider: CustomSlider!
    @IBOutlet weak var threeStarSlider: CustomSlider!
    @IBOutlet weak var twoStarSlider: CustomSlider!
    @IBOutlet weak var oneStarSlider: CustomSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

     
    }
    
    private func setupView(){
        if UserDefaults.standard.bool(forKey: "isRated") {
            let rating = UserDefaults.standard.double(forKey: "rating")
            ratingLabel.text = String(rating)
            starsView.rating = rating
        }
        
        starsView.didTouchCosmos = didTouchCosmos
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    private func didTouchCosmos(_ rating: Double) {
        ratingLabel.text = String(rating)
        UserDefaults.standard.set(rating, forKey: "rating")
        UserDefaults.standard.set(true, forKey: "isRated")
        UserDefaults.standard.synchronize()
    }
    
    


   
    

}
