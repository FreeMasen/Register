import UIKit

class OrderSummaryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableVIew: UITableView!
    
    var transaction = Transaction()
    var orderAsArray = [String]()
    var moneyAsArray = [String]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderAsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "summary")
        cell.textLabel?.text = orderAsArray[indexPath.row]
        print(orderAsArray[indexPath.row])
        cell.detailTextLabel?.text = moneyAsArray[indexPath.row]
        print(moneyAsArray[indexPath.row])
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Order", style: .Plain, target: self, action: "newOrder")
        
        createOrderSummary()
        tableVIew.reloadData()
    }
    
    func createOrderSummary() {
            for game in transaction.TransactionOrder.Items {
                orderAsArray.append(game.Name)
                moneyAsArray.append(String(format: "$%.2f", game.Price))
            }
            orderAsArray.append("Subtotal")
            moneyAsArray.append(String(format: "$%.2f", transaction.TransactionOrder.Subtotal))
            orderAsArray.append("Tax")
            moneyAsArray.append(String(format: "$%.2f", transaction.TransactionOrder.Tax))
            orderAsArray.append("Total")
            moneyAsArray.append(String(format: "$%.2f", transaction.TransactionOrder.Total))
            orderAsArray.append("Transaction type")
            moneyAsArray.append(String(transaction.Type))
            orderAsArray.append("Amount provided")
            moneyAsArray.append(String(format: "$%.2f", transaction.amountProvided))
            orderAsArray.append("Change due")
            moneyAsArray.append(String(format: "$%.2f", transaction.amountDue))
        
    }
    
    func newOrder() {
        performSegueWithIdentifier("newOrder", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mainView = segue.destinationViewController as? MainViewController {
            mainView.order = Order()
        }
    }
}