//
//  StoreKitHelper.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/20/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import Foundation
import StoreKit

struct StoreKitHelper {
    static let numberOfTimesLaunchedKey = "numberOfTimesLaunched"
    
    static func displayStoreKit() {
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return
        }
        
        let lastVersionPromotedForReview = UserDefaults.standard.string(forKey: "lastVersion")
        let numberOfTimesLaunched: Int = UserDefaults.standard.integer(forKey: StoreKitHelper.numberOfTimesLaunchedKey)
        
        if numberOfTimesLaunched > 5 && currentVersion != lastVersionPromotedForReview {
            
            SKStoreReviewController.requestReview()
            UserDefaults.standard.set(currentVersion, forKey: "lastVersion")
        }
    }
    
    static func incrementNumberOfTimesLaunched() {
        let numberOfTimesLaunched: Int = UserDefaults.standard.integer(forKey: StoreKitHelper.numberOfTimesLaunchedKey) + 1
        UserDefaults.standard.set(numberOfTimesLaunched, forKey: StoreKitHelper.numberOfTimesLaunchedKey)
    }
}
