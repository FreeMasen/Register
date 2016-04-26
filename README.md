Register
===============
Class project for iOS

User Experience
----------------------
#### Basic Use
When the user opens the application, they are greeted with a list of products that have been previously added to the application.
The user can select an item from this list a touch the add to order button, this will update the subtotal and order count. 

*TODO: add SS of Main Screen*

If the user does not see the desired item on the list, he/she can click the "add item" button (see below)

once the order has all the items required, the user can touch "View Order" This will bring them to an Order Summary screen, where
items can be removed or the user can select "check out"

![summary screen](http://i.imgur.com/8RJ9aJK.png)

when the user has selected check out they are brought to a tender screen, this will give them the option to submit as many payments
as required by the customer, the tabs at the bottom will allow switching between credit and cash.

Once the payment is >= the total cost of the order, the user is moved to the reciept screen, which summarizes the full transaction.

![tender screen](http://i.imgur.com/M7x1vYF.png)

the user can then select "New Order" to start again.

![Reciept](http://i.imgur.com/env0On1.png)

##### Add Item
On this screen a user can add items to the list of products that appears on the main screen.
Filling in the fields on this screen are all that is required to add a new product.

![Add Item SS](http://i.imgur.com/RFX8PI1.png)

Code
-----------
The application utilizes a few simple objects to keep track of user actions.
##### Product
used to represent a product for sale
```
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
```
##### Order
used to collect products and calculate totals
```
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
```
##### Transaction
used to capture payment information
```
class Transaction {
    
    var TransactionOrder: Order
    var Type = TransactionType.none
    var amountProvided : Double = 0
    var amountDue: Double {
        return TransactionOrder.Total - amountProvided
    }
    var balanced : Bool {
        if amountDue <= 0 {
            return true
        } else {
            return false
        }
    }
    
    init(order: Order){
        TransactionOrder = order
    }
    
    convenience init(){
        self.init(order: Order())
    }
    
    func processPayment(payment: Double, transactionType: TransactionType) {
        self.Type = transactionType
        amountProvided += payment
    }
    
    
}

enum TransactionType {
    case none
    case Cash
    case Credit
}
```
##### Credit Card
Used for validating imput on Tender screen
```
class CreditCard {
    var CardNumber : String
    var ExpirationMonth : Int
    var ExpirationYear : Int
    var CCV : Int
    
    init(){
        self.CardNumber = ""
        self.ExpirationMonth = 0
        self.ExpirationYear = 0
        self.CCV = 0
    }
    
    func setCardNumber(ccNumber: String) -> Bool {
        if checkCardNumber(ccNumber) {
            CardNumber = ccNumber
            return true
        }
        return false    
    }
    
    func setExpDate(mo : Int, yr:Int) -> Bool {
        if checkExpirationMonth(mo) && checkExpirationYear(yr) {
            ExpirationMonth = mo
            ExpirationYear = yr
            return true
        }
        return false
    }
    
    func setCCV(code: Int) -> Bool{
        if checkCCV(code) {
            CCV = code
            return true
        }
        return false
    }
    
    func checkCardNumber(ccNumber: String) -> Bool{
        if ccNumber.characters.count < 16 || ccNumber.characters.count < 16 {
            return false
        }
        if !containsNoLetters(CardNumber) {
            return false
        }
        return true
    }
    
    func checkExpirationMonth(mo: Int) -> Bool {
        if mo <= 0 || mo > 12 {
            return false
        }
        return true
    }
    
    func checkExpirationYear(yr: Int) -> Bool {
        let currentYear = NSCalendar.currentCalendar().component(.Year, fromDate: NSDate())
        if yr < 100 {
            
            if (yr + 2000) < currentYear {
                return false
            }
        } else {
            if (yr < currentYear) {
                return false
            }
        }
        return true
    }
    
    func checkCCV(code: Int) -> Bool {
        if code < 100 {
            return false
        }
        return true
    }
    
    func containsNoLetters(string: String) -> Bool {
        for letter in string.characters {
            if !"1234567890".containsString(String(letter)) {
                return false
            }
        }
        return true
    }
}
```
##### JSON Handler
Static class used to read and save the products to a .json file for persistance
###### Load
The getProducts function leverages the NSFilemanger made available by Foundation
to pull the raw data from our .json file, it then utilizes Foundations NSJSONSerilization to process that
into the correct swift datatypes and generaet an array of Product objects.
The ensureJSONFileExists method checks if a file has been created and if it has not, it copies the 
file from the application bundle into the document store
###### Save
The saveProducts function fist turns our list of Products into an NSDictionary, to more closly resemble the JSON
it will later become. It then converts the to an NSData object which is a raw data version of the information.
The NSDictionary object can be passed to the NSJSONSerilization object to converet it to the approprate encoding for
reading in the load method.  The NSFilemanager is then used to save the file to the document store.
```
class JSONHandler {
    
    static let fileManager = NSFileManager.defaultManager()
    
//Load
    
    static func getProducts() -> [Product]? {
        
            if let data = getJSONData("Products") {
                if let dict = JSONtoDictionary(data){
                    if let products = getJSONArray(dict) {
                        return products
                    }
                }
            }
        
        return nil
    }

    static func ensureJSONFileExists() -> Bool {
        let folderPath = NSSearchPathForDirectoriesInDomains(.DeveloperDirectory, .AllDomainsMask, true)[0]
        let intendedPath = getPath("Products")
        try? fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
        if !(fileManager.fileExistsAtPath(intendedPath)) {
            if let bundlePath =  NSBundle.mainBundle().pathForResource("Product", ofType: "json") {
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: intendedPath)
                    return true
                } catch {
                    print(error)
                    return false
                }
            }
        } else {
            return true
        }
        return false
    }
    
    private static func getPath(filename: String) -> String {
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DeveloperDirectory, .UserDomainMask, true)[0]
        let fullPath = "\(basePath)/\(filename).json"
        return fullPath
    }
    
    
    private static func getJSONData(fileName: String) -> NSData? {
        let path = getPath(fileName)
        if let jsonData = fileManager.contentsAtPath(path) {
            return jsonData
        }
        return nil
    }
    
    
    private static func JSONtoDictionary(JSONData : NSData) -> NSDictionary? {
        if let dictionary = (try? NSJSONSerialization.JSONObjectWithData(JSONData,  options: .MutableContainers)) as? NSDictionary{
            return dictionary
        }
        return nil
    }
    
    private static func getJSONArray(dataDictionary : NSDictionary) -> [Product]? {
        var products = [Product]()
        if let ps = dataDictionary["Products"]! as? NSArray {
        for a in ps {
            let id = a["Id"]! as! String
            let name = a["Name"]!as! String
            let price = a["Price"] as! String
            let desc = a["Description"] as! String
            products.append(Product(id: Int(id)!, name: name, price: Double(price)!, desc: desc))
        }
        if products.count > 0 {
        return products
        
        }else {
            return nil
        }
        }
        return nil
    }

    
//Save
    
    static func saveProducts(products : [Product]) {
        if let dictionary = arrayToDict(products) {
            if let nsDictionary = createNSDict(dictionary) {
                if let nsData = nsDataFromDictionary(nsDictionary) {
                    saveNSDataToFile(nsData)
                }
                
            }
        }
    }
    
    
    static private func arrayToDict(array: [Product]) -> [String : [[String : String]]]? {
        var dictionary = [String : [[String : String]]]()
        var arrayOfDictionaries = [[String: String]]()
        for product in array {
            var subDictionary = [String : String]()
            subDictionary["Id"] = String(product.Id)
            subDictionary["Name"] = product.Name
            subDictionary["Price"] = String(product.Price)
            subDictionary["Description"] = product.Description
            arrayOfDictionaries.append(subDictionary)
        }
        dictionary["Products"] = arrayOfDictionaries
        
        if dictionary.count > 0 {
            return dictionary
        } else {
            return nil
        }
    }
    
    static private func createNSDict(dict: [String: [[String : String]]]) -> NSDictionary? {
        let nsDict = NSDictionary(dictionary: dict)
        if nsDict.count > 0 {
            return nsDict
        }
        return nil
    }
    
    static private func nsDataFromDictionary(nsDictionary : NSDictionary) -> NSData? {
        if let json = try? NSJSONSerialization.dataWithJSONObject(nsDictionary, options: .PrettyPrinted) {
            return json
        }
        return nil
    }
    
    private static func saveNSDataToFile(data : NSData) {
        let path = getPath("Products")
        fileManager.createFileAtPath(path, contents: data, attributes: nil)
    }

    

    
    static func saveNSData(data: NSData) {
        let fileManager = NSFileManager.defaultManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory , .UserDomainMask, true)[0]
        path.appendContentsOf("/AppFiles")
        if !(fileManager.fileExistsAtPath(path)) {
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let pathWithFile = "\(path)/Products.json"
        if fileManager.createFileAtPath(pathWithFile, contents: data, attributes: nil) {
            print("success")
        } else {
            print("failure")
        }
    }
    
    
    private static func ensureFolderExists(folderName: String) {
        let basePath = getPath("Products")
        if !(fileManager.fileExistsAtPath(basePath)) {
            do {
                try fileManager.createDirectoryAtPath(basePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
    }
    
    static func getProductsFromBundle() -> [Product]? {
        if let bundlePath =  NSBundle.mainBundle().pathForResource("Product", ofType: "json") {
            if let data = fileManager.contentsAtPath(bundlePath) {
                if let dictionary = JSONtoDictionary(data) {
                    if let products = getJSONArray(dictionary) {
                        return products
                    }
                }
            }
        }
        return nil
    }
    
    private static func copyFileFromBundle() {
        let path = getPath("Products")
        if let data = fileManager.contentsAtPath(NSBundle.mainBundle().pathForResource("Product", ofType: "json")!) {
            fileManager.createFileAtPath(path, contents: data, attributes: nil)
        }
        
    }
}
```
##### Veiw Controllers
The main view controller contains an array of Products, this is used to populated the tableview
the add products view controller contains an array of products that is populated by the main view controller during the segue
this is then saved to the .json file and re-read in by the main controller since this happens every time the view appears.

```
if let newProductView = segue.destinationViewController as? NewProductViewController { 
    newProductView.products = self.products
}
```
```

```
The main view controller also contains an Order object, this keeps track of the items that have been added to the current order.
This object is passed to the Order object that appears on the Sale View controller, to provide further details on the current
order and allow for products to be removed.

```
if let saleView = segue.destinationViewController as? SaleViewController { 
    saleView.order = self.order 
}
```

The Sale view controller passes its Order object to the Transaction object on the Tender view controller. This Transaction object 
keeps track of the total the customer has paid and compares that to the order total. Onces the amount paid is >= the order total, 
this triggers the segue to the Order Summary view controller

```
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
```
the Order Summary view controller simply displays the reciept for the completed order and allows for movement back to the main
view controller
