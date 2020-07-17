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
    
    @ObservedObject var tipViewModel = TipViewModel()
    @Environment(\.colorScheme) var colorScheme

    @State private var refreshTextField = false
    @State private var isShowCloseButton = false
    @State var isNavigationBarHidden: Bool = true
    @State private var isSharePresented: Bool = false
    @State private var textToShare: String!
    @State private var isSettingPresented: Bool = false

    init() {
            
        let fontSize: CGFloat = 34
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let font: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
        UITextField.appearance().tintColor = .gray
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

                        TextField("Enter bill amount" + (refreshTextField ? "" : " "), text: $tipViewModel.billAmount, onEditingChanged: { _ in
                            self.isShowCloseButton.toggle()
                        })
                        .padding(20)
                        .padding(.top, Variable.iPhoneSE ? 3 : 3)
                        .padding(.leading, 26)
                        .frame(height: Variable.iPhoneSE ? 54 : Variable.hasSafeArea ? 62 : 60)
                        .modifier(TextFieldModifer(scheme: colorScheme))

                        HStack {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(Text("$").font(.system(size: Variable.iPhoneSE ? 22 : 26, weight: .semibold, design: .rounded))
                            ).frame(width: Variable.iPhoneSE ? 26 : 30, height: Variable.iPhoneSE ? 26 : 30, alignment: .center)
                                .padding(.leading, 20)
                            Spacer()
                        }

                        if tipViewModel.billAmount.count > 0 {
                            if isShowCloseButton {
                                HStack {
                                    Spacer()
                                    Button(action: closeButtonTap) {
                                        LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                            .mask(Image(systemName: "xmark")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        ).frame(width: Variable.iPhoneSE ? 13 : 15, height: Variable.iPhoneSE ? 13 : 15)
                                    }
                                }.padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, Variable.iPhoneSE ? 5 : Variable.hasSafeArea ? 15 : 10)

                    ZStack{
                        RoundedRectangleView(cornerRadius: 25)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: Variable.iPhoneSE ? 100 : 106, maxHeight: 126)

                        VStack {
                            HStack {
                                Text("Tip")
                                    .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))

                                Text(" - ")
                                    .font(.system(size: Variable.iPhoneSE ? 15 : 17, weight: .medium, design: .rounded))

                                Text("\(tipViewModel.tipPercentage, specifier: "%.0f") %")
                                    .font(.system(size: Variable.iPhoneSE ? 15 : 17, weight: .medium, design: .rounded))

                                Spacer()

//                                if tipViewModel.isRoundResultsUp {
//                                    Text("$ \(round(tipViewModel.tipAmount), specifier: "%.2f")")
//                                        .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))
//                                        .foregroundColor(.darkBlueColor)
//                                } else {
                                    Text("$ \(tipViewModel.tipAmount, specifier: "%.2f")")
                                        .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.darkBlueColor)
//                                }
                            }
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                    .mask(Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1))
                                Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1)
                                    .opacity(0.02)

                            }.frame(height: 30, alignment: .bottom)
                            .padding(.top, Variable.iPhoneSE ? 10 : 15)

                        }.padding(.horizontal, 15)
                    }
                    .padding(.bottom, Variable.iPhoneSE ? 5 : 7)
                    Spacer()

                    ZStack {
                        if Variable.iPhone8PlusOrLater {
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
                        } else {
                            HStack{

                                Text("Total Amount")
                                    .font(.system(size: Variable.iPhoneSE ? 17 : 19, weight: .bold, design: .rounded))
                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2)
                                    .multilineTextAlignment(.leading)

                                Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                    .font(.system(size: Variable.iPhoneSE ? 20 : 24, weight: .semibold, design: .rounded))
                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.darkBlueColor)
                                    .lineLimit(1)
                            }.padding(.horizontal, 15)
                            Spacer()
                        }
                    }
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: Variable.iPhoneSE ? 40 : 90)
                    .padding(.bottom, Variable.hasSafeArea ? 10 : 7)

                    ZStack{
                        RoundedRectangleView(cornerRadius: 25)
                        .frame(minWidth:0, maxWidth: Variable.iPhoneSE ? 210 : 250, minHeight: Variable.iPhoneSE ? 100 : 106, maxHeight: 126)

                        VStack {
                            Text("How many persons?")
                                .font(.system(size: Variable.iPhoneSE ? 15 : 17, weight: .medium, design: .rounded))
                                .padding(.bottom, 5)
                                .frame(minWidth: 0, maxWidth: .infinity)

                            ZStack {
                                NumberOfPersonsView(value: $tipViewModel.person)
                                
                                HStack {
                                        
                                        Button(action: {
                                            self.tipViewModel.removePerson()
                                        }, label: {
                                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                                .mask(Image(systemName: "minus")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                                        })
                                        .disabled((Int(self.tipViewModel.person) != 1) ? false : true)
                                        .opacity((Int(self.tipViewModel.person) != 1) ? 1 : 0.5)
                                        .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
                                        .padding(.trailing, Variable.iPhoneSE ? 24 : 35)
                                    
                                        Button(action: {
                                            self.tipViewModel.increasePerson()

                                        }, label: {
                                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                                .mask(Image(systemName: "plus")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            ).frame(width: Variable.iPhoneSE ? 18 : 20, height: Variable.iPhoneSE ? 18 : 20, alignment: .center)
                                        })
                                        .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
                                        .disabled((Int(self.tipViewModel.person) != 99) ? false : true)
                                        .opacity((Int(self.tipViewModel.person) != 99) ? 1 : 0.5)
                                        .padding(.leading, Variable.iPhoneSE ? 24 : 35)
                                    }
                            }
                        }
                    }
                    .padding(.bottom, Variable.iPhoneSE ? 0 : 7)
                    Spacer()

                    VStack {
                        Text("Per Person")
                            .font(.system(size: Variable.iPhoneSE ? 16 : 18, weight: .bold, design: .rounded))
                            .padding(.top, 5)

                        VStack {

                            HStack {
                                VStack {
                                    Text("Tip")
                                        .font(.system(size: Variable.iPhoneSE ? 15 : 18, weight: .semibold, design: .rounded
                                            ))
                                        .padding(.bottom, 10)
                                        .allowsTightening(true)

                                    Text(self.tipViewModel.tipPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.tipPerPerson, specifier: "%.2f")")
                                        .font(.system(size: Variable.iPhone8PlusOrLater ? 24 : Variable.iPhoneSE ? 18 : 22, weight: .semibold, design: .rounded))
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
                                        .font(.system(size: Variable.iPhoneSE ? 15 : 18, weight: .semibold, design: .rounded
                                            ))
                                        .padding(.bottom, 10)
                                        .allowsTightening(true)
                                    Text(self.tipViewModel.totalPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalPerPerson, specifier: "%.2f")")
                                        .font(.system(size: Variable.iPhone8PlusOrLater ? 24 : Variable.iPhoneSE ? 18 : 22, weight: .semibold, design: .rounded))
                                        .foregroundColor(.darkBlueColor)
                                        .allowsTightening(true)
                                }
                                .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                            }.padding()
                        }
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: Variable.iPhoneSE ? 80 : 90, maxHeight: Variable.iPhoneSE ? 100 : 120)

                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 2)
                                .shadow(color: colorScheme == .dark ? Color.darkestGray.opacity(0.5) : Color.white, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? -2 : -1, y: colorScheme == .dark ? -2 : -1)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? 2 : 1, y: colorScheme == .dark ? 2 : 1)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                    }
                    .padding(.bottom, Variable.iPhoneSE ? 0 : 7)

                    Spacer()

                    HStack {
                        Button(action: shareBill, label: {
                            LinearGradient(Color.darkBlueColor, Color.lightBlueColor)
                                .mask(Image(systemName: "tray.and.arrow.up.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: Variable.iPhone8PlusOrLater ? 25 : Variable.iPhoneSE ? 20 : 22, height: Variable.iPhone8PlusOrLater ? 25 : Variable.iPhoneSE ? 20 : 22, alignment: .center)
                            })
                            .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
                        .sheet(isPresented: $isSharePresented, onDismiss: {
                            print("Dismiss")
                            self.isSharePresented = false
                        }, content: {
                            ActivityViewController(textToShare: self.textToShare)
                        })
                        Spacer()

                        Button(action: clearEverythingTap, label: {
                            Text("Clear Everything")
                                .font(.system(size: Variable.iPhoneSE ? 14 : 16, weight: .light, design: .rounded))
                                .foregroundColor(.darkBlueColor)
                        })

                        Spacer()

                        Button(action: {
                            self.isSettingPresented = true
                        }, label: {
                            Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Variable.iPhone8PlusOrLater ? 25 : Variable.iPhoneSE ? 20 : 22, height: Variable.iPhone8PlusOrLater ? 25 : Variable.iPhoneSE ? 20 : 22, alignment: .center)
                        })
                        .buttonStyle(ButtonStyleModifier(scheme: colorScheme))
                        .sheet(isPresented: $isSettingPresented, onDismiss: {
                            print("Dismiss")
                            self.isSettingPresented = false
                        }, content: {
                            SettingsView()
                        })
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, Variable.iPhoneSE ? 20 : Variable.hasSafeArea ? 0 : 15)//5
            }
            .navigationBarTitle(Text("Quick Tip"), displayMode: Variable.hasSafeArea ? .large : .inline)
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = Variable.iPhoneSE ? true : false

                StoreKitHelper.displayStoreKit()
            }
            .modifier(DismissKeyboardModifier())
        }
        .onReceive([self.$tipViewModel.isRememberLastTip].publisher.first()) { (value) in
            print("content receiver tip \(value)")
        }
    }
    
    func closeButtonTap() {
        tipViewModel.billAmount = ""
    }

    func clearEverythingTap() {
        tipViewModel.billAmount = ""
        self.refreshTextField.toggle()
        tipViewModel.person = 1//"1"
//        if tipViewModel.isRememberLastTip {
//            tipViewModel.tipPercentage = UserDefaults.standard.double(forKey: UserDefaults.Keys.lastTip)
//        } else {
            tipViewModel.tipPercentage = 0
//        }
    }
    
    func shareBill() {
        
        self.isSharePresented = true
        
        let billAmount = String(format: "%.2f", Double(self.tipViewModel.billAmount) ?? 0.00)
        let tipAmount = String(format: "%.2f", self.tipViewModel.tipAmount)
        let totalPerPerson = String(format: "%.2f", self.tipViewModel.totalPerPerson)
        let totalAmount = String(format: "%.2f", self.tipViewModel.totalAmount)

        self.textToShare = """
        Quick Tip - Calculator
        \(todayDate())
        
        Bill Amount - $ \(billAmount)
        Tip (\(self.tipViewModel.tipPercentage) %) - $ \(tipAmount)
        Split for \(self.tipViewModel.person) - $ \(totalPerPerson)
        
        TOTAL TO PAY - $ \(totalAmount)
        """
    }
    
    func todayDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date())
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        ContentView()
    }
}
#endif
