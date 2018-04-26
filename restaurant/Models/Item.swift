//
//  Item.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/12/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import Foundation

struct Item : Decodable {
    var id : Int?
    var food_name : String?
    var category_id : Int?
    var description : String?
    var content : String?
    var photo : String?
    var cost : Int?
}


