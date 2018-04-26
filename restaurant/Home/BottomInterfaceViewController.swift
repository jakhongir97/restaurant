//
//  ContainerViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/10/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import Parchment



class BottomInterfaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupPageView()
        
        
       
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    fileprivate func setupPageView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "HomeMenuStoryboard") as! HomeMenuCollectionViewController
        firstViewController.title = "Menu"
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "AboutStoryboard") as! AboutViewController
        secondViewController.title = "About"
        let thirdViewController = storyboard.instantiateViewController(withIdentifier: "ReviewStoryboard") as! ReviewViewController
        thirdViewController.title = "Review"
        
        
        let pagingViewController = FixedPagingViewController(viewControllers: [firstViewController,secondViewController ,thirdViewController])
        
        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        
        pagingViewController.didMove(toParentViewController: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 100, height: 40)
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.menuInteraction = .swipe
        pagingViewController.textColor = UIColor.init(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        pagingViewController.selectedTextColor = .orange
        pagingViewController.indicatorColor = .orange
        pagingViewController.menuInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
        pagingViewController.borderOptions = .hidden
        pagingViewController.view.backgroundColor = .white
        
        
        NSLayoutConstraint.activate([
            pagingViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor) ,
            pagingViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        
    }
    
    
    

    
  
    
   

}


