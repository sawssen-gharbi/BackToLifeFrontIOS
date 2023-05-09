//
//  Reservation.swift
//  BackToLife
//
//  Created by Mac mini 8 on 26/4/2023.
//

import Foundation

struct Reservation: Decodable {
    var _id: String
    var patient: Patient
    var therapy: Therapyy
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case patient
        case therapy
    }
    
    struct Patient: Decodable {
        var id: String
        var nickName: String
        var firstName: String
        var email: String
        var password: String
        var phone: String
        // add other properties as needed
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case nickName
            case firstName
            case email
            case password
            case phone
        }
    }
    
    struct Therapyy: Decodable {
        var id: String
        var titre: String
        var date: String
        var address: String
        var description: String
        var capacity: Int
        // add other properties as needed
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case titre
            case date
            case address
            case description
            case capacity
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        patient = try container.decode(Patient.self, forKey: .patient)
        therapy = try container.decode(Therapyy.self, forKey: .therapy)
  
    }
}



