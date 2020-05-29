//
//  Variables.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/29/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct Variable {
    
    static var iPhone8PlusOrLater : Bool {
        if UIScreen.main.bounds.height >= 736 {
            return true
        } else {
            return false
        }
    }

    static var iPhoneSE : Bool {
        if UIScreen.main.bounds.height <= 568 {
            return true
        } else {
            return false
        }
    }

    static var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.windows.first?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
}
