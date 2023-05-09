

//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var userData: UserData
    @EnvironmentObject var report: Report
    var body: some View {
        if userData.token != "" {
            SplashScreenView()
        } else {
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject private var userData: UserData
    @EnvironmentObject var report: Report
    static var previews: some View {
        ContentView()
    }
    struct storyboardview: UIViewControllerRepresentable{
              
              func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
                  
              }
              
              func makeUIViewController(context: Context) -> some UIViewController {
                  let storyboard = UIStoryboard(name: "LoginGoogleView", bundle: Bundle.main)
                  let controller = storyboard.instantiateViewController(withIdentifier: "LoginGoogleViewController")
                  return controller
                  
              }
              
              
          }
}
