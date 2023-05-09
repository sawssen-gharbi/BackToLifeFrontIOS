import SwiftUI

struct ProfileView: View {
    let first = UserDefaults.standard.string(forKey: "first")
    let nixk = UserDefaults.standard.string(forKey: "nick")
    let email = UserDefaults.standard.string(forKey: "email")
    let phone = UserDefaults.standard.string(forKey: "phone")
    let add = UserDefaults.standard.string(forKey: "address")

    var body: some View {
        VStack(spacing: 20) {
            Image("register")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .clipShape(Circle())
                .shadow(radius: 10)
            
            Text(first!)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(nixk!)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal, 50)
            
            VStack(alignment: .leading, spacing: 10) {
                InfoRow(imageName: "envelope", label:email!)
                InfoRow(imageName: "phone", label: phone!)
                InfoRow(imageName: "house", label: add!)
            }
            .padding(.horizontal, 50)
            
            Spacer()
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct InfoRow: View {
    let imageName: String
    let label: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: imageName)
                .foregroundColor(.secondary)
            
            Text(label)
        }
    }
}
