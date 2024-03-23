//
//  Product.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation

struct Product {
    let name: String
    let imageName: String
    let price: Int
    let id: Int
}

extension Product {
    static let collection: [Product] = [
      .init(name: "Dog", imageName: "dog", price: 200, id: 1),
      .init(name: "Cat", imageName: "cat", price: 120, id: 2),
      .init(name: "Bird", imageName: "bird", price: 300, id: 3),
      .init(name: "Lizard", imageName: "lizard", price: 400, id: 4),
      .init(name: "Fish", imageName: "fish", price: 1000, id: 5)
    ]
}
