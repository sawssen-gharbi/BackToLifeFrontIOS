//
//  list_therapy.swift
//  BackToLife
//
//  Created by Mac mini 8 on 24/3/2023.
//

import SwiftUI
import MapKit
struct list_therapy: View {
    @State private var showMap = false
    @State private var coordinates: CLLocationCoordinate2D?


    @StateObject var viewModel = ViewModel()
    @State private var activeTag: String = "Natural"
    @Namespace private var animation
    var body: some View {
        NavigationView{
            VStack(spacing : 15){
                HStack {
                    Text("Browse")
                        .font(.largeTitle.bold())
                    Text ("Recommended")
                        .fontWeight(.semibold)
                        .padding(.leading, 15)
                        .foregroundColor(.gray)
                        .offset(y :2)
                    
                }
                .frame(maxWidth : .infinity, alignment: .leading)
                .padding(.horizontal,15)
                TagsView()
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing : 35) {
                        ForEach(viewModel.therapies, id: \.self){
                            TherapyCardView($0)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                }
                .coordinateSpace(name: "SCROLLVIEW")
                .padding(.top, 15)
            }
        }
        .navigationTitle("therapies")
        .onAppear {
            viewModel.fetch()
            
        }.navigationBarBackButtonHidden(true)
    }
       
    @ViewBuilder
    func TherapyCardView(_ therapy : Therapy) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(therapy.titre)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    VStack {
                               Link(destination: getMapURL(therapy), label: {
                                   Text("Address: \(therapy.address)")
                                       .font(.caption)
                                       .foregroundColor(.gray)
                               })
                               .onOpenURL(perform: { _ in
                                   showMap = true
                               })
                               
                               if showMap {
                                   MapView(selectedCoordinate: $coordinates)
                                       .frame(height: 300)
                               }
                           }
                           .onAppear {
                               getCoordinates(for: therapy.address)
                           }
                    Text(therapy.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4){
                        Text("\(therapy.capacity)")
                        .foregroundColor(Color("DarkPink"))
                        .fontWeight(.semibold)
                        
                        Text("participants")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        NavigationLink(destination: ajout_therapy()) {
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }  .navigationBarBackButtonHidden(true)
                        NavigationLink(destination: UpdateTherapy( therapySelected: therapy)) {
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } 
                        Button(action: {
                            viewModel.deleteTherapy(id: therapy._id) { error in
                                if let error = error {
                                    print("Error deleting therapy: \(error.localizedDescription)")
                                } else {
                                    print("Therapy deleted successfully")
                                }
                            }
                        })  {
                                              Image(systemName: "trash")
                                                  .foregroundColor(.gray)
                                          } 
                        
                        
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08),radius: 8, x: 5 , y: 5)
                        .shadow(color: .black.opacity(0.08),radius: 8, x: -5 , y: -5)
                    
                }
                .zIndex(1)
              
                ZStack{
                    URLImage(urlString: therapy.image)

                     
                        .frame(width : size.width / 2 , height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: .black.opacity(0.1),radius: 5, x: 5 , y: 5)
                        .shadow(color: .black.opacity(0.1),radius: 5, x: -5 , y: -5)
                                    }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis :(x: 1, y:0, z:0), anchor: .center,anchorZ: 1,perspective: 1)
        }
        .frame(height : 220)
    }
    private func getMapURL(_ therapy : Therapy) -> URL {
          let encodedAddress = therapy.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
          let urlString = "https://maps.apple.com/?q=\(encodedAddress)"
          return URL(string: urlString)!
      }
    private func getCoordinates(for address: String) {
           let geocoder = CLGeocoder()
           geocoder.geocodeAddressString(address) { (placemarks, error) in
               guard let placemark = placemarks?.first, let location = placemark.location else {
                   return
               }
               
               coordinates = location.coordinate
           }
       }
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat{
        let cardHeight = rect.height
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight): 0
        let constrainedProgress = min (-progress, 1.0)
        return constrainedProgress * 90
        
        
    }
    @ViewBuilder
    func TagsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    tagView(for: tag)
                }.padding(.horizontal, 12)
            }
        }
    }

    func tagView(for tag: String) -> some View {
        let isTagActive = activeTag == tag
        
        return Text(tag)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background {
                if isTagActive {
                    Capsule()
                        .fill(Color("DarkPink"))
                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                } else {
                    Capsule()
                        .fill(.gray.opacity(0.2))
                }
            }
            .foregroundColor(isTagActive ? .white : .gray)
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                    activeTag = tag
                }
            }
    }

}


var tags : [String] = ["History", "Natural","Yoga","happiness","breathing","FANTASIE"]
struct list_therapy_Previews: PreviewProvider {
    static var previews: some View {
        list_therapy()
    }
}

struct URLImage: View {
    
    let urlString: String
    @State var data: Data?
    var body: some View {
        if let data = data , let uiimage = UIImage(data: data){
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(width : 200 , height: 70)
            
                .shadow(color: .black.opacity(0.1),radius: 5, x: 5 , y: 5)
                .shadow(color: .black.opacity(0.1),radius: 5, x: -5 , y: -5)
        }
        else {
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(width : 200 , height: 70)
            
                .shadow(color: .black.opacity(0.1),radius: 5, x: 5 , y: 5)
                .shadow(color: .black.opacity(0.1),radius: 5, x: -5 , y: -5)
                .onAppear{
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){data,_,_ in
            self.data = data
            
        }
        task.resume()
    }
    struct MapView: UIViewRepresentable {
        @Binding var coordinates: CLLocationCoordinate2D?
        
        func makeUIView(context: Context) -> MKMapView {
            MKMapView()
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.removeAnnotations(uiView.annotations)
            
            if let coordinates = coordinates {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                uiView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
                uiView.setRegion(region, animated: true)
            }
        }
    }
    
}

