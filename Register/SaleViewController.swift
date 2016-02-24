//
//  SaleViewController.swift
//  Register
//
//  Created by Robert Masen on 2/13/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit

class SaleViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedItem : Int?
    var order = Order()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        subtotalLabel.text = "$\(order.Subtotal)"
        taxLabel.text = String(format: "$%.2f", order.Tax)
        totalLabel.text = String(format: "$%.2f", order.Total)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product = order.Items[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Product")
        cell.textLabel?.text = product.Name
        cell.detailTextLabel?.text = "$\(product.Price)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.Items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedItem = indexPath.row
    }
    
    @IBAction func removeItem(sender: AnyObject) {
        if selectedItem != nil {
            order.Items.removeAtIndex(selectedItem!)
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tabBarController = segue.destinationViewController as? UITabBarController {
            for view in tabBarController.viewControllers! {
                if let tenderController = view as? TenderViewController {
                    tenderController.transaction = Transaction(order: self.order)
                }
            }
        }
    }
}