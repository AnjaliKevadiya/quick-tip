//
//  ContentView.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 4/30/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
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

    @State private var refresh = false
    @State private var isShowCloseButton = false
    @State var isNavigationBarHidden: Bool = true
    @State var keyboardHeight: CGFloat = 0
    @State private var isSharePresented: Bool = false
    @State private var isSettingPresented: Bool = false
    
    @ObservedObject var tipViewModel = TipViewModel()
    @Environment(\.colorScheme) var colorScheme

    init() {
        if colorScheme == .dark {
            UITextField.appearance().tintColor = .gray
        } else {
            UITextField.appearance().tintColor = .gray
        }
        
        let fontSize: CGFloat = 34
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let font: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
}
    
    var body: some View {
        
        NavigationView {

            ZStack{
                if colorScheme == .dark {
                    Color.darkEnd
                        .edgesIgnoringSafeArea(.all)

                } else {
                    Color.offWhite
                        .edgesIgnoringSafeArea(.all)
                }
//                .gesture(DragGesture().onChanged{_ in
//                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                })

                VStack {
                    ZStack{

                        TextField("Enter bill amount" + (refresh ? "" : " "), text: $tipViewModel.billAmount, onEditingChanged: { _ in
                            self.isShowCloseButton.toggle()
                        })
                        .modifier(TextFieldModifer())

                        HStack {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(Text("$").font(.system(size: iPhoneSE ? 22 : 26, weight: .semibold, design: .rounded))
                            ).frame(width: iPhoneSE ? 26 : 30, height: iPhoneSE ? 26 : 30, alignment: .center)
                                .padding(.leading, 20)
                            Spacer()
                        }

                        if isShowCloseButton {
                            HStack {
                                Spacer()
                                Button(action: closeButtonTap) {
                                    LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                        .mask(Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    ).frame(width: iPhoneSE ? 13 : 15, height: iPhoneSE ? 13 : 15)
                                }
                            }.padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, iPhoneSE ? 5 : hasSafeArea ? 15 : 10)

                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
                            .opacity(colorScheme == .dark ? 1 : 0.5)
                            .cornerRadius(25)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 100, maxHeight: 120)
                        .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

                        VStack {
                            HStack {
                                Text("Tip")
                                    .font(.system(size: iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))

                                Text(" - ")
                                    .font(.system(size: iPhoneSE ? 15 : 17, weight: .medium, design: .rounded))

                                Text("\(tipViewModel.tipPercentage, specifier: "%.0f") %")
                                    .font(.system(size: iPhoneSE ? 15 : 17, weight: .medium, design: .rounded))

                                Spacer()

                                Text("$ \(tipViewModel.tipAmount, specifier: "%.2f")")
                                    .font(.system(size: iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.darkBlueColor)
                            }
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                    .mask(Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1))
                                Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1)
                                    .opacity(0.02)
                                .contentShape(Rectangle())

                            }.frame(height: 30, alignment: .bottom)
                            .padding(.top, iPhoneSE ? 10 : 15)

                        }.padding(.horizontal, 15)
                    }
                    .padding(.bottom, iPhoneSE ? 5 : 7)
                    Spacer()

                    ZStack {
                        if iPhoneSE{
                            HStack{

                                Text("Total Amount")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2)
                                    .multilineTextAlignment(.leading)

                                Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.darkBlueColor)
                                    .lineLimit(1)
                            }.padding(.horizontal, 15)
                            Spacer()
                        } else {
                            VStack{
                                Text("Total Amount")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .padding(.bottom, 10)
                                    .frame(minWidth: 0, maxWidth: .infinity)

                                Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .foregroundColor(.darkBlueColor)
                            }
                                Spacer()
                        }
                    }
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: iPhoneSE ? 40 : 90)
                    .padding(.bottom, 7)

                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
                            .opacity(colorScheme == .dark ? 1 : 0.5)
                            .cornerRadius(25)
                            .frame(minWidth:0, maxWidth: iPhoneSE ? 210 : 250, minHeight: 100, maxHeight: 120)
                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.8), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

                        VStack {
                            Text("How many persons?")
                                .font(.system(size: iPhoneSE ? 15 : 17, weight: .medium, design: .rounded))
                                .padding(.bottom, 5)
                                .frame(minWidth: 0, maxWidth: .infinity)

                            HStack{
                                Button(action: {
                                    print("minus tapped")
                                    self.tipViewModel.removePerson()
                                }, label: {
                                    LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                        .mask(Image(systemName: "minus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        ).frame(width: iPhoneSE ? 18 : 20, height: iPhoneSE ? 18 : 20, alignment: .center)
                                })
                                .disabled((Int(self.tipViewModel.person) != 1) ? false : true)
                                .opacity((Int(self.tipViewModel.person) != 1) ? 1 : 0.5)
                                .buttonStyle(ButtonStyleModifier(scheme: colorScheme))

                                TextField("1", text: $tipViewModel.person)
                                    .font(.system(size: iPhoneSE ? 16 : 18, weight: .semibold, design: .rounded))
                                    .frame(width: iPhoneSE ? 36 : 50, height: 30, alignment: .center)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                                    .disabled(true)

                                Button(action: {
                                    print("plus tapped")
                                    self.tipViewModel.increasePerson()

                                }, label: {
                                    LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                        .mask(Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    ).frame(width: iPhoneSE ? 18 : 20, height: iPhoneSE ? 18 : 20, alignment: .center)
                                })
                                .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
                            }
                        }
                    }
                    .padding(.bottom, iPhoneSE ? 0 : 7)
                    Spacer()

                    VStack {

                            Text("Per Person")
                                .font(.system(size: iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))
                                .padding(.top, 5)

                            VStack {

                                HStack {
                                    VStack {
                                        Text("Tip")
                                            .font(.system(size: iPhoneSE ? 15 : 18, weight: .semibold, design: .rounded
                                                ))
                                            .padding(.bottom, 10)
                                            .allowsTightening(true)

                                        Text(self.tipViewModel.tipPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.tipPerPerson, specifier: "%.2f")")
                                            .font(.system(size: iPhoneSE ? 18 : 24, weight: .semibold, design: .rounded))
                                            .foregroundColor(.darkBlueColor)
                                            .allowsTightening(true)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)

                                    Rectangle()
                                        .frame(width: 1, height: 60)
                                        .foregroundColor(colorScheme == .dark ? Color.darkEnd.opacity(0.2) : Color.lightGray1)
                                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.2), radius: 1, x: -1, y: -1)
                                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.2), radius: 1, x: 1, y: 1)

                                    VStack {
                                        Text("Total")
                                            .font(.system(size: iPhoneSE ? 15 : 18, weight: .semibold, design: .rounded
                                                ))
                                            .padding(.bottom, 10)
                                            .allowsTightening(true)
                                        Text(self.tipViewModel.totalPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalPerPerson, specifier: "%.2f")")
                                            .font(.system(size: iPhoneSE ? 18    : 24, weight: .semibold, design: .rounded))
                                            .foregroundColor(.darkBlueColor)
                                            .allowsTightening(true)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                }.padding()
                            }
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: iPhoneSE ? 80 : 90, maxHeight: iPhoneSE ? 100 : 110)

                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 2)
                                    .shadow(color: colorScheme == .dark ? Color.darkestGray.opacity(0.5) : Color.white, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? -2 : -1, y: colorScheme == .dark ? -2 : -1)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? 2 : 1, y: colorScheme == .dark ? 2 : 1)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            )
                    }
                    .padding(.bottom, iPhoneSE ? 0 : 7)

                    Spacer()

                    Button(action: clearEverythingTap, label: {
                        Text("Clear Everything")
                            .font(.system(size: iPhoneSE ? 14 : 16, weight: .light, design: .rounded))
                            .foregroundColor(.darkBlueColor)
                    })

