//
//  AddMood.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//

import SwiftUI

struct ItemMood: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let imgColor: Color
}

struct AddMood: View {
    
    @EnvironmentObject var report: Report
    @StateObject private var viewModel = ViewModel1()
    @State  var mood: String = ""
    @State  var date: String = ""
    let firstname = UserDefaults.standard.string(forKey: "fist")

    let items = [
        ItemMood(title: "Happy", image: "happyy", imgColor: .orange),
        ItemMood(title: "Sad", image: "sadd", imgColor: .green),
        ItemMood(title: "Angry", image: "angryy", imgColor: Color.black.opacity(0.8)),
        ItemMood(title: "Calm", image: "calmm", imgColor: .orange),
        ItemMood(title: "Manic", image: "manicc", imgColor: .orange),

    ]
    
    let spacing:CGFloat = 10
    @State private var numberOfRows = 3
    
    var body: some View {
        
        

        
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: spacing), count: 1)
        
        ScrollView{
            
            //HeaderView
            
            headerView
            
            
            LazyVGrid(columns:columns, spacing: spacing) {
                ForEach(items){ item in
                    Button(action: {
                        
                        viewModel.mood = item.title
                        let dateFormatter = DateFormatter()
                                               dateFormatter.dateFormat = "yyyy-MM-dd"
                                               let dateString = dateFormatter.string(from: Date())
                                               viewModel.date = dateString
                        Task {
                           
                            let result: () = try await viewModel.attemptMood(report: self.report)
                          
                        }
                        
                        
                        
                    }) {
                        ItemView(i: item)
                    }
                    .buttonStyle(ItemButtonStyle(cornerRadius: 20))
                }
            }
            .padding(.horizontal)
            .offset(y: -50)

        }
        .background(Color.white)
        .ignoresSafeArea()
    }
    var headerView: some View {
        VStack(spacing: 40){
          //  HStack(spacing: 150) {
//                Text("Sawssen")
//                    .foregroundColor(.white)
//                    .font(.system(size: 25 , weight: .medium, design: .rounded))
//
//                Image("happy")
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                  }
//
               
        
            
            Text("How are you feeling today? ")
                .foregroundColor(Color.black.opacity(0.7))
                .font(.system(size: 25 , weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
            
        }
        .frame(height: 280)
        .frame(maxWidth: .infinity)
        .background(Color("LightPink"))
        
    }
}


struct ItemButtonStyle: ButtonStyle {
    let cornerRadius: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            configuration.label
            if configuration.isPressed {
                Color.black.opacity(0.3)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2),radius: 10, y: 5)
        
    }
}

struct ItemView: View {
    let i: ItemMood
    var body: some View{
        GeometryReader{reader in
            
            let fontSize = min(reader.size.width * 0.2, 28)
            let imageWidth: CGFloat = min (75, reader.size.width * 0.6)
            
            
            VStack(spacing: 5){
                Image(i.image)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(i.imgColor)
                    .frame(width: imageWidth )
                Text(i.title)
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .foregroundColor(Color.black.opacity(0.9))
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Color.white)
            
        }
        .frame(height: 150)
        //.clipShape(RoundedRectangle(cornerRadius: 20))
        //.shadow(color: Color.black.opacity(0.2),radius: 10, y: 5)
    }
    
    
}
struct add_mood_Previews: PreviewProvider {
    static var previews: some View {
        AddMood()
        
    }
}
