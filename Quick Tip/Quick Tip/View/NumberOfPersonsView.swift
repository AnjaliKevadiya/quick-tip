//
//  NumberOfPersonsView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/25/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct NumberOfPersonsView: View {
    
        var toDisplay:String {
            get {
                return "Sel \(value)"
            }
        }

        @Binding var value: Int
        
        var body: some View {
//            ZStack {
//                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)

//            HStack{
//                        Text(toDisplay)

                        Picker(selection: $value, label: Text("")) {

                                ForEach(0 ..< 100) {
                                    Text("\($0)").tag($0)
                                    .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .semibold, design: .rounded))
                                }
                            }.pickerStyle(WheelPickerStyle())
                            .labelsHidden()
                            .frame(width: Variable.iPhoneSE ? 36 : 50, height: 30)
                            .cornerRadius(15)
//                            .background(Color.red)
                        }
//            }
//        }
}
