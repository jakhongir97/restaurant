//
//  HomeMenuCollectionViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/13/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import ViewAnimator
import RxSwift
import RxCocoa


private let reuseIdentifier = "cell"

class HomeMenuCollectionViewController: UICollectionViewController {
    
    let categoryListTitles = ["Starter","Main","Dessert","Drinks"]
    let categoryListImages = ["starter","main","dessert","drinks"]
    
    private let animations = [AnimationType.from(direction: .top, offset: 30.0)]
    private let zoomAnimation = AnimationType.zoom(scale: 0.5)
   
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView!.register(HomeMenuCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.animateViews(animations: [zoomAnimation])
        }, completion: nil)
        
    }
        
    override open var shouldAutorotate: Bool {
        return false
    }
    



}



extension HomeMenuCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryListTitles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeMenuCollectionViewCell
        
        cell.cellTitle.text = categoryListTitles[indexPath.item]
        cell.cellImageView.image = UIImage(named: categoryListImages[indexPath.item])
        
        return cell
    }
    
    
}

extension HomeMenuCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mcvc = storyboard.instantiateViewController(withIdentifier: "MenuCollection") as! MenuCollectionViewController
        mcvc.sendData = (indexPath.row,categoryListTitles[indexPath.item])
        self.navigationController?.pushViewController(mcvc,animated: true)


    }
    
}





extension HomeMenuCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: (width - 30)/2, height: (width - 60)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 10, bottom: 15, right: 10)
    }
    
}
