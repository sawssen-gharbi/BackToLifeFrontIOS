//
//  QrScannerPage.swift
//  BackToLife
//
//  Created by Mac mini 8 on 17/5/2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, *)
struct QRScannerPage: View {
    @State private var isScanning:Bool = false
    @State private var session:AVCaptureSession = .init()
    @State private var cameraPermission :Permission = .idle
    @State private var qrOutput:AVCaptureMetadataOutput = .init()
    @State private var errorMessage:String = ""
    @State private var showError: Bool=false
    @Environment(\.openURL) private var openURL
    @StateObject private var qrDelegate = QRScannerDelegate()
    @State private var scannedCode: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        if #available(iOS 15.0, *) {
            VStack{
                HStack {
                    Button(action: {
                   dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    Text("QRcode")
                        .font(Font.system(size: 16, weight: .bold, design: .rounded))
                    Spacer()
                }
                if #available(iOS 14.0, *) {
                    Text("place the QR code inside the area")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.9))
                        .padding(.top,20)
                } else {
                    // Fallback on earlier versions
                }
                Text("scanning will start automaticly")
                    .font(.callout)
                    .foregroundColor(.gray)
                Spacer(minLength: 0)
                /// Scanner
                GeometryReader{
                    let size = $0.size
                    if #available(iOS 15.0, *) {
                        ZStack {
                            CameraPage(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                                .scaleEffect(0.97)
                            ForEach(0...4, id: \.self) { index in
                                let rotation = Double(index)*90
                                RoundedRectangle (cornerRadius: 2, style: .circular)
                                    .trim(from: 0.61, to: 0.64)
                                    .stroke (Color(.purple), style: StrokeStyle(lineWidth: 5, lineCap:.round, lineJoin: .round))
                                    .rotationEffect(.init(degrees:rotation))
                            }
                        }
                        // sqaure shape
                        .frame (width: size.width, height: size.width)
                        .overlay(alignment: .top, content: {
                            Rectangle()
                                .fill(Color(.purple))
                                .frame(height: 2.5)
                                .shadow(color: .black.opacity(0.8), radius: 8,x: 0,y: isScanning ? 15:-15)
                                .offset(y:isScanning ? size.width:0)
                        })
                        ///To Make it Center
                        .frame (maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .padding(.horizontal,45)
                Spacer(minLength: 15)
                Button{
                    if !session.isRunning && cameraPermission == .approved{
                        reactivateCamera()
                        activateScannerAnnimation()
                    }
                }label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                Spacer(minLength: 45)
                
            }
            .padding(15)
            .onAppear(perform: checkCameraPermission)
            .alert(errorMessage,isPresented: $showError){
                if cameraPermission == .denied{
                    Button("Settings"){
                        let settingsString = UIApplication.openSettingsURLString
                        if let settingsURL = URL(string: settingsString){
                            
                            openURL(settingsURL)
                        }
                    }
                    Button("Cancel", role: .cancel){
                        
                    }
                    
                }
            }
            .onChange(of: qrDelegate.ScannedCode){ newValue in
                if let code = newValue {
                    scannedCode = code
                    session.stopRunning()
                    deActivateScannerAnnimation()
                    qrDelegate.ScannedCode = nil
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    func reactivateCamera(){
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    func activateScannerAnnimation(){
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses:true)){
            isScanning = true
        }
    }
    
    
    func deActivateScannerAnnimation(){
        withAnimation(.easeInOut(duration: 0.85)){
            isScanning = false
        }
    }
    
   func checkCameraPermission(){
        Task{
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty{
                    setupCamera()
                } else {
                    session.startRunning()
                }
            case.notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video){
                    cameraPermission = .approved
                    setupCamera()
                }
                else{
                    cameraPermission = .denied
                    
                    //error message
                    presentError("please provide acces to camera for scanning code")
                    
                }
            case.denied, .restricted:
                cameraPermission = .denied
                presentError("please provide acces to camera for scanning code")

            default:break
                
            }
        }
    }
    
    //setting up camera
    func setupCamera(){
        
        do{
            
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes:[.builtInWideAngleCamera], mediaType: .video,position: .back).devices.first else {
                presentError("famech camera")
                return
            }
            
          let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input),session.canAddOutput(qrOutput) else {
                presentError("famech output ou input")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnnimation()
        } catch {
            presentError(error.localizedDescription)
        }
        
        
    }
    
    
    
    
    func presentError(_ message: String){
        errorMessage = message
        showError.toggle()
    }
    
    
}

struct QRScannerPage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            QRScannerPage()
        } else {
            // Fallback on earlier versions
        }
    }
}

