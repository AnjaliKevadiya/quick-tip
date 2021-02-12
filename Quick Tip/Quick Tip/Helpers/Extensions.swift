//
//  Extensions.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/21/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import SwiftUI
import Combine

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
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

extension UserDefaults {

    struct Keys {
        static let isRoundResultsUp = "isRoundResultsUp"
        static let isRememberLastTip = "isRememberLastTip"
        static let lastTip = "lastTip"
    }
    
    static var isRoundResultsUp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isRoundResultsUp) 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isRoundResultsUp)
        }
    }
    
    static var isRememberLastTip: Bool {
        get{
            return UserDefaults.standard.bool(forKey: Keys.isRememberLastTip) 
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Keys.isRememberLastTip)
        }
    }
    
    static var lastTip: Double {
        get{
            return UserDefaults.standard.double(forKey: Keys.lastTip)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Keys.lastTip)
        }
    }
}


extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
}

//extension UIView {
//    func getImage(rect: CGRect) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: rect)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
//}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
