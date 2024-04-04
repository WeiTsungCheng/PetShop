//
//  PetShopViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/22.
//

import Foundation
import Combine

final class PetShopViewModel {
    
    enum Input {
        case viewDidLoad
        case onProductCellEvent(event: ProductCellEvent, product: Product)
        case onResetButtonTap
    }
    
    enum Output {
        case setProducts(products: [Product])
        case updateView(totalQuantities: Int, totalCost: Int, likedProductIds: Set<Int>, productQuantities: [Int: Int])
    }
    
    private let output = PassthroughSubject<PetShopViewModel.Output, Never>()
    var cancellable = Set<AnyCancellable>()
    
    private var cart: [Product: Int] = [:]
    private var likes: [Product: Bool] = [:]
    
    let service: FetchProduct
    init(service: FetchProduct) {
        self.service = service
    }
    
    var onProductLoad: (([Product]) -> Void)?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        input.sink { [unowned self] event in
            switch event {
            case .viewDidLoad:
                
                service.fetch()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        print(completion)
                    } receiveValue: { [unowned self] products in
                        self.output.send(.setProducts(products: products))
                        
                        self.output.send(.updateView(totalQuantities: totalQuantities, totalCost: totalCost, likedProductIds: likedProductIds, productQuantities: productQuantities))
                    }
                    .store(in: &cancellable)
                
            case .onResetButtonTap:
                cart.removeAll()
                likes.removeAll()
                output.send(.updateView(totalQuantities: totalQuantities, totalCost: totalCost, likedProductIds: likedProductIds, productQuantities: productQuantities))
                
            case .onProductCellEvent(let event, let product):
                switch event {
                case .quantityDidChange(let value):
                    cart[product] = value
                    output.send(.updateView(totalQuantities: totalQuantities, totalCost: totalCost, likedProductIds: likedProductIds, productQuantities: productQuantities))
                case .heartDidTap:
                    if let value = likes[product] {
                        likes[product] = !value
                    } else {
                        likes[product] = true
                    }
                    output.send(.updateView(totalQuantities: totalQuantities, totalCost: totalCost, likedProductIds: likedProductIds, productQuantities: productQuantities))
                }
            }
        }
        .store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }

    private var totalQuantities: Int {
        cart.reduce(0, { $0 + $1.value })
    }
    
    private var totalCost: Int {
        cart.reduce(0, { $0 + ($1.value * $1.key.price )})
    }
    
    private var likedProductIds: Set<Int> {
        let array = likes.filter { $0.value == true }.map { $0.key.id }
        return Set(array)
    }
    
    private var productQuantities: [Int: Int] {
        var temp = [Int: Int]()
        cart.forEach { key, value in
            temp[key.id] = value
        }
        return temp
    }
    
}
