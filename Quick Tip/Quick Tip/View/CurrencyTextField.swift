//
//  CurrencyTextField.swift
//  Quick Tip
//
//  Created by Anjali Kevadiya on 5/5/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

public struct CurrencyTextField: UIViewRepresentable {
    
    @Binding var value: Double
    
    public typealias UIViewType = UITextField
    
    private var placeholder: String
    
    private var font: UIFont?
    private var foregroundColor: UIColor?
    private var accentColor: UIColor?
    private var textAlignment: NSTextAlignment?
    private var contentType: UITextContentType?
    
    private var autocorrection: UITextAutocorrectionType
    private var autocapitalization: UITextAutocapitalizationType
    private var keyboardType: UIKeyboardType
    private var returnKeyType: UIReturnKeyType
    
    private var isSecure: Bool
    private var isUserInteractionEnabled: Bool
    private var clearsOnBeginEditing: Bool
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    @Environment(\.font) private var swiftUIfont: Font?
    
    public init(
        _ placeholder: String = "",
        value: Binding<Double>,
        font: UIFont? = nil,
        foregroundColor: UIColor? = nil,
        accentColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil,
        contentType: UITextContentType? = nil,
        autocorrection: UITextAutocorrectionType = .default,
        autocapitalization: UITextAutocapitalizationType = .sentences,
        keyboardType: UIKeyboardType = .decimalPad,
        returnKeyType: UIReturnKeyType = .default,
        isSecure: Bool = false,
        isUserInteractionEnabled: Bool = true,
        clearsOnBeginEditing: Bool = false
    ) {
        self._value = value
        self.placeholder = placeholder
        self.font = font
        self.foregroundColor = foregroundColor
        self.accentColor = accentColor
        self.textAlignment = textAlignment
        self.contentType = contentType
        self.autocorrection = autocorrection
        self.autocapitalization = autocapitalization
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.isSecure = isSecure
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.clearsOnBeginEditing = clearsOnBeginEditing
    }
    
    public func makeCoordinator() -> CurrencyTextField.Coordinator {
        Coordinator(value: $value)
    }
      
    public func makeUIView(context: UIViewRepresentableContext<CurrencyTextField>) -> UITextField {
        
        let textField = UITextField()
        textField.delegate = context.coordinator
        
        // font
        if let f = context.environment.font {
            switch f {
            case .largeTitle:
                textField.font = UIFont.preferredFont(forTextStyle: .largeTitle)
            case .title:
                textField.font = UIFont.preferredFont(forTextStyle: .title1)
            case .body:
                textField.font = UIFont.preferredFont(forTextStyle: .body)
            case .headline:
                textField.font = UIFont.preferredFont(forTextStyle: .headline)
            case .subheadline:
                textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
            case .callout:
                textField.font = UIFont.preferredFont(forTextStyle: .callout)
            case .footnote:
                textField.font = UIFont.preferredFont(forTextStyle: .footnote)
            case .caption:
                textField.font = UIFont.preferredFont(forTextStyle: .caption1)
            default:
                textField.font = font
            }
        }
        
        // alignment
        var ltr = true
        if context.environment.layoutDirection == .rightToLeft{
            ltr = false
        }
        switch context.environment.multilineTextAlignment {
        case .center :
            textField.textAlignment = .center
        case .leading:
            textField.textAlignment = ltr ? .left : .right
        case .trailing:
            textField.textAlignment = ltr ? .right : .left
        }
        
        // color
        switch context.environment.colorScheme {
        case .dark:
            textField.textColor = .white
        case .light:
            textField.textColor = .black
        @unknown default:
            break
        }
        if let fgc = self.foregroundColor {
            textField.textColor = fgc
        }
        
        // other
        textField.placeholder = placeholder
        textField.textContentType = contentType
        textField.tintColor = accentColor
        
        textField.autocorrectionType = autocorrection
        textField.autocapitalizationType = autocapitalization
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        
        textField.clearsOnBeginEditing = clearsOnBeginEditing
        textField.isSecureTextEntry = isSecure
        textField.isUserInteractionEnabled = isUserInteractionEnabled
        
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CurrencyTextField>) {
        // do nothing, only allow one way
    }
    
