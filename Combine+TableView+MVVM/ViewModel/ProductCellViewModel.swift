//
//  CellViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation
import UIKit
import Combine

final class ProductCellViewModel {

    private let model: Product
    
    init(model: Product) {
        self.model = model
    }
    
    @Published var quantity: Double = 0.0
    @Published var isLiked: Bool = false
    
    var name: String {
        return model.name
    }
    
    var price: Int {
        return model.price
    }
    
    var imageName: String {
        return model.imageName
    }
    
}
