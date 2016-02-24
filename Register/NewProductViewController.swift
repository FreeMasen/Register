//
//  NewProductViewController.swift
//  Register
//
//  Created by Robert Masen on 2/13/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit

class NewProductViewController: UIViewController {
    
    @IBOutlet weak var NameTextBox: UITextField!
    @IBOutlet weak var PriceTextBox: UITextField!
    @IBOutlet weak var DescTextBox: UITextField!
    
    var products = [Product]()
    
    @IBAction func TouchAddProduct(sender: UIButton) {
        if checkForm() {
            if let price = Double(PriceTextBox.text!) {
                products.append(Product(id: 1, name: NameTextBox.text!, price: price, desc: DescTextBox.text!))
                JSONHandler.saveProducts(products)
            }
        }
    }
    
    func checkForm() -> Bool {
        if NameTextBox.text != "" {
            if PriceTextBox.text != "" {
                if DescTextBox.text != "" {
                    return true
                }
            }
        }
        return false
    }
    
    func AlertUser(message: String) {
        let alert = UIAlertController(title: "Payment Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}