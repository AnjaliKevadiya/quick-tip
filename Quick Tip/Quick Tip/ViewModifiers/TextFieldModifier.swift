//
//  TextFieldModifier.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/21/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct TextFieldModifer: ViewModifier {
    
    var iPhoneSE : Bool {
        if UIScreen.main.bounds.height <= 568 {
            return true
        } else {
            return false
        }
    }

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.windows.first?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }

    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
        .background(colorScheme == .dark ? Color.darkEnd : Color.offWhite)
        .font(.system(size: iPhoneSE ? 15 : 18, weight: .medium, design: .rounded))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 6)
                .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightGray2, radius: 3, x: 6, y: 6)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white, radius: 2, x: -4, y: -4)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        )
        .cornerRadius(15)
        .keyboardType(.decimalPad)

    }
}
