//
//  MenuCollectionViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/12/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Segmentio
import DGElasticPullToRefresh
import RxSwift
import RxCocoa
import ViewAnimator

class MenuCollectionViewController: UICollectionViewController {
    
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailDescriptionTextView: UITextView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private let animations = [AnimationType.from(direction: .top, offset: 30.0)]
    private let zoomAnimation = AnimationType.zoom(scale: 0.5)
    
    
    let cellId = "cell"
    let urlString = "http://tashkentdxb.com/web/en/foodapi"
    
    let disposeBag = DisposeBag()

    var sendData : (Int,String)?
    
    
    var items = [Item]()
    
    var orderCount : Int = 0
    var item  = Item()
    var indexPath = IndexPath()
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var activityIndicator : NVActivityIndicatorView!
    
    var effect : UIVisualEffect!
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        return blurEffectView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
        setupActivityIndicator()

        setupNavbarButtons()
        
        getCells()
        
        setupDGElastik()
        
        animateView()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    deinit {
        collectionView?.dg_removePullToRefresh()
    }

    
    private func setupActivityIndicator(){
        let frameAI = CGRect(x: (self.view.center.x - 50), y: (self.view.center.y - 50), width: 70, height: 70)
        activityIndicator = NVActivityIndicatorView(frame: frameAI)
        activityIndicator.type = .ballGridPulse
        activityIndicator.color = UIColor(named : "awesomeOrange")!
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.center.y - 50
        
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    

    private func animateView() {
        self.collectionView?.performBatchUpdates({
            self.collectionView?.animateViews(animations: [zoomAnimation])
        }, completion: nil)
    }
    
    
    
    func setupNavbarButtons () {
        
        self.navigationItem.largeTitleDisplayMode = .never

        self.navigationItem.title = sendData?.1 ?? "Menu"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let cartLabel = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let customLabelButton = ButtonWithImage()
        customLabelButton.setTitle("", for: .normal)
        customLabelButton.setBackgroundImage(UIImage(named : "bag")?.withRenderingMode(.alwaysTemplate), for: .normal)
        customLabelButton.tintColor = .white
        customLabelButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        customLabelButton.setTitleColor(.orange, for: .normal)
        customLabelButton.addTarget(self, action: #selector(handleCartMenu), for: .touchUpInside)
        customLabelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        customLabelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        

        cartLabel.customView = customLabelButton
        
        
        self.navigationItem.rightBarButtonItem = cartLabel
        
        CartManager.sharedInstance.orders.asObservable()
            .subscribe(onNext: {
                orders in
                if orders.count != 0 {
                    let countString = String(orders.count)
                    customLabelButton.setTitle(countString, for: .normal)
                } else {
                    customLabelButton.setTitle("", for: .normal)
                }
            }).disposed(by: disposeBag)
        
    }
    

    @objc func handleCartMenu () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CartStoryboard") as! CartCollectionViewController
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    
    @IBAction func doneAction(_ sender: Any) {
        animateOut()
        guard let count = Int(numberLabel.text!) else { return }
        if let oldCount = CartManager.sharedInstance.savedCountsDictionary.value[item.id!] {
            if oldCount == count {
                return
            } else if count == 0{
                CartManager.sharedInstance.removeOrderForId(id: item.id!)
                CartManager.sharedInstance.removeFromSavedCountsDictionary(key: item.id!)
            }
            else {
                CartManager.sharedInstance.orderCountForItem(key: item.id!, value: count)
                CartManager.sharedInstance.updateOrderCountForId(count: count, id: item.id!)
                return
            }
        }
        
        if count != 0 {
            self.addOrder(item: item, count: count)
            CartManager.sharedInstance.orderCountForItem(key: item.id!, value: count)
            orderCount = 0
        }
        
        
        
    }
    @IBAction func minusAction(_ sender: Any) {
        orderCount = Int(numberLabel.text!)!
        if orderCount == 0 {
            minusButton.isEnabled = false
            return
        } else {
            minusButton.isEnabled = true
            orderCount -= 1
            numberLabel.text = String(orderCount)
        }
        
        
    }
    @IBAction func plusAction(_ sender: Any) {
        minusButton.isEnabled = true
        orderCount = Int(numberLabel.text!)!
        orderCount += 1
        numberLabel.text = String(orderCount)
    }
    
    private func addOrder(item : Item , count : Int) {
        var order = Order()
        order.item = item
        order.count = count
        CartManager.sharedInstance.addOrder(order: order)
    }

}

extension MenuCollectionViewController {
    
    func setCategory(items : [Item]){
        for item in items {
            let categoryId = (sendData?.0)! + 1
            if item.category_id == categoryId {
                self.items.append(item)
            }
            
        }
    }
    
    func getCells (){
        
        guard let url = URL(string : urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                self.setCategory(items: items)
                //self.items = items
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView?.reloadData()
                    self.animateView()
                    
                }
                
            }
            catch let error {
                print(error)
            }
            }.resume()
        
    }
    
    
    func setupDetailViewWithInfo(item : Item) {
        self.item = item
        detailTitleLabel.text = item.food_name
        detailDescriptionTextView.text = item.description
        if let labelCount = CartManager.sharedInstance.savedCountsDictionary.value[item.id!] {
            numberLabel.text = String(labelCount)
        }else {
            numberLabel.text = "0"
        }
        
        let urlString = "http://tashkentdxb.com/"+String(describing: item.photo!)
        let url = URL(string: urlString)
        self.detailImageView.kf.indicatorType = .activity
        self.detailImageView.kf.setImage(with: url)
        
    }
    
    
    
    private func animateIn (){
        self.view.addSubview(blurEffectView)
        _ = blurEffectView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        effect  = blurEffectView.effect
        blurEffectView.effect = nil
        
        
        self.view.addSubview(detailView)
        _ = detailView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant:20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        detailView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        detailView.layer.cornerRadius = 20
        detailView.layer.masksToBounds = true
        detailView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = self.effect
            self.detailView.alpha = 1
            self.detailView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.detailView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            self.detailView.alpha = 0
            self.blurEffectView.effect = nil
        }) { (success : Bool) in
            self.blurEffectView.effect = self.effect
            self.detailView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    
    private func setupDGElastik(){
        
        loadingView.tintColor = .white
        collectionView?.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self?.collectionView?.dg_stopLoading()
                self?.animateView()
            })
            }, loadingView: loadingView)
        collectionView?.dg_setPullToRefreshFillColor(UIColor(named : "awesomeOrange")!)
        collectionView?.dg_setPullToRefreshBackgroundColor((collectionView?.backgroundColor!)!)
    }
    
}

extension MenuCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCollectionViewCell

        let item = items[indexPath.item]
        cell.item = item

        return cell
    }
}

extension MenuCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupDetailViewWithInfo(item: items[indexPath.item])
        self.indexPath = indexPath
        animateIn()
    }
 
}


extension MenuCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize : CGRect = UIScreen.main.bounds
        
        let width = view.frame.width
        //iphone 5
        if screenSize.width == 320 {
            
            return CGSize(width: (width - 30)/2, height: (width - 60)/2 + 10)
        }
        
        
        return CGSize(width: (width - 30)/2, height: (width - 60)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
}




















