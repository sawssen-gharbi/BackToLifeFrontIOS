//
//  MeditationViewController.swift
//  BackToLife
//
//  Created by Mac mini 8 on 8/5/2023.
//

import SwiftUI

struct MeditationViewController: View {
    var body: some View {
            NavigationView{
                ScrollView{
                    VStack{
                        Divider()
                        Text("Accepting The Mind")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.trailing, 100)
                        
                        YTView(ID: "qUcC71-W9Os")
                        
                        Text("Letting Go Of Effort")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.trailing, 100)
                        
                        YTView(ID: "wyj8l9miy4w")
                        
                        Text("Underlying Calm")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.trailing, 100)
                        
                        YTView(ID: "F0WYFXxhPGY")
                        
                        
                    }
                    
                }.navigationTitle("Meditaton Tips").foregroundColor(Color("DarkPink"))
                   
            }
         
        }
    }


struct MeditationViewController_Previews: PreviewProvider {
    static var previews: some View {
        MeditationViewController()
    }
}
