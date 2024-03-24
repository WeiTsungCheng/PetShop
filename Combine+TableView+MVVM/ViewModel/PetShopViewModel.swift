//
//  PetShopViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/22.
//

import Foundation
import Combine

class PetShopViewModel {
    
    struct Input {
        let productsPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let setProductsPublisher: AnyPublisher<[Product], Never>
        let reloadTableView: AnyPublisher<Void, Never>
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let setProductsSubject = PassthroughSubject<[Product], Never>()
        let reloadTableViewSubject = PassthroughSubject<Void, Never>()
        
        input.productsPublisher.sink { () in
            setProductsSubject.send(Product.collection)
            reloadTableViewSubject.send(())
        }.store(in: &cancellable)
        
        return Output(setProductsPublisher: setProductsSubject.eraseToAnyPublisher(), reloadTableView: reloadTableViewSubject.eraseToAnyPublisher())
    }
    
}
