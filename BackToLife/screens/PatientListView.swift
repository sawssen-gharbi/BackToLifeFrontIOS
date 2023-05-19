
import SwiftUI



struct list_Patient: View {
    @StateObject var viewModel = ViewModel1()
    let userConnected_id = UserDefaults.standard.string(forKey: "userId")
    
    @State private var activeTag: String = "Natural"
    @Namespace private var animation
    var body: some View {
        NavigationView{
            VStack(spacing : 15){
                HStack (spacing : 150){
                 
                    Text ("My patient list")
                        .fontWeight(.semibold)
                        .padding(.leading, 15)
                        .foregroundColor(.gray)
                        .offset(y :2)
                    NavigationLink(destination: QRScannerPage()) {
                        Image(systemName: "viewfinder.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .font(.caption)
                            .foregroundColor(Color("DarkPink"))
                    }
                    
                }
                .frame(maxWidth : .infinity, alignment: .leading)
                .padding(.horizontal,15)
                TagsView()
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing : 10) {
                        ForEach(viewModel.reservations, id: \._id){
                            TherapyCardViewP($0)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                }
                .coordinateSpace(name: "SCROLLVIEW")
                .padding(.top, 15)
            }
        }
        .navigationTitle("therapies")
        .onAppear {
            viewModel.fetchReservations(doctorID: userConnected_id!)
            
        }
    }
    
    @ViewBuilder
    func TherapyCardViewP(_ therapy: Reservation) -> some View {
        GeometryReader { geometry in
            let size = geometry.size
            let rect = geometry.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                VStack(alignment: .leading, spacing: 6) {
                    Text((therapy.patient.firstName))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text(therapy.patient.email)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(therapy.patient.phone)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer(minLength: 5)

                    HStack(spacing: 4) {
                        Text("\(therapy.therapy.titre)")
                            .foregroundColor(Color("DarkPink"))
                            .fontWeight(.semibold)
                        Text("\(therapy.therapy.date)")
                            .foregroundColor(Color("DarkPink"))
                            .fontWeight(.semibold)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            viewModel.Accept(reservationId: therapy._id)
                        })  {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.gray)
                        }
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Reservation Accepted"),
                                  message: Text("You have successfully accepted the reservation."),
                                  dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .padding(20)
                .frame(width: size.width * 0.8, height: size.height * 0.8) // Adjust the width here
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5 , y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5 , y: -5)
                }
                .zIndex(1)
            }
            .frame(width: size.width) // Adjust the width here
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
        }
        .frame(height: 220)
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
                    TagView(tag: tag, activeTag: activeTag, animation: animation)
                        .padding(.horizontal, 12)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    struct TagView: View {
        let tag: String
        @State var activeTag: String?

        let animation: Namespace.ID
        
        var body: some View {
            Text(tag)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background {
                    if activeTag == tag {
                        Capsule()
                            .fill(Color("DarkPink"))
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    } else {
                        Capsule()
                            .fill(.gray.opacity(0.2))
                    }
                }
                .foregroundColor(activeTag == tag ? Color("white") : .gray )
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                        activeTag = tag
                    }
                }
        }
    }
}