//                    HStack {
//                        Button(action: {
//                            self.isSharePresented = true
//
//                        }, label: {
//                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
//                                .mask(Image(systemName: "tray.and.arrow.up.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                            ).frame(width: iPhoneSE ? 26 : 25, height: iPhoneSE ? 26 : 25, alignment: .center)
//                            })
//                            .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
//                        .sheet(isPresented: $isSharePresented, onDismiss: {
//                            print("Dismiss")
//                            self.isSharePresented = false
//                        }, content: {
//                            ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
//                        })
//
//                        Spacer()
//
//                        Button(action: clearEverythingTap, label: {
//                            Text("Clear Everything")
//                                .font(.system(size: iPhoneSE ? 14 : 16, weight: .light, design: .rounded))
//                                .foregroundColor(.darkBlueColor)
//                        })
//                        Spacer()
//
//                        Button(action: {
//                            self.isSettingPresented = true
//                        }, label: {
//                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
//                                .mask(Image("settings")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                            ).frame(width: iPhoneSE ? 26 : 25, height: iPhoneSE ? 26 : 25, alignment: .center)
//                        })
//                            .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
//                            .sheet(isPresented: $isSettingPresented, onDismiss: {
//                                print("Dismiss")
//                                self.isSettingPresented = false
//                            }, content: {
//                                SettingsView()
//                            })
//                    }
                }.padding(.horizontal, 20)
                .padding(.vertical, iPhoneSE ? 20 : hasSafeArea ? 5 : 15)
            }
                .modifier(DismissKeyboardModifier())
//            .frame(alignment: .center)
            .navigationBarTitle(Text("Quick Tip"), displayMode: hasSafeArea ? .large : .inline)
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = self.iPhoneSE ? true : false

                StoreKitHelper.displayStoreKit()
            }
        }
    }
    
    func closeButtonTap() {
        tipViewModel.billAmount = ""
    }

    func clearEverythingTap() {
        tipViewModel.billAmount = ""
        self.refresh.toggle()
        tipViewModel.tipPercentage = 0
        tipViewModel.person = "1"
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        ContentView()
    }
}
#endif

