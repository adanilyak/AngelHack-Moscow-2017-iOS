//
//  Look.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Look {
    var items: [Item]
    
    init(json: JSON) {
        items = []
        for itemJson in json.arrayValue {
            items.append(Item(json: itemJson))
        }
    }
    
    static func parseLooks(json: JSON) -> [Look] {
        var looks: [Look] = []
        for lookJson in json.arrayValue {
            looks.append(Look(json: lookJson))
        }
        return looks
    }
}

struct Item {
    
    enum Category: String {
        case top
        case bottom
        case outer
        case shoes
        case bag
        case belt
        case bracelet
        case earrings
        case dress
    }
    
    var imageUrl: URL
    var type: Category
    
    init(json: JSON) {
        imageUrl = URL(string: json["image"].stringValue)!
        type = Category(rawValue: json["type"].stringValue)!
    }
}
