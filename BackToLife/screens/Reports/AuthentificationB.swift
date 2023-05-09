import SwiftUI
import LocalAuthentication

struct Authh: View {
    @State private var supportState: SupportState = .unknown
    @State private var authorized = "Not Authorized"
    @State private var isAuthenticating = false
    @State private var authenticationSuccess = false

    let context = LAContext()
    
    enum SupportState {
        case unknown, supported, unsupported
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    if supportState == .unknown {
                        ProgressView()
                    } else if supportState == .supported {
                        Text("This device is supported")
                    } else {
                        Text("This device is not supported")
                    }
                    
                    Divider().padding(.vertical, 20)
                    
                    Image("secur")
                        .resizable()
                        .frame(width: 200, height: 300)
                    
                    Divider().padding(.vertical, 50)
                    
                    if isAuthenticating {
                        Button(action: cancelAuthentication) {
                            HStack {
                                Text("Cancel Authentication")
                                Image(systemName: "xmark")
                            }
                        }
                    } else {
                        VStack(spacing: 20) {
                            Button(action: authenticate) {
                                HStack {
                                    Text("Authenticate")
                                    Image(systemName: "info.circle")
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("DarkPink"))
                                .cornerRadius(8)
                            }
                            
                                                        Button(action: authenticateWithBiometrics) {
                                                            HStack {
                                                                Text(isAuthenticating ? "Cancel" : "Authenticate: biometrics only")
                                                                Image(systemName: "fingerprint")
                                                            }
                                                            .foregroundColor(.white)
                                                            .padding()
                                                            .background(Color("DarkPink"))
                                                            .cornerRadius(8)
                                                        }
                            //
                            Text("Current State: \(authorized)")
                            
                            if authenticationSuccess {
                                   NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                                       HStack {
                                           Text("Log In")
                                           Image(systemName: "cancel")
                                       }
                                   }
                               }
                        }
                    }
                }
                .padding(.top, 30)
                .navigationBarTitle("Security and Privacy", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {}) {
                    Image(systemName: "security.update")
                })
            }
        }
        .onAppear(perform: setupAuthentication)
        .navigationBarBackButtonHidden(true)
    }
    
    func setupAuthentication() {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        context.localizedReason = "Authentication is required to access this feature."
        
        if context.biometryType == .touchID {
            supportState = .supported
        } else if context.biometryType == .faceID {
            supportState = .supported
        } else {
            supportState = .unsupported
        }
    }
    
    func cancelAuthentication() {
        context.invalidate()
        isAuthenticating = false
        authorized = "Authentication Canceled"
    }
    
    func authenticate() {
        isAuthenticating = true
        authorized = "Authenticating"
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Let OS determine authentication method") { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false
                
                if success {
                    authorized = "Authorized"
                    authenticationSuccess = true
                } else if let error = error {
                    authorized = "Error - \(error.localizedDescription)"
                } else {
                    authorized = "Not Authorized"
                }
            }
        }
    }
    func authenticateWithBiometrics() {
        isAuthenticating = true
        authorized = "Authenticating"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Scan your fingerprint (or face or whatever) to authenticate") { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false
                
                if success {
                    authorized = "Authorized"
                    // Navigate to HomeScreen
                } else if let error = error {
                    authorized = "Error - \(error.localizedDescription)"
                } else {
                    authorized = "Not Authorized"
                }
            }
        }
    }
}
