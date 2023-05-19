//
//  QrView.swift
//  BackToLife
//
//  Created by Mac mini 8 on 17/5/2023.
//

import SwiftUI
//struct QrView: View {
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                        let boutiqueName = UserDefaults.standard.string(forKey: "selectedBoutiqueName")
//
//                        if let window = UIApplication.shared.windows.first {
//                            window.rootViewController = UIHostingController(rootView: TabBarView())
//                            window.makeKeyAndVisible()
//                        }
//                }){
//                    Image(systemName: "arrow.left")
//                        .foregroundColor(.orange)
//                }
//                Spacer()
//                Text("QRcode")
//                    .font(Font.system(size: 16, weight: .bold, design: .rounded))
//                Spacer()
//            }
//            
//            let boutiqueName = UserDefaults.standard.string(forKey: "selectedBoutiqueName")
//
//            Spacer()
//            Image(uiImage: generateQRCode(from: boutiqueName!) ?? UIImage())
//                .interpolation(.none)
//                .resizable()
//            
//                .frame(width: 200, height: 200)
//            Spacer()
//        }
//    }
//    
//    /* func handleBackButtonTap() {
//        let viewC = TabBarView() // Create an instance of ViewC
//        let viewCToShow = AnyView(viewC) // Wrap ViewC in an AnyView
//        let destination = NavigationLink(destination: viewCToShow, label: { EmptyView() }) // Create a NavigationLink to ViewC
//        
//        presentationMode.wrappedValue.dismiss() // Dismiss the current view
//        DispatchQueue.main.async {
//            destination.simultaneousGesture(TapGesture().onEnded({ // Navigate to ViewC
//                
//            })).hidden()
//        }
//    }*/
//
//    
//    func generateQRCode(from string: String) -> UIImage? {
//        // Create a data object from the input string
//        let data = string.data(using: String.Encoding.ascii)
//
//        // Create a CIFilter instance for the CIQRCodeGenerator filter
//        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
//
//        // Set the input data for the filter
//        filter.setValue(data, forKey: "inputMessage")
//
//        // Get the output image from the filter
//        guard let outputImage = filter.outputImage else { return nil }
//
//        // Create a UIImage from the output image
//        let context = CIContext()
//        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
//        let image = UIImage(cgImage: cgImage!)
//
//        return image
//    }
//}
//
//struct QrView_Previews: PreviewProvider {
//    static var previews: some View {
//        QrView()
//    }
//}
//
