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
        
        items.sort { (i1, i2) -> Bool in
            return i1.type.intVal() > i2.type.intVal()
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
        case bag
        case belt
        case bracelet
        case earrings
        case shoes
        case bottom
        case outer
        case top
        case dress
        
        func intVal() -> Int {
            switch self {
            case .bag: return 0
            case .belt: return 1
            case .bracelet: return 2
            case .earrings: return 3
            case .shoes: return 4
            case .bottom: return 5
            case .outer: return 6
            case .top: return 7
            case .dress: return 8
            }
        }
    }
    
    var imageUrl: URL
    var type: Category
    
    init(json: JSON) {
        imageUrl = URL(string: json["image"].stringValue)!
        type = Category(rawValue: json["type"].stringValue)!
    }
}
