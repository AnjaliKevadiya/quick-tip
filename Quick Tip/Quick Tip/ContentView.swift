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
    
    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }

    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()

    @State private var isShowCloseButton = false
    @ObservedObject var tipViewModel = TipViewModel()
    @Environment(\.colorScheme) var colorScheme
    //Use of ObservedObject which means any time TipViewModel will update it will render the body again
    
    init() {
        if colorScheme == .dark {
            UITextField.appearance().tintColor = .gray
        } else {
            UITextField.appearance().tintColor = .black
        }
        
//        let design = UIFontDescriptor.SystemDesign.rounded
//        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
//                                         .withDesign(design)!
//        let font = UIFont.init(descriptor: descriptor, size: 40)
//        UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]m
    }
    
    var body: some View {
        
        NavigationView {

            ZStack{
                if colorScheme == .dark {
                    Color.darkEnd
                        .edgesIgnoringSafeArea(.all)
                        .modifier(DismissKeyboard())

                } else {
                    Color.offWhite
                        .edgesIgnoringSafeArea(.all)
                        .modifier(DismissKeyboard())
                }
//                .gesture(DragGesture().onChanged{_ in
//                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                })

                VStack {
                    ZStack{
                        TextField("Enter bill amount", text: $tipViewModel.billAmount, onEditingChanged: { _ in
                            self.isShowCloseButton.toggle()
                        })
                        .padding(20)
                        .padding(.top, 3)
                        .padding(.leading, 26)
                        .background(colorScheme == .dark ? Color.darkEnd : Color.offWhite)
                        .frame(height: hasSafeArea ? 68 : 56)
                        .font(.system(size: hasSafeArea ? 18 : 16, weight: .medium, design: .rounded))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 6)
                                .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightGray2, radius: 3, x: 6, y: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white, radius: 2, x: -4, y: -4)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        )
                        .modifier(TextFieldModifier())
                        
                        HStack {
                            LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                .mask(Text("$").font(.system(size: 26, weight: .semibold, design: .rounded))
                            ).frame(width: 30, height: 30, alignment: .center)
                                .padding(.leading, 20)
                            Spacer()
                        }

                        if isShowCloseButton {
                            HStack {
                                Spacer()
                                Button(action: closeButtonTap) {

                                    LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    ).frame(width: 15, height: 15)
                                }
                            }.padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, hasSafeArea ? 15 : 5)

                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
                            .opacity(colorScheme == .dark ? 1 : 0.5)
                            .cornerRadius(25)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: hasSafeArea ? 100 : 80, maxHeight: hasSafeArea ? 120 : 90)
//                        .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
//                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: colorScheme == .dark ? 5 : 5, x: 5, y: 5)

                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: 5, y: 5)
                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: -5, y: -5)

                        VStack {
                            HStack {
                                Text("Tip")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                
                                Text(" - ")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))

                                Text("\(tipViewModel.tipPercentage, specifier: "%.0f") %")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))

                                Spacer()

                                Text("$ \(tipViewModel.tipAmount, specifier: "%.2f")")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.darkBlueColor)
                            }
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).mask(Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1))
                                Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1)
                                    .opacity(0.02)
                                
                            }.frame(height: 30, alignment: .bottom)
                            .padding(.top, hasSafeArea ? 15 : 0)

                        }.padding(.horizontal, 15)
                    }
                    .padding(.bottom, hasSafeArea ? -6 : 5)
                    Spacer()

                    if hasSafeArea{
                        VStack{
                                    Text("Total Amount")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .padding(.bottom, 10)

                                    Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                                        .foregroundColor(.darkBlueColor)
                        }
                    .padding(.bottom, 6)
                    } else {
                        HStack{

                                Text("Total Amount")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))

                                Spacer()
                                Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .foregroundColor(.darkBlueColor)
                                    .lineLimit(1)
                        }.padding(.horizontal, 15)
                        .padding(.bottom, 6)
                    }

                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
                            .opacity(colorScheme == .dark ? 1 : 0.5)
                            .cornerRadius(25)
                            .frame(minWidth:0, maxWidth: 250, minHeight: hasSafeArea ? 100 : 80, maxHeight: hasSafeArea ? 120 : 90)
