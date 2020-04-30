//
//  TipViewModel.swift
//  QuickTip - Calculator
//
//  Created by Anjali Kevadiya on 4/15/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//why we create class instade of struct is because we need to use ObservableObject
//ObservableObject will only work with Classes not Structs
//must need to add didChange event if you use ObservableObject
class TipViewModel: ObservableObject {
    
    var tipChoices = ["10", "15", "20"]

//    let tipChoices: [Any] = [10, 15, 20, "Custom"]
//    let tipChoices = [10, 15, 20]

    @Published var billAmount: String = ""
//    @Published var tipPercentage: Int = 10
    @Published var tipPercentage: Double = 0//"0"
    @Published var person: String = "1"
    
    var tipAmount: Double {
        guard let billAmount = Double(billAmount) else { return 0 }
//        guard let tipPercentage = Double(tipPercentage) else { return 0 }

        let tipAmount = billAmount * tipPercentage / 100
        return tipAmount
    }

    var totalAmount: Double {
        guard let bill = Double(billAmount) else { return 0 }
        let total = bill + tipAmount
        return total
    }
    
    var tipPerPerson: Double {
        guard let  person = Double(person) else { return 0 }
        return tipAmount / person
    }
    
    var totalPerPerson: Double {
        guard let  person = Double(person) else { return 0 }
        return totalAmount / person
    }
    
    func increasePerson() {
        let personCount = Int(person) ?? 1
        person = "\(personCount + 1)"
    }
    
    func removePerson() {
        let personCount = Int(person) ?? 1
        if personCount != 1 {
            person = "\(personCount - 1)"
        }
    }
}
