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

    @State private var value = 0.0
    @State private var refresh = false
    @State private var isShowCloseButton = false
    @State var isNavigationBarHidden: Bool = true
    @State var keyboardHeight: CGFloat = 0
    
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

            ScrollView(self.keyboardHeight == 0 ? .init() : .vertical, showsIndicators: false) {
                
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
                                        
                //                        CurrencyTextField("Enter bill amount", value: self.$value)
                                        TextField("Enter bill amount" + (refresh ? "" : " "), text: $tipViewModel.billAmount, onEditingChanged: { _ in
                                            self.isShowCloseButton.toggle()
                                        })
                                        .padding(20)
                                        .padding(.top, iPhoneSE ? 3 : 3)
                                        .padding(.leading, 26)
                                        .background(colorScheme == .dark ? Color.darkEnd : Color.offWhite)
                                        .frame(height: iPhoneSE ? 56 : hasSafeArea ? 66 : 62)
                                        .font(.system(size: iPhoneSE ? 15 : 18, weight: .medium, design: .rounded))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 6)
                                                .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightGray2, radius: 3, x: 6, y: 6)
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                                .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white, radius: 2, x: -4, y: -4)
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                        )
                                        .cornerRadius(15)
                                        .keyboardType(.decimalPad)

                                        HStack {
                                            LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                                .mask(Text("$").font(.system(size: iPhoneSE ? 22 : 26, weight: .semibold, design: .rounded))
                                            ).frame(width: iPhoneSE ? 26 : 30, height: iPhoneSE ? 26 : 30, alignment: .center)
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
                                                    endPoint: .trailing
                                                ).mask(Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1))
                                                Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1)
                                                    .opacity(0.02)
                                                
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
                                                if colorScheme == .dark {
                                                    
                                                    Button(action: {
                                                        print("minus tapped")
                                                        self.tipViewModel.removePerson()
                                                    }, label: {
                                                        LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                                            .mask(Image(systemName: "minus.circle")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            ).frame(width: iPhoneSE ? 20 : 25, height: iPhoneSE ? 20 : 25, alignment: .center)
                                                    })
                                                    .disabled((Int(self.tipViewModel.person) != 1) ? false : true)
                                                    .opacity((Int(self.tipViewModel.person) != 1) ? 1 : 0.5)
                                                    .buttonStyle(darkButtonStyle())

                                                } else {
                                                    Button(action: {
                                                        print("minus tapped")
                                                        self.tipViewModel.removePerson()
                                                    }, label: {
                                                        LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                                            .mask(Image(systemName: "minus.circle")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                            ).frame(width: iPhoneSE ? 20 : 25, height: iPhoneSE ? 20 : 25, alignment: .center)
                                                    })
                                                    .disabled((Int(self.tipViewModel.person) != 1) ? false : true)
                                                    .opacity((Int(self.tipViewModel.person) != 1) ? 1 : 0.5)
                                                    .buttonStyle(lightButtonStyle())
                                                }

                                                TextField("1", text: $tipViewModel.person)
                                                    .font(.system(size: iPhoneSE ? 16 : 18, weight: .semibold, design: .rounded))
                                                    .frame(width: iPhoneSE ? 36 : 50, height: 30, alignment: .center)
                                                    .multilineTextAlignment(.center)
                                                    .keyboardType(.decimalPad)
                //                                    .disabled(true)
                                                
                                                if colorScheme == .dark {
                                                    
                                                    Button(action: {
                                                        print("plus tapped")
                                                        self.tipViewModel.increasePerson()

                                                    }, label: {
                                                        LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                                            .mask(Image(systemName: "plus.circle")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                        ).frame(width: iPhoneSE ? 20 : 25, height: iPhoneSE ? 20 : 25, alignment: .center)
                                                    })
                                                    .buttonStyle(darkButtonStyle())
                                                    
                                                } else {
                                                    Button(action: {
                                                        print("plus tapped")
                                                        self.tipViewModel.increasePerson()

                                                    }, label: {
                                                        LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)
                                                            .mask(Image(systemName: "plus.circle")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                        ).frame(width: iPhoneSE ? 20 : 25, height: iPhoneSE ? 20 : 25, alignment: .center)
                                                    })
                                                    .buttonStyle(lightButtonStyle())
                                                }
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
                                }.padding(.horizontal, 20)
                                    .padding(.vertical, iPhoneSE ? 20 : hasSafeArea ? 5 : 15)
                            }
                //            .frame(alignment: .center)
                            .navigationBarTitle(Text("Quick Tip"), displayMode: hasSafeArea ? .large : .inline)
                            .navigationBarHidden(self.isNavigationBarHidden)
                            .onAppear {
                                self.isNavigationBarHidden = self.iPhoneSE ? true : false
                            }

            }
            .padding(.bottom, self.keyboardHeight)
            .background(colorScheme == .dark ? Color.darkEnd : Color.offWhite)
            .edgesIgnoringSafeArea(.all)
            .modifier(DismissKeyboard())
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (notification) in
                    
                    let data = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                    
                    let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
                    
                    self.keyboardHeight = height
                    print(height)
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (_) in
                    
                    print("hide keyboard")
                    self.keyboardHeight = 0
                }
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

