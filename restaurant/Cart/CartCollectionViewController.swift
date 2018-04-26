//
//  CartCollectionViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/17/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import ViewAnimator
import UIEmptyState
import RxCocoa
import RxSwift


private let reuseIdentifier = "Cell"

class CartCollectionViewController: UICollectionViewController ,UIEmptyStateDataSource, UIEmptyStateDelegate {
    
    private let animations = [AnimationType.from(direction: .top, offset: 30.0)]
    private let zoomAnimation = AnimationType.zoom(scale: 0.5)
    
    var emptyStateImage: UIImage? {
        return #imageLiteral(resourceName: "emptyCart")
    }
    
    var emptyStateTitle: NSAttributedString {
        return NSAttributedString(string : "")
    }
    
    var emptyStateImageSize: CGSize? {
        return CGSize(width: 200, height: 200)
    }
    
    let disposeBag = DisposeBag()
    
    let orderButton : UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named : "awesomeOrange")
        button.setTitle("Order", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss(){
        let orderViewController = OrderViewController()
        self.navigationController?.pushViewController(orderViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
        setupView()
        shouldBeReloaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
        self.collectionView?.performBatchUpdates({
            self.collectionView?.animateViews(animations: [zoomAnimation])
        }, completion: nil)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    private func setupView(){
        collectionView?.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 243/255, alpha: 1)
        
        self.navigationItem.title = "Cart"
        
        self.collectionView!.register(CartCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(orderButton)
        _ = orderButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
  
    private func shouldBeReloaded () {
        CartManager.sharedInstance.isShouldBeReloaded.asObservable().subscribe(onNext: { [weak self] bool in
            if bool {
                self?.collectionView?.reloadData()
                self?.reloadEmptyState()

            }
            
        }).disposed(by: disposeBag)
    }
    

  
    

   

}


extension CartCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartManager.sharedInstance.numberOfItemsInCart()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCollectionViewCell
        cell.order = CartManager.sharedInstance.orderAtIndexPath(indexPath: indexPath)
        cell.indexPath = indexPath
        return cell
    }
    

    
}

extension CartCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 40
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 70, right: 20)
    }
    
    
}


