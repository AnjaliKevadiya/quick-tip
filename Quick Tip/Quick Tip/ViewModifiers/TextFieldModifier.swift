//
//  TextFieldModifier.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/21/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct TextFieldModifer: ViewModifier {
    
    var scheme: ColorScheme
    func body(content: Content) -> some View {
        content
        .background(scheme == .dark ? Color.darkEnd : Color.offWhite)
            .font(.system(size: Variable.iPhoneSE ? 15 : 18, weight: .medium, design: .rounded))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(scheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 6)
                .shadow(color: scheme == .dark ? Color.darkestGray : Color.lightGray2, radius: 3, x: 6, y: 6)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: scheme == .dark ? Color.darkStart : Color.white, radius: 2, x: -4, y: -4)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        )
        .cornerRadius(15)
        .keyboardType(.decimalPad)

    }
}
