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

class TipViewModel: ObservableObject {
    
    @Published var billAmount: String = "" {
        didSet {
            if billAmount.count > 6 && oldValue.count <= 6 {
                billAmount = oldValue
            }
        }
    }
    
    @Published var tipPercentage: Double = 0//!UserDefaults.isRememberLastTip ? 0 : UserDefaults.lastTip {
//        willSet {
//            UserDefaults.lastTip = newValue
//        }
//    }
    
    @Published var person: Int = 1
    
//    @Published var isRememberLastTip: Bool = UserDefaults.isRememberLastTip {
//        willSet {
//            UserDefaults.isRememberLastTip = newValue
//        }
//    }
//    
//    @Published var isRoundResultsUp: Bool = UserDefaults.isRoundResultsUp {
//        willSet {
//            UserDefaults.isRoundResultsUp = newValue
//        }
//    }

    private var subCancellable1: AnyCancellable!
    private var validCharSetForAmount = CharacterSet(charactersIn: "1234567890.")

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
        return tipAmount / Double(person)
    }
    
    var totalPerPerson: Double {
        return totalAmount / Double(person)
    }
    
    func increasePerson() {
        person = person + 1
    }
    
    func removePerson() {
        if person != 1 {
            person = person - 1
        }
    }

    deinit {
        subCancellable1.cancel()
    }
}
