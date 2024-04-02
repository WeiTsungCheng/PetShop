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

    private let _model: Product
    var model: Product {
        return _model
    }
    
    init(model: Product) {
        self._model = model
    }
    
    @Published var quantity: Double = 0.0
    @Published var isLiked: Bool = false
    
    var name: String {
        return _model.name
    }
    
    var price: Int {
        return _model.price
    }
    
    var imageName: String {
        return _model.imageName
    }
    
    
}
