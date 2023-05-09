//
//  BreathType.swift
//  BackToLife
//
//  Created by Mac mini 8 on 2/5/2023.
//

import SwiftUI


struct Breatheype: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var color: Color
}

let sampleTypes: [Breatheype] = [
    .init(title: "Elevation" , color : Color("DarkPink")),
    .init(title: "Irritation" , color: .red),
    .init(title: "Depression" , color: .gray),

]
