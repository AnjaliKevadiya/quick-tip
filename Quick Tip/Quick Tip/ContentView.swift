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
    
    @State private var isShowCloseButton = false
    @State private var isOpenSplitView = false
    @ObservedObject var tipViewModel = TipViewModel()
    //Use of ObservedObject which means any time TipViewModel will update it will render the body again
    
    init() {
        UITextField.appearance().tintColor = .black
    }
    
    var body: some View {
        
        NavigationView {

            ZStack{
                Color.offWhite
                .edgesIgnoringSafeArea(.all)
                .modifier(DismissingKeyboard())
                .gesture(DragGesture().onChanged{_ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })


                VStack {
                    ZStack{
                        TextField("Enter bill amount", text: $tipViewModel.billAmount, onEditingChanged: { _ in
                            self.isShowCloseButton.toggle()
                        })
                        .modifier(TextFieldModifier())

                        HStack {
                            LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
                                .mask(Image(systemName: "dollarsign.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            ).frame(width: 30, height: 30, alignment: .center)
                                .padding(.leading, 20)

                            Spacer()
                        }
                        
                        if isShowCloseButton {
                            HStack {
                                Spacer()
                                Button(action: closeButtonTap) {
                                    
                                    LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    ).frame(width: 15, height: 15, alignment: .center)
                                }
                            }.padding(.horizontal, 20)
                        }
                    }.padding(.bottom, 15)
                    
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(25)
                            .opacity(0.5)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                        
                        VStack {
                            HStack {
                                Text("Tip")
                                    .fontWeight(.bold)
                                Text(" - ")
                                Text("\(tipViewModel.tipPercentage, specifier: "%.0f") %")
                                .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text("$ \(tipViewModel.tipAmount, specifier: "%.2f")")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.peachColor)
                            }
//                            ZStack {
//                                LinearGradient(
//                                    gradient: Gradient(colors: [.red, .blue]),
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                ).mask(Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1))
                                Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1)
//                                    .opacity(0.05)
                                    .accentColor(.peachColor).opacity(0.5)
//                            }
                        }.padding()
                    }
                    .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                        .shadow(color: Color.lightPurple.opacity(0.5), radius: 5, x: 5, y: 5)

                    .padding(.bottom, 15)

//                    VStack {
//
//                       Text("Select Tip")
//                        .font(.headline)
//                        Picker(selection: $tipViewModel.tipPercentage, label: Text("Select tip %")) {
//
//                            ForEach(0 ..< tipViewModel.tipChoices.count) { choice in
//
//                                    Text("\(self.tipViewModel.tipChoices[choice]) %").tag(self.tipViewModel.tipChoices[choice])
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                    }.padding(.vertical, 40)

                        VStack {
                                Text("Total Amount")
                                    .font(.title)
                                    .fontWeight(.light)
                                Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.darkPeachColor)
                        }.padding(.bottom, 5)

                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(25)
                            .opacity(0.5)
                            .frame(minWidth:0, maxWidth: 250, minHeight: 0, maxHeight: 100)
                        
                        VStack {
                            Text("How many persons?")
                                .fontWeight(.light)
                                .padding(.bottom, 5)

                            HStack{
                                Button(action: {
                                    print("minus tapped")
                                    self.tipViewModel.removePerson()
                                }, label: {
                                    LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "minus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        ).frame(width: 30, height: 30, alignment: .center)
                                })

                                TextField("1", text: $tipViewModel.person)
                                    .frame(width: 50, height: 30, alignment: .center)
                                    .multilineTextAlignment(.center)

                                Button(action: {
                                    print("plus tapped")
                                    self.tipViewModel.increasePerson()
                                    
                                }, label: {
                                    LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "plus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            
                                    ).frame(width: 30, height: 30, alignment: .center)

                                })
                            }
                        }
                    }.padding(.bottom, 10)
                        .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.lightPurple.opacity(0.5), radius: 5, x: 5, y: 5)

                         
                    ZStack {
                        Image("Path-1")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 80, height: 120)
                        VStack {
                            Text("Per Person")
                                .font(.title)
                                .fontWeight(.light)

                            HStack {
                                VStack {
                                    Text("Tip")
                                        .font(.headline)
                                    Text(self.tipViewModel.tipPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.tipPerPerson, specifier: "%.2f")")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.peachColor)

                                }.padding()

                                VStack {
                                    Text("Total")
                                        .font(.headline)
                                    Text(self.tipViewModel.totalPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalPerPerson, specifier: "%.2f")")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.darkPeachColor)

                                }.padding()
                            }.padding()
                        }.padding()
                    }

                    //SplitTipView().transition(.moveAndFade)
                    Spacer()
                    
                    Button(action: clearEverythingTap, label: {
                        Text("Clear Everything")
                            .font(.callout)
                            .foregroundColor(.darkPeachColor)
                    })

                }.padding()
            }
             .navigationBarTitle(Text("Quick Tip"))
            
        }
    }
    
    func closeButtonTap() {
        tipViewModel.billAmount = ""
    }
    
    func splitButtonTap()  {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.isOpenSplitView.toggle()
        }
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
    }
}
#endif

