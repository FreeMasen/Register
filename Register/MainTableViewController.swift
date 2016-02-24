//
//  MainTableViewController.swift
//  Register
//
//  Created by Robert Masen on 2/13/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import UIKit

class MainTableViewController : UITableView {
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Product")
        cell.textLabel?.text = product.Name
        cell.detailTextLabel?.text = product.Description
        return cell
    }

}