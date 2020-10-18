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
    @Environment(\.presentationMode) var presentationMode
    
    @State private var shareApp: Bool = false

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
//                        RoundedRectangleView(cornerRadius: 15)
//                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 50)
//
//                        HStack {
//                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
//                                .mask(
//                                    Image(systemName: "text.badge.checkmark")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
//                            .padding(.trailing, 10)
//
//                            Toggle(isOn: $tipViewModel.isRememberLastTip) {
//                                Text("")
//                            }
//                            .toggleStyle(ColoredToggleStyle(label: "Remember Last Tip", onColor: Color.darkBlueColor.opacity(0.8), offColor: colorScheme == .dark ? Color.darkStart : Color.lightGray1, thumbColor: colorScheme == .dark ? Color.lightGray1 : Color.white))
//                        }
//                        .padding(Variable.iPhoneSE ? 15 : 20)
//                        .frame(height: Variable.iPhoneSE ? 50 : 60)
//                        .onReceive([self.$tipViewModel.isRememberLastTip].publisher.first()) { (value) in
//                            print("setting receiver tip \(value)")
//                        }
//                    }
                    
//                    ZStack{
//                        RoundedRectangleView(cornerRadius: 15)
//                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 50)
//
//                        HStack {
//                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
//                                .mask(
//                                    Image(systemName: "pencil.and.outline")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
//                            .padding(.trailing, 10)
//
//                            Toggle(isOn: $tipViewModel.isRoundResultsUp) {
//                                Text("Round Results Up")                                .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))
//                                    .multilineTextAlignment(.leading)
//                                    .frame(width: Variable.iPhoneSE ? 126 : 142)
//                            }
//                            .onAppear(perform: {
//                                print("setting value \(self.$tipViewModel.isRoundResultsUp)")
//                            })
//                            .frame(height: Variable.iPhoneSE ? 50 : 60)
//                            
//                            .toggleStyle(ColoredToggleStyle(onColor: .darkBlueColor, offColor: .lightGray1, thumbColor: .white))
//                        }
//                        .padding(Variable.iPhoneSE ? 15 : 20)
//                        .frame(height: Variable.iPhoneSE ? 50 : 60)
//                    }

                    ZStack{
                        RoundedRectangleView(cornerRadius: 15)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 50)

                        HStack {
                            
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(
                                    Image(systemName: "star")
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
                        RoundedRectangleView(cornerRadius: 15)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 50)

                        HStack() {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(
                                    Image(systemName: "arrowshape.turn.up.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                            .padding(.trailing, 10)

                            Text("Tell a Friend")
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
                        ActivityViewController(textToShare: """
                        Quick Tip - Calculator provides fastest bill entry and tip selection for automated tip calculation with split functionality.

                        https://apple.co/36GmePy
                        """)
                    })
                    
                    Spacer()
                    
                }.padding(.horizontal, 20)
                    .padding(.vertical, Variable.hasSafeArea ? 0 : 15)
            }
            .navigationBarTitle(Text("Settings"), displayMode: Variable.hasSafeArea ? .large : .inline)
            .navigationBarItems(trailing: Button(action: {
                print("pressed")
                
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                    LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                        .mask(Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    ).frame(width: Variable.hasSafeArea ? 18 : 15, height: Variable.hasSafeArea ? 18 : 15, alignment: .center)
                })
                .padding(.top, Variable.hasSafeArea ? 10 : 0)
                .padding(.trailing, 7)
            )
        }
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
                .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))
            Spacer()
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 18, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: Variable.iPhoneSE ? 44 : 56, height: Variable.iPhoneSE ? 26 : 34)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.2))

//                Group {
//                    if configuration.isOn {
//                        RoundedRectangle(cornerRadius: 16, style: .circular)
//                            .fill(onColor)
//                            .frame(width: Variable.iPhoneSE ? 44 : 52, height: Variable.iPhoneSE ? 26 : 32)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16, style: .circular)
//                                    .stroke(colorScheme == .dark ? Color.darkestGray : Color.darkBlueColor.opacity(0.7), lineWidth: 4)
//                                    .blur(radius: 1)
//                                    .offset(x: 2, y: 2)
//                                    .mask(RoundedRectangle(cornerRadius: 16, style: .circular).fill(LinearGradient(Color.black, Color.clear)))
//                            )
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16, style: .circular)
//                                    .stroke(colorScheme == .dark ? Color.darkStart : Color.lightBlueColor, lineWidth: 4)
//                                    .blur(radius: 1)
//                                    .offset(x: -2, y: -2)
//                                    .mask(RoundedRectangle(cornerRadius: 16, style: .circular).fill(LinearGradient(Color.clear, Color.black)))
//                            )
//
//                            .overlay(
//                                Circle()
//                                    .fill(thumbColor)
//                                    .shadow(radius: 1, x: 0, y: 1)
//                                    .padding(1.5)
//                                    .offset(x: 10))
//                            .animation(Animation.easeInOut(duration: 0.1))
//
//                    } else {
//                        RoundedRectangle(cornerRadius: 16, style: .circular)
//                            .fill(offColor)
//                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: 1, x: -2, y: -2)
//                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 1, x: 2, y: 2)
//
//                            .frame(width: Variable.iPhoneSE ? 44 : 52, height: Variable.iPhoneSE ? 26 : 32)
//                            .overlay(
//                                Circle()
//                                    .fill(thumbColor)
//                                    .shadow(radius: 1, x: 0, y: 1)
//                                    .padding(1.5)
//                                    .offset(x: -10))
//                            .animation(Animation.easeInOut(duration: 0.1))
//                    }
//                }
            }
        }
        .font(.title)
    }
}
