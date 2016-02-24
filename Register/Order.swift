//
//  Order.swift
//  Register
//
//  Created by Robert Masen on 2/13/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class Order {
    var Id: Int
    var Items: [Product]
    var Subtotal: Double {
        get {
            return Items.reduce(0, combine: {$0 + $1.Price})
        }
    }
    var Tax: Double {
        get {
            return Subtotal * 0.075
        }
    }
    var Total: Double {
        get {
            return Subtotal + Tax
        }
    }
    
    init() {
        Id = Int(NSDate().timeIntervalSinceReferenceDate)
        Items = [Product]()
    }
    
    func AddItem(product: Product) {
        self.Items.append(product)
    }
    
    
}