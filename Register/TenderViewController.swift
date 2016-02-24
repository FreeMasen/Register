//
//  TenderViewController.swift
//  Register
//
//  Created by Robert Masen on 2/15/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit
import Foundation

class TenderViewController : UIViewController, UITabBarControllerDelegate   {
    
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var amountDue: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var cashProvided: UITextField!
    @IBOutlet weak var CCNumberTextBox: UITextField!
    @IBOutlet weak var ExpTextBox: UITextField!
    @IBOutlet weak var CCVTextBox: UITextField!
    @IBOutlet weak var expYearTextBox: UITextField!
    
    var transaction = Transaction()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setLabels()
    }
    
    @IBAction func tenderCash(sender: AnyObject) {
        if let cash = Double(cashProvided.text!) {
            transaction.processPayment(cash, transactionType: .Cash)
            cashProvided.text = ""
            amountDue.text = String(format: "$%.2f", transaction.amountDue)
            if transaction.balanced {
                performSegueWithIdentifier("OrderSummary", sender: nil)
            }
        }
    }
    
    @IBAction func ChargeCard(sender: AnyObject) {
        let creditCard = CreditCard()
        
        if checkForm() {
            if (creditCard.setCardNumber(CCNumberTextBox.text!) == false) {
                AlertUser("Problem with Credit Card Number, please review")
            }
            if (creditCard.setExpDate(Int(ExpTextBox.text!)!, yr: Int(expYearTextBox.text!)!) == false){
                AlertUser("Problem with expiration date, please review")
            }
            if (creditCard.setCCV(Int(CCVTextBox.text!)!) == false) {
                AlertUser("Problem with CCV, please review")
            }
            transaction.processPayment(transaction.amountDue, transactionType: .Credit)
            if transaction.balanced {
                performSegueWithIdentifier("OrderSummary", sender: nil)
            }
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let summaryView = segue.destinationViewController as? OrderSummaryViewController {
            summaryView.transaction = self.transaction
        }
    }
    
    func checkForm() -> Bool{
        if (CCNumberTextBox.text == "" || CCNumberTextBox.text == nil) {
            AlertUser("Card Number cannot be blank")
            CCVTextBox.becomeFirstResponder()
            return false
        }
        if (ExpTextBox.text == "" || ExpTextBox.text == nil) {
            AlertUser("Expiration Month cannot be blank")
            return false
        }
        if (expYearTextBox.text == "" || expYearTextBox.text == nil) {
            AlertUser("Expiration Year cannot be blank")
            return false
        }
        if (CCVTextBox.text == "" || CCVTextBox.text == nil) {
            AlertUser("CCV cannot be blank")
            return false
        }
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        setLabels()
    }
    
    func setLabels() {
        subTotal.text = String(format:"$%.2f", transaction.TransactionOrder.Subtotal)
        tax.text = String(format: "$%.2f", transaction.TransactionOrder.Tax)
        amountDue.text = String(format: "$%.2f", transaction.amountDue)
    }
    
    func AlertUser(message: String) {
        let alert = UIAlertController(title: "Payment Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
