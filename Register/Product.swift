//
//  Product.swift
//  Register
//
//  Created by Robert Masen on 2/13/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

class Product {
    var Id: Int
    var Name: String
    var Price: Double
    var Description: String

    init(id: Int, name: String, price: Double, desc: String) {
        self.Id = id
        self.Name = name
        self.Price = price
        self.Description = desc
    }
    
    func toString() -> String {
        return "\(Id) \(Name)"
    }
}