    public static func dismantleUIView(_ uiView: UITextField, coordinator: CurrencyTextField.Coordinator) {
        // nothing to cleanup
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var value: Binding<Double>
        
        init(value: Binding<Double>) {
            self.value = value
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // get new value
            let originalText = textField.text
            let text = textField.text as NSString?
            let newValue = text?.replacingCharacters(in: range, with: string)
            let display = newValue?.currencyFormat
            
            // validate change
            if !shouldAllowChange(oldValue: textField.text ?? "", newValue: newValue ?? "") {
                return false
            }
            
            // update binding variable
            self.value.wrappedValue = newValue?.double ?? 0
            
            // don't move cursor if nothing changed (i.e. entered invalid values)
            if textField.text == display && string.count > 0 {
                return false
            }
            
            // update textfield display
            textField.text = display
            
            // calculate and update cursor position
            // update cursor position
            let beginningPosition = textField.beginningOfDocument
            
            var numberOfCharactersAfterCursor: Int
            if string.count == 0 && originalText == display {
                // if deleting and nothing changed, use lower bound of range
                // to allow cursor to move backwards
                numberOfCharactersAfterCursor = (originalText?.count ?? 0) - range.lowerBound
            } else {
                numberOfCharactersAfterCursor = (originalText?.count ?? 0) - range.upperBound
            }
            
            let offset = (display?.count ?? 0) - numberOfCharactersAfterCursor
            
            let cursorLocation = textField.position(from: beginningPosition, offset: offset)
            
            if let cursorLoc = cursorLocation {
                textField.selectedTextRange = textField.textRange(from: cursorLoc, to: cursorLoc)
            }
            
            // prevent from going to didChange
            // all changes to textfield already made
            return false
        }
        
        func shouldAllowChange(oldValue: String, newValue: String) -> Bool {
            // return if already has decimal
            if newValue.numberOfDecimalPoints > 1 {
                return false
            }
            
            // limits integers length
            if newValue.integers.count > 9 {
                return false
            }
            
            // limits fractions length
            if newValue.fractions?.count ?? 0 > 2 {
                return false
            }
            
            return true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            if reason == .committed {
                textField.resignFirstResponder()
            }
        }
    }
}

fileprivate extension String {
    
    var numberOfDecimalPoints: Int {
        let tok = components(separatedBy:".")
        return tok.count - 1
    }
    
    // all numbers including fractions
    var decimals: String {
        return components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()
    }
    
    // just numbers
    var numbers: String {
        return components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined()
    }
    
    var integers: String {
        return decimals.components(separatedBy: ".")[0]
    }
    
    var fractions: String? {
        let split = decimals.components(separatedBy: ".")
        if split.count == 2 {
            return split[1]
        }
        return nil
    }
    
    var double: Double? {
        // uses decimals to get all numerical characters
        // then calls Double on the string
        if decimals.count == 0 {
            return nil
        }
        return Double(decimals) ?? 0
    }
    
    var currencyFormat: String? {
        // uses self.double
        // logic for varying the number of fraction digits
        
        guard let double = double else {
            return nil
        }
        
        let formatter = Formatter.currency
        let fractionDigits = fractions?.count ?? 0
        // if has fractions, show fractions
        if fractions != nil {
            if fractionDigits == 0 {
                formatter.maximumFractionDigits = 0
            } else if fractionDigits == 1 {
                formatter.maximumFractionDigits = 1
            } else {
                formatter.maximumFractionDigits = 2
            }
            
            let formatted = formatter.string(from: NSNumber(value: double))
            
            // show dot if exists
            if let formatted = formatted, fractionDigits == 0 {
                return "\(formatted)."
            }
            
            return formatted
        } else {
            formatter.maximumFractionDigits = 0
            let formatted = formatter.string(from: NSNumber(value: double))
            return formatted
        }
    }
}

fileprivate struct Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}

fileprivate extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}


//@State private var value = 0.0

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
