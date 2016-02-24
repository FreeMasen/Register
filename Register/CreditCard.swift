//
//  CreditCard.swift
//  Register
//
//  Created by Robert Masen on 2/15/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation
import UIKit

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