//
//  NumberOfPersonsView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/25/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct NumberOfPersonsView: View {

        @Binding var value: Int
        
        var body: some View {
            Picker(selection: $value, label: Text("")) {

                    ForEach(0 ..< 100) {
                        Text("\($0)").tag($0)
                        .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .semibold, design: .rounded))
                    }
            }.pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(width: Variable.iPhoneSE ? 36 : 50, height: 30)
            .cornerRadius(15)
        }
}
