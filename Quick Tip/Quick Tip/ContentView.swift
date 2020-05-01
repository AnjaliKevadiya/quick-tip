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
                .modifier(DismissKeyboard())
//                .gesture(DragGesture().onChanged{_ in
//                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                })

                VStack {
                    ZStack{
                        TextField("Enter bill amount", text: $tipViewModel.billAmount, onEditingChanged: { _ in
                            self.isShowCloseButton.toggle()
                        })
                        .padding(20)
                        .padding(.leading, 40)
                        .frame(height: 60)
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
                    }.padding(.bottom, 20)

                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(25)
                            .opacity(0.5)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

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
                                    .foregroundColor(.peachColor)
                            }
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [.peachColor, .darkPeachColor]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ).mask(Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1))
                                Slider(value: $tipViewModel.tipPercentage, in: 0...50, step: 1)
                                    .opacity(0.02)
                            }.frame(height: 40, alignment: .center)
                        }.padding()
                    }
                    .padding(.bottom, 25)


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
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding(.bottom, 10)
                        
                            Text(self.tipViewModel.totalAmount == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalAmount, specifier: "%.2f")")
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                                .foregroundColor(.darkPeachColor)
                    }.padding(.bottom, 5)

                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(25)
                            .opacity(0.5)
                            .frame(minWidth:0, maxWidth: 250, minHeight: 0, maxHeight: 100)
                            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -5, y: -5)
                            .shadow(color: Color.lightPurple.opacity(0.6), radius: 5, x: 5, y: 5)

                        VStack {
                            Text("How many persons?")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
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
                                    LinearGradient(gradient: Gradient(colors: [.peachColor, .darkPeachColor]), startPoint: .top, endPoint: .bottom)
                                        .mask(Image(systemName: "plus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)

                                    ).frame(width: 30, height: 30, alignment: .center)
                                })
                            }
                        }
                    }.padding(.bottom, 20)

                    VStack {
                        
//                        HStack {
                            Text("Per Person")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
//                            Spacer()
//                                .multilineTextAlignment(.center)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 2)
//                                        .frame(width: 150, height: 50, alignment: .center)
//                                        .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
//                                        .shadow(color: Color.lightPurple.opacity(0.5), radius: 2, x: 1, y: 1)
//                                )
//                        }.padding(.horizontal, 20)
                        
                            VStack {

                                HStack {
                                    VStack {
                                        Text("Tip")
                                            .font(.system(size: 18, weight: .semibold, design: .rounded
                                                ))
                                            .padding(.bottom, 10)
                                            .allowsTightening(true)

                                        Text(self.tipViewModel.tipPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.tipPerPerson, specifier: "%.2f")")
                                            .font(.system(size: 22, weight: .semibold, design: .rounded
                                                ))
                                            .foregroundColor(.peachColor)
                                            .allowsTightening(true)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                    
                                    Rectangle()
                                        .frame(width: 2, height: 60)
                                        .foregroundColor(Color(red: 236/255, green: 234/255, blue: 235/255))
                                        .shadow(color: Color.white.opacity(0.2), radius: 2, x: -1, y: -1)
                                        .shadow(color: Color.white.opacity(0.2), radius: 2, x: 1, y: 1)

                                    VStack {
                                        Text("Total")
                                            .font(.system(size: 18, weight: .semibold, design: .rounded
                                                ))
                                            .padding(.bottom, 10)
                                            .allowsTightening(true)
                                        Text(self.tipViewModel.totalPerPerson == 0.0 ? "$ 0.00" : "$ \(self.tipViewModel.totalPerPerson, specifier: "%.2f")")
                                            .font(.system(size: 22, weight: .semibold, design: .rounded
                                                ))
                                            .foregroundColor(.darkPeachColor)
                                            .allowsTightening(true)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                }.padding()
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 2)
                                    .shadow(color: Color.white.opacity(0.4), radius: 2, x: -1, y: -1)
                                    .shadow(color: Color.lightPurple.opacity(0.5), radius: 2, x: 1, y: 1)
                            )

                    }.padding(.top, 10)

                    Spacer()

                    Button(action: clearEverythingTap, label: {
                        Text("Clear Everything")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.darkPeachColor)
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

//struct CustomShape : Shape {
//
//    var corner : UIRectCorner
//    var radii : CGFloat
//
//    func path(in rect: CGRect) -> Path {
//
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
//        return Path(path.cgPath)
//    }
//}

//extension AnyTransition {
//    static var moveAndFade: AnyTransition {
//        let insertion = AnyTransition.move(edge: .bottom)
//            .combined(with: .opacity)
//        let removal = AnyTransition.move(edge: .bottom)//AnyTransition.scale
//            .combined(with: .opacity)
//        return .asymmetric(insertion: insertion, removal: removal)
//    }
//}

