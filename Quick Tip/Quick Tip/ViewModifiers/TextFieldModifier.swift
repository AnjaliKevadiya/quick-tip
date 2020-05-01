//
//  TextFieldModifier.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 4/30/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.offWhite)
            .cornerRadius(15)
            .keyboardType(.decimalPad)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 4)
                    .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255), radius: 3, x: 6, y: 6)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.white, radius: 2, x: -4, y: -4)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            )
//            .foregroundColor(.black)
//            .background(
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color.white)
//                    .frame(height: 50)
//                                .shadow(color: Color.white.opacity(1), radius: 5, x: -3, y: -3)
//                                .shadow(color: Color.lightPurple.opacity(0.4), radius: 5, x: 3, y: 3)
//
//                    .shadow(color: Color.peachColor.opacity(0.17), radius: 5, x: -5, y: -4)
//                    .shadow(color: Color.darkPeachColor.opacity(0.17), radius: 5, x: 5, y: 4)
//            )

    }
}
