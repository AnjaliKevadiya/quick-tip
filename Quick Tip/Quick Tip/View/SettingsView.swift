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
                        
                    ZStack{
                        RoundedRectangleView(cornerRadius: 15)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 50)

                        HStack {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(
                                    Image(systemName: "text.badge.checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                            .padding(.trailing, 10)

                            Toggle(isOn: $tipViewModel.isRememberLastTip) {
                                Text("Remember Last Tip")
                                    .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))
                            }
                            .frame(height: Variable.iPhoneSE ? 50 : 70)
                        }
                        .padding(Variable.iPhoneSE ? 15 : 20)
                        .frame(height: Variable.iPhoneSE ? 50 : 60)
                    }
                    
                    ZStack{
                        RoundedRectangleView(cornerRadius: 15)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 50)

                        HStack {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(
                                    Image(systemName: "pencil.and.outline")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                            .padding(.trailing, 10)

                            Toggle(isOn: $tipViewModel.isRoundResultsUp) {
                                Text("Round Results Up")                                .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))
                                    .multilineTextAlignment(.leading)
                                    .frame(width: Variable.iPhoneSE ? 126 : 142)
                            }
                            .onAppear(perform: {
                                print("setting value \(self.$tipViewModel.isRoundResultsUp)")
                            })
                            .frame(height: Variable.iPhoneSE ? 50 : 60)
                            
//                            .toggleStyle(ColoredToggleStyle(onColor: .darkBlueColor, offColor: .lightGray1, thumbColor: .white))
                        }
                        .padding(Variable.iPhoneSE ? 15 : 20)
                        .frame(height: Variable.iPhoneSE ? 50 : 60)
                    }

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

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}


struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white

    func makeBody(configuration: Self.Configuration) -> some View {
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
    }
}
