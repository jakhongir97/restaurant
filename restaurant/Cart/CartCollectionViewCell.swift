//
//  CartCollectionViewCell.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/17/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift



class CartCollectionViewCell: UICollectionViewCell  {

    
    var order : Order? {
        didSet {
            guard let item = order?.item else {return}
            cellTitle.text = item.food_name
            cellCost.text = "$" + String(describing: item.cost!)
            
            
            let urlString = "http://tashkentdxb.com/"+String(describing: item.photo!)
            let url = URL(string: urlString)
            self.cellImageView.kf.indicatorType = .activity
            self.cellImageView.kf.setImage(with: url)
            
            guard let count = order?.count else {return}
            self.numberLabel.text = String(count)
            
            
        }
    }
    
    let disposeBag = DisposeBag()
    
    var indexPath : IndexPath?
    
    let backView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
        view.layer.shadowRadius = 1
        
        return view
    }()
    
    let cellImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let cellTitle : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let cellCost : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    let numberLabel : UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = UIColor.init(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let  plusButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.gray
        button.setImage(UIImage(named : "plus-128"), for: .normal)
        return button
    }()
    
    let minusButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.gray
        button.setImage(UIImage(named : "minus-128"), for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        plusMinusCount()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    
    
    func plusMinusCount() {
        
        _ = plusButton.rx.tap.bind {
            var count = Int(self.numberLabel.text!)!
            count += 1
            self.numberLabel.text = String(count)
            
            guard let item = self.order?.item , let indexPath = self.indexPath else {return}
            
            
            CartManager.sharedInstance.orderCountForItem(key: item.id!, value: count)
            CartManager.sharedInstance.updateOrderCountForIndex(count: count, index: indexPath.row)
        }
        
        _ = minusButton.rx.tap.bind {
            var count = Int(self.numberLabel.text!)!
            count -= 1
            self.numberLabel.text = String(count)
            
            guard let item = self.order?.item , let indexPath = self.indexPath else {return}
            
            CartManager.sharedInstance.orderCountForItem(key: item.id!, value: count)
            CartManager.sharedInstance.updateOrderCountForIndex(count: count, index: indexPath.row)
            
            if count == 0 {
                CartManager.sharedInstance.removeOrderforIndex(index: indexPath.row)
                CartManager.sharedInstance.removeFromSavedCountsDictionary(key: item.id!)
                CartManager.sharedInstance.isShouldBeReloaded.value = true
            }
            
            if count < 0 {
                return
            }
        }
    }
    
    func setupViews() {
        
        addSubview(backView)
        addSubview(cellImageView)
        addSubview(cellTitle)
        addSubview(cellCost)
        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(numberLabel)
        
        
        _ = backView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = cellImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        
        _ = cellTitle.anchor(topAnchor, left: cellImageView.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = cellCost.anchor(cellTitle.bottomAnchor, left: cellImageView.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = plusButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 35, leftConstant: 0, bottomConstant: 35, rightConstant: 20, widthConstant: 30, heightConstant: 0)
       
        _ = numberLabel.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: plusButton.leftAnchor, topConstant: 35, leftConstant: 0, bottomConstant: 35, rightConstant: 10, widthConstant: 30, heightConstant: 0)
       
        _ = minusButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: numberLabel.leftAnchor, topConstant: 35, leftConstant: 0, bottomConstant: 35, rightConstant: 10, widthConstant: 30, heightConstant: 0)
        

        
    }
}
