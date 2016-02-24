//
//  Transaction.swift
//  Register
//
//  Created by Robert Masen on 2/15/16.
//  Copyright © 2016 Robert Masen. All rights reserved.
//

import Foundation

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