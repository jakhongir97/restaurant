//
//  MenuCollectionCell.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/11/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa


class MenuCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var item : Item? {
        didSet {
            guard let item = item else {return}
            cellTitle.text = item.food_name
            cellCost.text = "$" + String(describing: item.cost!)
            
            
            let urlString = "http://tashkentdxb.com/"+String(describing: item.photo!)
            let url = URL(string: urlString)
            self.cellImageView.kf.indicatorType = .activity
            self.cellImageView.kf.setImage(with: url)
            
            CartManager.sharedInstance.savedCountsDictionary.asObservable().subscribe(onNext: { [weak self] dictionary in
                guard let itemId = item.id else {
                    self?.numberLabel.text = "0"
                    return }
                guard let count = dictionary[itemId] else {
                    self?.numberLabel.text = "0"
                    return }
                self?.numberLabel.text = String(count)
                

                
            }).disposed(by: disposeBag)
            
        }
    }
    
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
        label.text = "0"
        label.textColor = UIColor.init(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let plusImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "plus")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let minusImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "minus")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(backView)
        addSubview(cellImageView)
        addSubview(cellTitle)
        addSubview(cellCost)
        addSubview(plusImageView)
        addSubview(minusImageView)
        addSubview(numberLabel)
        
        
        _ = backView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        _ = cellImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height*0.7)

        _ = cellTitle.anchor(cellImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        _ = cellCost.anchor(cellTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        _ = plusImageView.anchor(cellTitle.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)

        _ = numberLabel.anchor(cellTitle.bottomAnchor, left: nil, bottom: nil, right: plusImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)

        _ = minusImageView.anchor(cellTitle.bottomAnchor, left: nil, bottom: nil, right: numberLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
        
        
    }
    
    
    
}



