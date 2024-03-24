//
//  ProductService.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/24.
//

import Foundation
import Combine

protocol FetchProduct {
    func fetch() -> AnyPublisher<[Product], Error>
}

class ProductService: FetchProduct {
    
    func fetch() -> AnyPublisher<[Product], Error> {
        
        return Future<[Product], Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success(Product.collection))
            }
        }.eraseToAnyPublisher()
    }
}

