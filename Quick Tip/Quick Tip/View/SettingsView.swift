//
//  SettingsView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/22/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var iPhoneSE : Bool {
        if UIScreen.main.bounds.height <= 568 {
            return true
        } else {
            return false
        }
    }

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.windows.first?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }

    @Environment(\.colorScheme) var colorScheme
    @State var isNavigationBarHidden: Bool = true
    @ObservedObject var tipViewModel = TipViewModel()
    
    @State private var remmemberTip: Bool = false
    @State private var roundResultsUp: Bool = false
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
                    Divider()
                        
                    ZStack{
                        RoundedRectangleView()
//                        Rectangle()
//                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
//                            .opacity(colorScheme == .dark ? 1 : 0.5)
//                            .cornerRadius(10)
//                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
//                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
//                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

                        Toggle(isOn: $remmemberTip) {
                            Text("Remmember last tip")
                                .font(.system(size: iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))

                            }
                        .padding(20)
                        .frame(height: 60)
                    }
                    
                    ZStack{
                        RoundedRectangleView()

                        HStack {
                            Text("Round Results Up")                                .font(.system(size: iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))

//                            Image(systemName: "text.badge.plus")
                            Spacer()
                            
                            Toggle(isOn: $roundResultsUp) {
                                Text("")
                            }
//                            ZStack {
//                                LinearGradient(
//                                    gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]),
//                                    startPoint: .leading,
//                                    endPoint: .trailing)
//                                    .mask(Toggle(isOn: $roundResultsUp) {
//                                        Text("")
//                                    })
//
//                                Toggle(isOn: $roundResultsUp) {
//                                    Text("")
//                                }.opacity(0.02)
//                            }.frame(height: 50)
                            
                        }
                        .padding(20)
                        .frame(height: 60)
                    }

                    ZStack{
                        RoundedRectangleView()

                        HStack {
//                            Image(systemName: "star")
                            Text("Rate Us")
                                .font(.system(size: iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))

                            Spacer()
                        }
                            .padding(20)
                            .onTapGesture {
                                let urlString = "https://apps.apple.com/us/app/quick-tip-calculator/id1513029460?action=write-review"
                                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
                            }
                    }
                    
                    ZStack{
                        RoundedRectangleView()

                        HStack() {
//                            Image(systemName: "arrowshape.turn.up.right")
                            Text("Share")
                            .font(.system(size: iPhoneSE ? 16 : 18, weight: .regular, design: .rounded))

                            Spacer()
                        }
                            .padding(20)
                            .onTapGesture {
                                self.shareApp = true
                            }
                            .sheet(isPresented: $shareApp, onDismiss: {
                                print("Dismiss")
                                self.shareApp = false
                            }, content: {
                                ActivityViewController(billText: "https://apps.apple.com/us/app/quick-tip-calculator/id1513029460?ls=1")
                            })
                    }

                    Spacer()
                }.padding(.horizontal, 20)
                .padding(.vertical, iPhoneSE ? 20 : hasSafeArea ? 0 : 15)//5
            }
            .navigationBarTitle(Text("Settings"), displayMode: hasSafeArea ? .large : .inline)
//            .navigationBarHidden(self.isNavigationBarHidden)
//            .onAppear {
//                self.isNavigationBarHidden = self.iPhoneSE ? true : false
//            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


