//
//  RoundedRectangleView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/28/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct RoundedRectangleView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
            .opacity(colorScheme == .dark ? 1 : 0.5)
            .cornerRadius(cornerRadius)
            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)
    }
}
