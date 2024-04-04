//
//  OrderViewModel.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/4/5.
//

import Foundation
import Combine

final class OrderViewModel {
    
    enum Input {
        case viewDidLoad
        case onCloseButtonTap
    }
    
    enum Output {
        case updateView(totalQuantities: Int, totalCost: Int)
    }
    
    private let output = PassthroughSubject<OrderViewModel.Output, Never>()
    var cancellable = Set<AnyCancellable>()
    
    var totalQuantities: Int
    var totalCost: Int
    
    var leaveOrderPage: (() -> Void)?
    
    init(totalQuantities: Int, totalCost: Int) {
        self.totalQuantities = totalQuantities
        self.totalCost = totalCost
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        input.sink { [unowned self] event in
            switch event {
            case .viewDidLoad:
                self.output.send(.updateView(totalQuantities: totalQuantities, totalCost: totalCost))
            case .onCloseButtonTap:
                break
            }
        }
        .store(in: &cancellable)
        
        return output.eraseToAnyPublisher()
    }
    
}
