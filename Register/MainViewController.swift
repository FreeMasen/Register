//
//  ViewController.swift
//  Register
//
//  Created by Robert Masen on 2/13/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ProductsTableView: UITableView!
    @IBOutlet weak var numOfItemsLabel: UILabel!
    
    var products = [Product]()
    var order = Order()
    var selectedgame: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JSONHandler.ensureJSONFileExists()
        debug()
        getAvailableProducts()
        ProductsTableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getAvailableProducts()
        updateView()
        ProductsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let saleView = segue.destinationViewController as? SaleViewController {
            saleView.order = self.order
        } else {
            if let newProductView = segue.destinationViewController as? NewProductViewController {
                newProductView.products = self.products
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedgame = indexPath.row
        priceLabel.text = "$\(products[selectedgame!].Price)"
    }
    
    @IBAction func touchAddToOrder(sender: AnyObject) {
        if selectedgame != nil {
            order.AddItem(products[selectedgame!])
            updateView()
        }
        
    }
    
    @IBAction func resetOrder(sender: AnyObject) {
        order = Order()
        updateView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Product")
        cell.textLabel?.text = product.Name
        cell.detailTextLabel?.text = product.Description
        return cell
    }
    
    func updateView() {
        subtotalLabel.text = String(format: "$%.2f", order.Subtotal)
        numOfItemsLabel.text = "\(order.Items.count)"
    }
    
    
    
    func getAvailableProducts() {
        if let newProducts = JSONHandler.getProducts() {
            self.products = newProducts
        } else {
            if let secondTry = JSONHandler.getProductsFromBundle() {
                self.products = secondTry
            }
        }
    }
    
    func saveProducts(){
        JSONHandler.saveProducts(self.products)
    }
    
    func debug() {
        JSONHandler.debug()
    }
}
