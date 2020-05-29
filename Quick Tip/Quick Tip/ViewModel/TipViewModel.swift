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
    
    @Published var billAmount: String = "" {
        didSet {
            if billAmount.count > 6 && oldValue.count <= 6 {
                billAmount = oldValue
            }
        }
    }
//    var isRememberLastTip = UserDefaults.standard.bool(forKey: "RememberLastTip")

    @Published var tipPercentage: Double = 0
    @Published var person: String = "1" {
        didSet {
            if person.count > 2{
                person = oldValue
            }
        }
    }

    private var subCancellable1: AnyCancellable!
    private var subCancellable2 : AnyCancellable!
    private var validCharSetForAmount = CharacterSet(charactersIn: "1234567890.")
    private var validCharSetForPerson = CharacterSet(charactersIn: "1234567890")

    init() {
        
        subCancellable1 = $billAmount.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSetForAmount.inverted) != nil {
                //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                DispatchQueue.main.async {
                    self.billAmount = String(self.billAmount.unicodeScalars.filter {
                        self.validCharSetForAmount.contains($0)
                    })
                }
            }
        }
        
        subCancellable2 = $person.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSetForPerson.inverted) != nil {
                //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                DispatchQueue.main.async {
                    self.person = String(self.person.unicodeScalars.filter {
                        self.validCharSetForPerson.contains($0)
                    })
                }
            }
        }
    }

    deinit {
        subCancellable1.cancel()
        subCancellable2.cancel()
    }

    var tipAmount: Double {
        
        guard let billAmount = Double(billAmount) else { return 0 }
        let tipAmount = billAmount * tipPercentage / 100
        return tipAmount
    }

    var totalAmount: Double {
        guard let billAmount = Double(billAmount) else { return 0 }
        let total = billAmount + tipAmount
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
