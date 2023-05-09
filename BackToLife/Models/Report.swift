//
//  Report.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//

import Foundation

class Report: ObservableObject{
    
    @Published var _id: String?
    @Published var date: String?
    @Published var mood: String?
    @Published var depressedMood: Int?
    @Published var elevatedMood: Int?
    @Published var irritabilityMood: Int?
    @Published var symptoms: String?
    @Published var user : String?
  

}
//