//                        .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
//                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: colorScheme == .dark ? 5 : 5, x: 5, y: 5)

                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: 5, y: 5)
                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: -5, y: -5)

                        VStack {
                            Text("How many persons?")
                                .font(.system(size: hasSafeArea ? 17 : 16, weight: .medium, design: .rounded))
                                .padding(.bottom, 5)

                            HStack{
                                Button(action: {
                                    print("minus tapped")
                                    self.tipViewModel.removePerson()
                                }, label: {
                                    LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "minus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        ).frame(width: 30, height: 30, alignment: .center)
                                })
                                .disabled((Int(self.tipViewModel.person) != 1) ? false : true)
                                .opacity((Int(self.tipViewModel.person) != 1) ? 1 : 0.5)

                                TextField("1", text: $tipViewModel.person)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))

                                    .frame(width: 50, height: 30, alignment: .center)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                                
                                Button(action: {
                                    print("plus tapped")
                                    self.tipViewModel.increasePerson()

                                }, label: {
                                    LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "plus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    ).frame(width: 30, height: 30, alignment: .center)
                                })
                            }
                        }
                    }
                    Spacer()

                    VStack {
                        
                            Text("Per Person")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(.top, 5)

                            VStack {

                                HStack {
                                    VStack {
                                        Text("Tip")
                                            .font(.system(size: hasSafeArea ? 18 : 16, weight: .semibold, design: .rounded
                                                ))
                                            .padding(.bottom, 10)
                                            .allowsTightening(true)

                                        Text(self.tipViewModel.tipPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.tipPerPerson, specifier: "%.2f")")
                                            .font(.system(size: hasSafeArea ? 22 : 20, weight: .semibold, design: .rounded))
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
                                            .font(.system(size: hasSafeArea ? 18 : 16, weight: .semibold, design: .rounded
                                                ))
                                            .padding(.bottom, 10)
                                            .allowsTightening(true)
                                        Text(self.tipViewModel.totalPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalPerPerson, specifier: "%.2f")")
                                            .font(.system(size: hasSafeArea ? 22 : 20, weight: .semibold, design: .rounded))
                                            .foregroundColor(.darkBlueColor)
                                            .allowsTightening(true)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                }.padding()
                            }
                           .frame(minWidth:0, maxWidth: .infinity, minHeight: 80, maxHeight: hasSafeArea ? 100 : 80)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 2)
                                    .shadow(color: colorScheme == .dark ? Color.darkestGray.opacity(0.5) : Color.white, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? -2 : -1, y: colorScheme == .dark ? -2 : -1)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? 2 : 1, y: colorScheme == .dark ? 2 : 1)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            )
                    }

                    Spacer()
                    if !hasSafeArea { Spacer() }

                    Button(action: clearEverythingTap, label: {
                        Text("Clear Everything")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(.darkBlueColor)
                    })
                }.padding()
            }
            .frame(alignment: .center)
            .navigationBarTitle(Text("Quick Tip"))
        }
    }
    
    func closeButtonTap() {
        tipViewModel.billAmount = ""
    }

    func clearEverythingTap() {
        tipViewModel.billAmount = ""
        tipViewModel.tipPercentage = 0
        tipViewModel.person = "1"
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        ContentView()
//            .environment(\.colorScheme, .dark)
    }
}
#endif

extension Color {
    static let offWhite = Color(red: 240 / 255, green: 240 / 255, blue: 243 / 255)
    static let lightGray1 = Color(red: 236/255, green: 234/255, blue: 235/255)
    static let lightGray2 = Color(red: 192/255, green: 189/255, blue: 191/255)
    static let lightPurple = Color(red: 174 / 255, green: 174 / 255, blue: 192 / 255)
    static let peachColor = Color(red: 222 / 255, green: 136 / 255, blue: 149 / 255)
    static let darkPeachColor = Color(red: 188 / 255, green: 94 / 255, blue: 125 / 255)
    static let peachGradient = LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
    
    static let darkBlueColor = Color(red: 88 / 255, green: 186 / 255, blue: 186 / 255)
    static let lightBlueColor = Color(red: 145 / 255, green: 236 / 255, blue: 207 / 255)
    static let blueGradient = LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)

//    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkStart = Color(red: 61 / 255, green: 62 / 255, blue: 68 / 255)
    static let darkEnd = Color(red: 48 / 255, green: 49 / 255, blue: 53 / 255)
    static let darkestGray = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)

}

