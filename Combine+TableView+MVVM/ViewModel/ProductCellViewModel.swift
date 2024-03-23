//
//  CellViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation
import UIKit

class ProductCellViewModel {
    
    private let model: Product
    
    init(model: Product) {
        self.model = model
    }
    
    var quantity: Int = 0
    
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
