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
    
    let deviceHeight: CGFloat = UIScreen.main.bounds.height

    var deviceXOrLater : Bool {
        if deviceHeight >= 736 {
            return true
        } else {
            return false
        }
    }
    var deviceSE : Bool {
        if deviceHeight <= 568 {
            return true
        } else {
            return false
        }
    }

    var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }


//    @State private var value = 0.0
    @State private var refresh = false
    @State private var isShowCloseButton = false
    @ObservedObject var tipViewModel = TipViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State var isNavigationBarHidden: Bool = true

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
                        .padding(.top, 3)
                        .padding(.leading, 26)
                        .background(colorScheme == .dark ? Color.darkEnd : Color.offWhite)
                            .frame(height: hasSafeArea ? 68 : 60)
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
//                        Spacer()
                    }
                    .padding(.bottom, hasSafeArea ? 15 : deviceSE ? 5 : 10)

                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
                            .opacity(colorScheme == .dark ? 1 : 0.5)
                            .cornerRadius(25)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: hasSafeArea ? 100 : 90, maxHeight: hasSafeArea ? 120 : 110)
                        .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
                        .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

//                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: 5, y: 5)
//                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: -5, y: -5)

                        VStack {
                            HStack {
                                Text("Tip")
                                    .font(.system(size: hasSafeArea ? 18 : 17, weight: .bold, design: .rounded))
                                
                                Text(" - ")
                                    .font(.system(size: hasSafeArea ? 17 : 16, weight: .medium, design: .rounded))

                                Text("\(tipViewModel.tipPercentage, specifier: "%.0f") %")
                                    .font(.system(size: hasSafeArea ? 17 : 16, weight: .medium, design: .rounded))

                                Spacer()

                                Text("$ \(tipViewModel.tipAmount, specifier: "%.2f")")
                                    .font(.system(size: hasSafeArea ? 18 : 17, weight: .bold, design: .rounded))
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
                            .padding(.top, hasSafeArea ? 15 : 10)

                        }.padding(.horizontal, 15)
                    }
                    .padding(.bottom, hasSafeArea ? 7 : 5)
                    Spacer()

                    ZStack {
                        if deviceXOrLater{
                            VStack{
                                        Text("Total Amount")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .padding(.bottom, 10)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                
                                        Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                                            .foregroundColor(.darkBlueColor)
                            }
//                            .padding(.bottom, 6)
                                Spacer()
                        } else {
                            HStack{

                                    Text("Total Amount")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                                        .multilineTextAlignment(.leading)
    //                                Spacer()

                                    Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                                        .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.darkBlueColor)
                                        .lineLimit(1)
                            }.padding(.horizontal, 15)
//                            .padding(.bottom, 8)
                            Spacer()
                        }
                    }
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 90)
                    .padding(.bottom, hasSafeArea ? 7 : 0) //x mate j work kare che

                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.darkEnd : Color.white)
                            .opacity(colorScheme == .dark ? 1 : 0.5)
                            .cornerRadius(25)
                            .frame(minWidth:0, maxWidth: 250, minHeight: hasSafeArea ? 100 : 90, maxHeight: hasSafeArea ? 120 : 110)
                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: -5, y: -5)
                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

//                            .shadow(color: colorScheme == .dark ? Color.darkStart : Color.white.opacity(0.5), radius: colorScheme == .dark ? 10 : 5, x: 5, y: 5)
//                            .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple.opacity(0.6), radius: 5, x: -5, y: -5)

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
                    .padding(.bottom, hasSafeArea ? 7 : 0)
                    Spacer()

                    VStack {
                        
                            Text("Per Person")
                                .font(.system(size: hasSafeArea ? 18 : 17, weight: .bold, design: .rounded))
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
                                            .font(.system(size: hasSafeArea ? 24 : 20, weight: .semibold, design: .rounded))
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
                                            .font(.system(size: hasSafeArea ? 24 : 20, weight: .semibold, design: .rounded))
                                            .foregroundColor(.darkBlueColor)
                                            .allowsTightening(true)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                }.padding()
                            }
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: hasSafeArea ? 90 : 80, maxHeight: hasSafeArea ? 110 : 100)

//                           .frame(minWidth:0, maxWidth: .infinity, minHeight: 80, maxHeight: hasSafeArea ? 100 : 80)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(colorScheme == .dark ? Color.darkEnd : Color.offWhite, lineWidth: 2)
                                    .shadow(color: colorScheme == .dark ? Color.darkestGray.opacity(0.5) : Color.white, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? -2 : -1, y: colorScheme == .dark ? -2 : -1)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: colorScheme == .dark ? Color.darkestGray : Color.lightPurple, radius: colorScheme == .dark ? 3 : 2, x: colorScheme == .dark ? 2 : 1, y: colorScheme == .dark ? 2 : 1)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            )
                    }
                    .padding(.bottom, hasSafeArea ? 7 : 0) //x mate j work kare che

                    Spacer()

                    Button(action: clearEverythingTap, label: {
                        Text("Clear Everything")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(.darkBlueColor)
                    })
                }.padding(.horizontal, 20)
                .padding(.top, 5)
            }
//            .frame(alignment: .center)
            .navigationBarTitle(Text("Quick Tip"), displayMode: hasSafeArea ? .large : .inline)
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear {
                self.isNavigationBarHidden = self.deviceSE ? true : false
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

public extension UIDevice {

    /// pares the deveice name as the standard name
    var modelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 , value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }

}