struct lightButtonStyle: ButtonStyle {
    
    var iPhoneSE : Bool {
        if UIScreen.main.bounds.height <= 568 {
            return true
        } else {
            return false
        }
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding(iPhoneSE ? 7 : 10)
        .background(
            Group {
                if configuration.isPressed {
                    Circle()
                        .fill(Color.offWhite)
                    .overlay(
                        
                        Circle()
                            .stroke(Color.lightGray2, lineWidth: 4)
                            .blur(radius: 1)
                            .offset(x: 2, y: 2)
                            .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .blur(radius: 1)
                            .offset(x: -2, y: -2)
                            .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                    )
                } else {
                    Circle()
                    .fill(Color.offWhite)
                    .shadow(color: Color.white.opacity(0.8), radius: 1, x: -2, y: -2)
                    .shadow(color: Color.lightPurple.opacity(0.6), radius: 1, x: 2, y: 2)
                }
            }
        )
    }
}

struct darkButtonStyle: ButtonStyle {

    var iPhoneSE : Bool {
        if UIScreen.main.bounds.height <= 568 {
            return true
        } else {
            return false
        }
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding(iPhoneSE ? 7 : 10)
        .background(
            Group {
                if configuration.isPressed {
                    Circle()
                    .fill(Color.darkEnd)
                    .overlay(
                        
                        Circle()
                            .stroke(Color.darkestGray, lineWidth: 4)
                            .blur(radius: 1)
                            .offset(x: 2, y: 2)
                            .mask(Circle().fill(LinearGradient(Color.darkestGray, Color.clear)))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.darkStart, lineWidth: 4)
                            .blur(radius: 1)
                            .offset(x: -2, y: -2)
                            .mask(Circle().fill(LinearGradient(Color.clear, Color.darkestGray)))
                    )
                } else {
                    Circle()
                        .fill(Color.darkEnd)
                        .shadow(color: Color.darkStart, radius: 1, x: -1, y: -1)
                        .shadow(color: Color.darkestGray, radius: 1, x: 1, y: 1)
                }
            }
        )
    }
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Color {
    static let offWhite = Color(red: 240 / 255, green: 240 / 255, blue: 243 / 255)
    static let lightGray1 = Color(red: 236/255, green: 234/255, blue: 235/255)
    static let lightGray2 = Color(red: 192/255, green: 189/255, blue: 191/255)
    static let lightPurple = Color(red: 174 / 255, green: 174 / 255, blue: 192 / 255)

    static let darkBlueColor = Color(red: 88 / 255, green: 186 / 255, blue: 186 / 255)
    static let lightBlueColor = Color(red: 145 / 255, green: 236 / 255, blue: 207 / 255)
    static let blueGradient = LinearGradient(gradient: Gradient(colors: [.darkBlueColor, .lightBlueColor]), startPoint: .top, endPoint: .bottom)

    static let darkStart = Color(red: 61 / 255, green: 62 / 255, blue: 68 / 255)
    static let darkEnd = Color(red: 48 / 255, green: 49 / 255, blue: 53 / 255)
    static let darkestGray = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
}

//struct TextFieldView: UIViewRepresentable {
//    @Binding var text: String
//    
//    public func makeCoordinator() -> CurrencyTextField.Coordinator {
//        Coordinator(value: $value)
//    }
//
//    func makeUIView(context: Context) -> UITextField {
//        return UITextField()
//    }
//
//    func updateUIView(_ uiView: UITextField, context: Context) {
//        if let amountString = uiView.text?.currencyInputFormatting() {
//            text = amountString
//        }
////        uiView.text = text
//    }
//    
//    public class Coordinator: NSObject, UITextFieldDelegate {
//        var value: Binding<Double>
//        
//        init(value: Binding<Double>) {
//            self.value = value
//        }
//        
//    }
//}
//
//extension String {
//
//    // formatting text for currency textField
//    func currencyInputFormatting() -> String {
//
//        var number: NSNumber!
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = "$"
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
//
//        var amountWithPrefix = self
//
//        // remove from String: "$", ".", ","
//        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
//        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
//
//        let double = (amountWithPrefix as NSString).doubleValue
//        number = NSNumber(value: (double / 100))
//
//        // if first number is 0 or all numbers were deleted
//        guard number != 0 as NSNumber else {
//            return ""
//        }
//
//        return formatter.string(from: number)!
//    }
//}
