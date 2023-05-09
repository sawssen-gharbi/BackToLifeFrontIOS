
//  Breathing.swift
//  BackToLife
//
//  Created by Mac Mini 2 on 1/5/2023.
//

import SwiftUI
import AVFoundation


struct Breathing: View {
    @State var currentType: Breatheype = sampleTypes[0]
    @Namespace var animation
    @State var showBreatheView: Bool = false
    @State var startAnimation: Bool = false
    @State var timerCount: CGFloat = 0
    @State var breathingAction: String = "Breathe In"
    @State var count: Int = 0
    @State var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack{
            Background()
            Content()
            Text(breathingAction)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .opacity(showBreatheView ? 1 : 0)
                .animation(.easeInOut(duration:1), value: breathingAction)
                .animation(.easeInOut(duration: 1), value: showBreatheView)
        }
        .onReceive(Timer.publish(every: 0.01 , on: .main, in: .common).autoconnect()) { _ in
            if showBreatheView{
                if timerCount > 3.2{
                    timerCount = 0
                    breathingAction = (breathingAction == "Breathe Out" ? "Breathe In" : "Breathe Out")
                    withAnimation(.easeInOut(duration: 3).delay(0.1)){
                        startAnimation.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }else{
                    timerCount += 0.01
                }
                count = 3 - Int(timerCount)
            }else{
                timerCount = 0
            }
        }//end here
        .onAppear {
            playBackgroundMusic()
    }
    }

    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // loop the music indefinitely
            audioPlayer?.play()
        } catch {
            print("Error playing background music: \(error)")
        }
    }

    
    @ViewBuilder
    func Content() -> some View {
        VStack {
            BreatheTitle()
            
            GeometryReader { proxy in
                let size = proxy.size
                
                VStack {
                    BreatheView(size: size)
                    
                    BreatheDescription()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleTypes) { type in
                                TabButton(type: type)
                            }
                        }
                        .padding()
                        .padding(.leading, 25)
                    }
                    .opacity(showBreatheView ? 0 : 1)
                                       Button(action: startBreathing){
                                           Text(showBreatheView ?"Finish Breathing" : "START")
                                               .fontWeight(.semibold)
                                               .foregroundColor(showBreatheView ? .white.opacity(0.75) : .black)
                                               .padding(.vertical, 15)
                                               .frame(maxWidth: .infinity)
                                               .background{
                                                   if showBreatheView{
                                                       RoundedRectangle(cornerRadius: 12 , style: .continuous)
                                                           .stroke(.white.opacity(0.5))
                                                   }else{
                                                       RoundedRectangle(cornerRadius: 12 , style: .continuous)
                                                           .fill(currentType.color.gradient)
                                                   }
                                               }
                                       } // end here
                                       .padding()
                                       
                                       
                                   }.frame(width: size.width , height: size.height , alignment: .bottom)
                                   
                               }
                           }
                           .frame(maxHeight: .infinity, alignment: .top)
                       }

    @ViewBuilder
    private func BreatheTitle() -> some View {
        HStack {
            Text("Breathe")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .opacity(showBreatheView ? 0 : 1)
    }

    @ViewBuilder
    private func BreatheDescription() -> some View {
        Text("Breathe to reduce")
            .font(.title3)
            .foregroundColor(.white)
            .opacity(showBreatheView ? 0 : 1)
    }
    
    
    @ViewBuilder
    func BreatheView(size: CGSize) -> some View {
        ZStack{
            ForEach(1...8, id: \.self) { index in
                Circle()
                    .fill(currentType.color.gradient.opacity(0.5))
                    .frame(width: 150 , height: 150 )
                    .offset(x: startAnimation ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(index) * 45 ))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0 ))
                
                
            }
        }
        .scaleEffect(startAnimation ? 0.8 : 1)
        .overlay(content: {
            Text("\(count == 0 ? 1 : count )")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .animation(.easeInOut , value: count)
                .opacity(showBreatheView ? 1 : 0 )
            
            
        })// end here
        .frame(height: (size.width - 40 ))
        
    }
   
    @ViewBuilder
    private func TabButton(type: Breatheype) -> some View {
        Text(type.title)
                                           .foregroundColor(currentType.id == type.id ? .black : .white)
                                           .padding(.vertical , 10)
                                           .padding(.horizontal, 15)
                                           .background{
                                               ZStack{
                                                   if currentType.id == type.id {
                                                       RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                           .fill(.white)
                                                           .matchedGeometryEffect(id: "TAB", in: animation)
                                                   }else{
                                                       RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                           .stroke(.white.opacity(0.5))
                                                   }
                                               }
                                               
                                           }// end here
                                           .contentShape(Rectangle())
                                           .onTapGesture {
                                               withAnimation(.easeInOut){
                                                   currentType = type
                                               }
                                           }
    }



               

    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader{ proxy in
            let size = proxy.size
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                          .frame(width: size.width, height: size.height)
                          
                .clipped()
                .blur(radius: startAnimation ? 4 : 0, opaque: true)
                .overlay{
                    ZStack{
                        Rectangle()
                            .fill(.linearGradient(colors: [currentType.color.opacity(0.9), .clear , .clear] , startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height / 1.5)
                            .frame(maxHeight: .infinity, alignment: .top)
                        
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .clear,
                                .darkGray ,
                                .darkGray,
                                .clear,
                                .clear,
                                ] , startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height / 1.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                        
                       
                    } // end here
                    }
                
        }
        .ignoresSafeArea()
    }//end here
    func startBreathing(){
        withAnimation(.interactiveSpring(response: 0.6 , dampingFraction: 0.7 , blendDuration: 0.7)){
            showBreatheView.toggle()
        }
        if showBreatheView{
            withAnimation(.easeInOut(duration: 3).delay(0.05)){
                startAnimation = true
            }
        }else{
            withAnimation(.easeInOut(duration: 1.5)){
                startAnimation = false
            }
        }
    }
}

struct Breathing_Previews: PreviewProvider {
    static var previews: some View {
        Breathing().preferredColorScheme(.dark)
    }
}
