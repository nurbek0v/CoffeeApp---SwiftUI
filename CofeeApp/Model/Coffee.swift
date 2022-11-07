//
//  Coffee.swift
//  CofeeApp
//
//  Created by Kalchabek Nurbekov on 07.11.2022.
//

import SwiftUI
//MARK: - Coffee model with sample data
struct Coffee: Identifiable {
    var id: UUID = .init()
    var imageName: String
    var title: String
    var price: String
}
var coffees: [Coffee] = [
    .init(imageName: "iced capucino", title: "Iced capucino", price: "88 som"),
    .init(imageName: "Iced Coconut", title: "Iced cocnut ", price: "110 som"),
    .init(imageName: "iced milk coffee", title: "Iced milk coffee ", price: "98 som"),
    .init(imageName: "Iced Mocha", title: "Iced mocha ", price: "165 som"),
    .init(imageName: "item1", title: "Capucino ", price: "205 som"),
    .init(imageName: "item2", title: "Iced americano", price: "140 som")
]

