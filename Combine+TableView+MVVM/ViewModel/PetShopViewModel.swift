//
//  PetShopViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/22.
//

import Foundation
import Combine

final class PetShopViewModel {
    
    struct Input {
        let productsPublisher: AnyPublisher<Void, Never>
        let cellEventPublisher: AnyPublisher<ProductCellEvent, Never>
    }
    
    struct Output {
        let setProductsPublisher: AnyPublisher<[Product], Never>
        let reloadTableView: AnyPublisher<Void, Never>
    }
    
    var cancellable = Set<AnyCancellable>()
    
    @Published var cart: [Product: Double] = [:]
    
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
                    .handleEvents(receiveCompletion: { _ in
                        reloadTableViewSubject.send(())
                    })
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .subscribe(setProductsSubject)
            .store(in: &cancellable)
        
        input.cellEventPublisher
            .sink { [weak self] event in
                switch event {
                case let .quantityChanged(value, product):
                    self?.cart[product] = value
                case .heartDidTap:
                    break
                }
            }
            .store(in: &cancellable)
        
        return Output(setProductsPublisher: setProductsSubject.eraseToAnyPublisher(), reloadTableView: reloadTableViewSubject.eraseToAnyPublisher()
        )
    }
    
}
