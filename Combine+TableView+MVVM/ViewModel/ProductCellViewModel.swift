//
//  CellViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation
import UIKit
import Combine

class ProductCellViewModel {
    
    private let model: Product
    
    init(model: Product) {
        self.model = model
    }
    
    var quantity: Double = 0.0
    
    var isLiked: Bool = false
    
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
