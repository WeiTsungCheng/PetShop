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
    
    let service: FetchProduct
    init(service: FetchProduct) {
        self.service = service
    }
    
    func transform(input: Input) -> Output {
        let setProductsSubject = PassthroughSubject<[Product], Never>()
        let reloadTableViewSubject = PassthroughSubject<Void, Never>()

        input.productsPublisher
            .flatMap { [weak self] _ -> AnyPublisher<[Product], Never> in
                guard let self = self else {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.service.fetch()
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .sink { products in
                setProductsSubject.send(products)
                reloadTableViewSubject.send(())
            }
            .store(in: &cancellable)
        
        return Output(setProductsPublisher: setProductsSubject.eraseToAnyPublisher(), reloadTableView: reloadTableViewSubject.eraseToAnyPublisher())
    }
    
}
