
import Foundation
class UserData: ObservableObject{
    @Published var id: Int?
    @Published var email: String?
    @Published var password: String?
    @Published var token: String?
    @Published var role: String?
    @Published var phone: String?
    @Published var address: String?
    @Published var firstName: String?
    @Published var nickName: String?
    @Published var image: String?
    @Published var certificat: String?


}
