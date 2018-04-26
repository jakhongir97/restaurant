//
//  CartManager.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/14/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import RxSwift


class CartManager {
    
    static let sharedInstance = CartManager()
    
    var orders = Variable<[Order]>([])
    
    var isShouldBeReloaded = Variable(false)
    
    var savedCountsDictionary = Variable<[Int:Int]>([:])

    private init() {}
    
    func orderCountForItem(key : Int , value : Int) {
        savedCountsDictionary.value[key] = value
    }
    
    func removeFromSavedCountsDictionary (key : Int){
        savedCountsDictionary.value.removeValue(forKey: key)
    }
    
    func addOrder(order : Order) {
        orders.value.append(order)
        
    }
    
    func updateOrderCountForId(count : Int , id : Int) {
        for (index , order) in orders.value.enumerated() {
            if id == order.item?.id {
                orders.value[index].count = count
            }
        }
        
    }
    
    func updateOrderCountForIndex(count : Int , index : Int) {
       orders.value[index].count = count
    }
    
    func removeOrderforIndex(index : Int )  {
        orders.value.remove(at: index)
        
    }
    
    func removeOrderForId(id : Int )  {
        for (index , order) in orders.value.enumerated() {
            if id == order.item?.id {
                orders.value.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        orders.value.removeAll(keepingCapacity: false)
        savedCountsDictionary.value.removeAll(keepingCapacity: false)
    }
    
    func numberOfItemsInCart() -> Int {
        return orders.value.count
    }
    
    func totalPriceInCart() -> Float {
        var totalPrice: Float = 0
        var multipliedValue : Float?
        for order in orders.value {
            multipliedValue = Float((order.item?.cost)! * order.count!)
            totalPrice += multipliedValue!
        }
        return totalPrice
    }
    
    func orderAtIndexPath(indexPath: IndexPath) -> Order {
        return orders.value[indexPath.row]
    }
    
    
    
    
    
    
}
