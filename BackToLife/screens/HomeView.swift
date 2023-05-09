import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            list_therapy()
                .tabItem { Label("Home", systemImage: "house") }
            ArticleView()
            
                .tabItem { Label("Articles", systemImage: "capslock") }
list_Patient()
                .tabItem { Label("patients", systemImage: "list.dash") }
            
            profileView1()
                .tabItem { Label("Profile", systemImage: "person") }
        }
    } }

struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
