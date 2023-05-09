//
//  AddReport.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//

import SwiftUI
import SwiftUIX

struct AddReport: View {
    
    @StateObject var report: Report
    @StateObject  var viewModel2 = ViewModel2()
    @State var depressedMood: Float = 0
    @State var elevatedMood: Float = 0
    @State var irritabilityMood: Float =  0
    
    var body: some View {
   
       
        
        ZStack{
            Image("color-bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false){
                VStack{
                    Spacer().frame(height: 30)
                    
                    MoodCard( sliderValue: $depressedMood , title:"Today's depressed mood:" )
                    MoodCard(sliderValue: $elevatedMood , title:"Today's elevated mood:" )
                    MoodCard(sliderValue: $irritabilityMood, title:"Today's irritability mood:" )
                    
                    Spacer().frame(height: 30)
                    

                    Button(action: {
                        
                        viewModel2.depressedMood = Int(Float(depressedMood))
                        viewModel2.elevatedMood = Int(Float(elevatedMood))
                        viewModel2.irritabilityMood = Int(Float(irritabilityMood))
                        
                        Task{
                            let result: () = try await viewModel2.attemptEditMood(report: Report())
                        }
                    }) {
                        Text("Done")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("white"))
                            .frame(height: 44)
                            .padding(.horizontal, 88)
                            .background(Color("DarkPink"))
                            .cornerRadius(50)
                    }
                    
                }
            }
          
            
        }
    }
}


struct MoodCard: View{

   
    @Binding var sliderValue : Float
    
        var title: String = "How's your depressed mood today?"
    
    var body: some View {
        VisualEffectBlurView(blurStyle: .light, content: {
            VStack(alignment: .leading, spacing: 8){
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color("DarkPink").opacity(0.7))
                
                VStack {
                    Text("Current Slider Value: \(Int(sliderValue))").foregroundColor(Color("DarkPink"))
                    Slider(value: $sliderValue, in: 0...5) {
                        Text("Slider")
                    } minimumValueLabel: {
                        Image(systemName: "hand.thumbsdown").foregroundColor(Color("DarkPink"))
                        
                    } maximumValueLabel: {
                        Image(systemName: "hand.thumbsup").foregroundColor(Color("DarkPink"))
                        
                    }.tint(Color("DarkPink"))
                    
                        .padding()
                    
                }
                
            }
            
            
            .padding()
            
        })
        .frame(width: 320, height: 200)
        .mask(RoundedRectangle(cornerRadius: 30,style: .continuous))
        .background(
            RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.white).opacity(0.8)
        )
       
            
            
            
        }
    }
    


struct add_report_Previews: PreviewProvider {
    static var previews: some View {
        AddReport(report: Report())
    }
}
