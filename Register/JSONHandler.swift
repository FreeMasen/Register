//
//  JSONHandler.swift
//  Register
//
//  Created by Robert Masen on 2/15/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

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