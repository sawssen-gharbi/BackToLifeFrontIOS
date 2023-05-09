//
//  FetchRepport.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//


import SwiftUI
import Lottie

struct FetchReport: View {
    @State var txt = ""
    @StateObject  var viewModel3 = ViewModel3()
    

    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text("Reports")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color("DarkPink"))

                    Spacer(minLength: 0)

                }
                .padding()
                ScrollView(.vertical,showsIndicators: false){
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("DarkPink"))
                            TextField("Search Reports", text: $txt)
                            
                        }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background(Color("white"))
                        .clipShape(Capsule())
                        
                        Spacer(minLength: 30)
                        if viewModel3.reportMoods.isEmpty {
                            VStack(spacing: 5){
                               
                                LottieView(lottieFile: "emptyy1")
                                    .frame(width: 250, height: 250)
                                Text("No Reports Added Yet!")
                                    .foregroundColor(Color("DarkPink"))
                            }
                        }else{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing:20){
                            ForEach(viewModel3.reportMoods, id: \.self){ report in
                                ReportCardView(viewModel: viewModel3,report: report)
                            }
                        }
                    }
                    }
                    .padding(.horizontal, 15)
                }
                .onAppear{
                    viewModel3.fetch()
                }
            }
            .background(Color("black").opacity(0.07).ignoresSafeArea(.all,edges: .all))
        }
    }
}

struct LottieView: UIViewRepresentable {
    
    var lottieFile: String
    var loopMode: LottieLoopMode = .playOnce
    var animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
    }
}
struct ReportCardView: View {
    @ObservedObject var viewModel: FetchReport.ViewModel3

    var report: FetchReport.ViewModel3.MoodReport
    @State private var showAlert = false


    var body: some View {
        VStack(alignment: .leading){
            VStack{
                HStack {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("DarkPink"))
                        .onTapGesture {
                            viewModel.deleteReport(id: report._id)
                                        }
                                }
                                .padding(.trailing, 2)
                                .padding(.top, 5)
                                
                                
                Text(report.date)
                    .font(.body)

                HStack{
                    VStack(alignment: .center, spacing: 12){
                        switch report.mood {
                        case "Happy":
                            Image("happyy")
                                .resizable()
                                .frame(width: 90, height: 90, alignment: .center)
                        case "Sad":
                            Image("sadd")
                                .resizable()
                                .frame(width: 90, height: 90)
                        case "Manic":
                            Image("manicc")
                                .resizable()
                                .frame(width: 90, height: 90)
                        case "Calm":
                            Image("calmm")
                                .resizable()
                                .frame(width: 90, height: 90)
                        case "Angry":
                            Image("angryy")
                                .resizable()
                                .frame(width: 90, height: 90)
                        default:
                            Text("Unknown mood")
                        }
                        
                        Text("Feeling \(report.mood)")
                            .font(.title3
                            )
                            .foregroundColor(Color("DarkPink"))
                        
                        // low normal moderate high extreme severe
                        VStack(alignment: .leading){
                                HStack {
                                    Image("depression")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    switch report.depressedMood {
                                    case 0 :
                                        Text("Low")
                                            .font(.headline)
                                    case 1:
                                        Text("Normal")
                                            .font(.headline)
                                    case 2:
                                        Text("Moderate")
                                            .font(.headline)
                                    case 3:
                                        Text("High")
                                            .font(.headline)
                                    case 4:
                                        Text("Extreme")
                                            .font(.headline)
                                    case 5:
                                        Text("Severe")
                                            .font(.headline)
                                    default:
                                        Text("Unknown mood")
                                    }
                                  
                                }
                                HStack {
                                    Image("elevated")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    switch report.elevatedMood {
                                    case 0 :
                                        Text("Low")
                                            .font(.headline)
                                    case 1:
                                        Text("Normal")
                                            .font(.headline)
                                    case 2:
                                        Text("Moderate")
                                            .font(.headline)
                                    case 3:
                                        Text("High")
                                            .font(.headline)
                                    case 4:
                                        Text("Extreme")
                                            .font(.headline)
                                    case 5:
                                        Text("Severe")
                                            .font(.headline)
                                    default:
                                        Text("Unknown mood")
                                    }
                                }
                            
                            HStack {
                                Image("irritation")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                switch report.irritabilityMood {
                                case 0 :
                                    Text("Low")
                                        .font(.headline)
                                case 1:
                                    Text("Normal")
                                        .font(.headline)
                                case 2:
                                    Text("Moderate")
                                        .font(.headline)
                                case 3:
                                    Text("High")
                                        .font(.headline)
                                case 4:
                                    Text("Extreme")
                                        .font(.headline)
                                case 5:
                                    Text("Severe")
                                        .font(.headline)
                                default:
                                    Text("Unknown mood")
                                }
                            }
                        }
                    
                            
                        
                    }
                    .foregroundColor(Color("black"))
                    Spacer(minLength: 0)
                }
                .padding()
            }
            .background(Color("white"))
            .cornerRadius(15)
            
            Spacer(minLength: 0)
        }
    }
}

struct FetchReport_Previews: PreviewProvider {
    static var previews: some View {
        FetchReport()
    }
}
