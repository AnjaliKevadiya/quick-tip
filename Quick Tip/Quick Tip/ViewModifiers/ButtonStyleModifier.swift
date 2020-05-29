//
//  ButtonStyleModifier.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/21/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct ButtonStyleModifier: ButtonStyle {
    
    var scheme: ColorScheme
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(Variable.iPhoneSE ? 7 : 10)
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(self.scheme == .dark ? Color.darkEnd : Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(self.scheme == .dark ? Color.darkestGray : Color.lightGray2, lineWidth: 4)
                                    .blur(radius: 1)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(self.scheme == .dark ? Color.darkStart : Color.white, lineWidth: 4)
                                    .blur(radius: 1)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                    } else {
                        Circle()
                            .fill(self.scheme == .dark ? Color.darkEnd : Color.offWhite)
                            .shadow(color: self.scheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: 1, x: -2, y: -2)
                            .shadow(color: self.scheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 1, x: 2, y: 2)
                    }
                }
            )
    }
}

