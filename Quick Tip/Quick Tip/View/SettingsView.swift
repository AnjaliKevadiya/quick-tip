//
//  SettingsView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/22/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
//    var colorScheme: ColorScheme
    
    var body: some View {
        NavigationView {
            VStack() {
                Divider()
                
                ZStack{
                    Rectangle()
//                        .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
//                        .opacity(colorScheme == .dark ? 1 : 0.5)
                        .cornerRadius(10)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
//                        .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
//                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

                    HStack {
                        Image(systemName: "circle")
                        Text("Tip Guide")
                    }
                }
                
                Spacer()
            }
        .padding()
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
