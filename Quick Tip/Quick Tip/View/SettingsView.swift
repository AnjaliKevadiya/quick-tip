//
//  SettingsView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/22/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var tipViewModel = TipViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    @State var isNavigationBarHidden: Bool = true
    @State private var rememberTip: Bool = false
    @State private var roundResultsUp: Bool = false
    @State private var shareApp: Bool = false

//    init() {
//        UISwitch.appearance().onTintColor = .orange
//    }
    
    var body: some View {
        
        NavigationView {
            ZStack() {
                
                if colorScheme == .dark {
                    Color.darkEnd
                        .edgesIgnoringSafeArea(.all)

                } else {
                    Color.offWhite
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    
                    if Variable.hasSafeArea {
                        Divider()
                            .padding(.bottom, 3)
                    }
                        
//                    ZStack{
//                        RoundedRectangleView()
//
//                        Toggle(isOn: $rememberTip) {
//                            Text("Remember last tip")
//                                .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))
//
//                        }.onTapGesture {
//                            self.rememberTip.toggle()
//                            UserDefaults.standard.set(self.rememberTip, forKey: "RememberLastTip")
////                            UserDefaults.standard.bool(forKey: "RememberLastTip")
//                        }
//                        .padding(16)
//                        .frame(height: Variable.iPhoneSE ? 50 : 60)
//                    }
                    
//                    ZStack{
//                        RoundedRectangleView()
//
//                        HStack {
//                            Text("Round Results Up")                                .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))
//                                .multilineTextAlignment(.leading)
//
//                                .frame(width: Variable.iPhoneSE ? 126 : 142)
////                            Image(systemName: "text.badge.plus")
//                            Spacer()
//
//                            Toggle(isOn: $roundResultsUp) {
//                                Text("")
//                            }
////                            ZStack {
////                                LinearGradient(
////                                    gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]),
////                                    startPoint: .leading,
////                                    endPoint: .trailing)
////                                    .mask(Toggle(isOn: $roundResultsUp) {
////                                        Text("")
////                                    })
////
////                                Toggle(isOn: $roundResultsUp) {
////                                    Text("")
////                                }.opacity(0.02)
////                            }.frame(height: 50)
//
//                        }
//                        .padding(16)
//                        .frame(height: Variable.iPhoneSE ? 50 : 60)
//                    }

                    ZStack{
                        RoundedRectangleView()

                        HStack {
                            
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(
                                    Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                            .padding(.trailing, 10)

                            Text("Rate Us")
                                .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))

                            Spacer()
                        }
                            .padding(Variable.iPhoneSE ? 15 : 20)
                    }
                    .onTapGesture {
                        let urlString = "https://apps.apple.com/us/app/quick-tip-calculator/id1513029460?action=write-review"
                        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
                    }

                    ZStack{
                        RoundedRectangleView()

                        HStack() {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(
                                    Image(systemName: "arrowshape.turn.up.right.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                            .padding(.trailing, 10)

                            Text("Share")
                            .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))

                            Spacer()
                        }
                            .padding(Variable.iPhoneSE ? 15 : 20)
                    }
                    .onTapGesture {
                        self.shareApp = true
                    }
                    .sheet(isPresented: $shareApp, onDismiss: {
                        print("Dismiss")
                        self.shareApp = false
                    }, content: {
                        ActivityViewController(textToShare: "https://apple.co/36GmePy")
                    })

                    Spacer()
                }.padding(.horizontal, 20)
                    .padding(.vertical, Variable.hasSafeArea ? 0 : 15)
            }
            .navigationBarTitle(Text("Settings"), displayMode: Variable.hasSafeArea ? .large : .inline)
//            .navigationBarItems(trailing: Button(action: {
//                print("pressed")
//            }, label: {
//                    LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
//                        .mask(Image(systemName: "xmark")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                    ).frame(width: Variable.iPhoneSE ? 18 : 15, height: Variable.iPhoneSE ? 18 : 15, alignment: .center)
//                }).buttonStyle(ButtonStyleModifier(scheme: colorScheme))
//                .padding(.top)
//            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


