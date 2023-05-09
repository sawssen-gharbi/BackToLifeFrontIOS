//
//  viewableSecure.swift
//  BackToLife
//
//  Created by Mac mini 8 on 24/4/2023.
//
import SwiftUI

struct ViewableSecureField: View {
    let caption: String
    @Binding var text: String
    let placeholder: String
    
//    @State private var password: String = ""
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(caption)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("black"))
                    Spacer()
                }
                .frame(width: 310)
                
                HStack {
                    if isSecure == true {
                        SecureField(placeholder, text: $text)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color("black").opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
                    } else {
                        TextField(text == "" ? "Enter password" : text, text: $text)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color("black").opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
                    }
                }.overlay(alignment: .trailing) {
                    Image(systemName: isSecure == false ? "eye.slash" : "eye")
                        .onTapGesture {
                            isSecure.toggle()
                        }.padding([.trailing], 10)
                }
            }
            .frame(width: geometry.size.width)
        } // End of GeometryReader
        .frame(height: 100)
    }
}

struct ViewableSecureField_Previews: PreviewProvider {
    static var previews: some View {
        ViewableSecureField(caption: "Password", text: .constant(""), placeholder: "Enter password")
    }
}