extension Color {
//    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let offWhite = Color(red: 240 / 255, green: 240 / 255, blue: 243 / 255)
    static let lightPurple = Color(red: 174 / 255, green: 174 / 255, blue: 192 / 255)
    static let peachColor = Color(red: 222 / 255, green: 136 / 255, blue: 149 / 255)
    static let darkPeachColor = Color(red: 188 / 255, green: 94 / 255, blue: 125 / 255)
    static let peachGradient = LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content.onTapGesture {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            keyWindow?.endEditing(true)
        }
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .padding(.leading, 40)
            .background(Color.offWhite)
            .cornerRadius(15)
            .frame(height: 66)
            .keyboardType(.decimalPad)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 4)
                    .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255), radius: 3, x: 6, y: 6)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.white, radius: 2, x: -4, y: -4)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            )
//            .foregroundColor(.black)
//            .background(
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color.white)
//                    .frame(height: 50)
//                                .shadow(color: Color.white.opacity(1), radius: 5, x: -3, y: -3)
//                                .shadow(color: Color.lightPurple.opacity(0.4), radius: 5, x: 3, y: 3)
//
//                    .shadow(color: Color.peachColor.opacity(0.17), radius: 5, x: -5, y: -4)
//                    .shadow(color: Color.darkPeachColor.opacity(0.17), radius: 5, x: 5, y: 4)
//            )

    }
}

//extension AnyTransition {
//    static var moveAndFade: AnyTransition {
//        let insertion = AnyTransition.move(edge: .bottom)
//            .combined(with: .opacity)
//        let removal = AnyTransition.move(edge: .bottom)//AnyTransition.scale
//            .combined(with: .opacity)
//        return .asymmetric(insertion: insertion, removal: removal)
//    }
//}

//struct SplitTipView: View {
//
//    @ObservedObject var tipViewModel = TipViewModel()
//
//    var body:some View {
//        VStack{
//            ZStack{
//                Rectangle()
//                    .fill(Color.white)
//                    .cornerRadius(25)
//                    .opacity(0.4)
//                    .frame(minWidth:0, maxWidth: 250, minHeight: 0, maxHeight: 100)
//
//                VStack {
//                    Text("How many persons?")
//                        .fontWeight(.medium)
//
//                    HStack{
//                        Button(action: {
//                            print("minus tapped")
//                            self.tipViewModel.removePerson()
//                        }, label: {
//                            Image(systemName: "minus.circle.fill")
//                                .imageScale(.large)
//                                .accentColor(Color.red)
//                        })
//
//                        TextField("1", text: $tipViewModel.person)
//                            .frame(width: 50, height: 30, alignment: .center)
//                            .multilineTextAlignment(.center)
//
//                        Button(action: {
//                            print("plus tapped")
//                            self.tipViewModel.increasePerson()
//
//                        }, label: {
//                            Image(systemName: "plus.circle.fill")
//                                .imageScale(.large)
//                                .accentColor(Color.red)
//                        })
//                    }
//                }
//
//
//            }
//
//
//            ZStack() {
//                Rectangle()
//                    .fill(Color.white)
//                    .cornerRadius(25)
//                    .opacity(0.25)
//                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
//                VStack {
//                    HStack {
//                        Text("Tip per person")
//                            .font(.headline)
//                        Spacer()
//                        Text(self.tipViewModel.tipPerPerson == 0.0 ? "$0.00" : "$\(self.tipViewModel.tipPerPerson, specifier: "%.2f")")
//                            .font(.title)
//                    }.padding(.all, 7)
//
//                    HStack {
//                        Text("Total per person")
//                            .font(.headline)
//                        Spacer()
//                        Text(self.tipViewModel.totalPerPerson == 0.0 ? "$0.00" : "$\(self.tipViewModel.totalPerPerson, specifier: "%.2f")")
//                            .font(.title)
//                    }.padding(.all, 7)
//                }.padding()
//            }
//        }
//    }
//}
