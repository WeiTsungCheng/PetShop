//
//  ProductCellController.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation
import Combine
import UIKit

enum ProductCellEvent {
    case quantityChanged(value: Double, product: Product)
    case heartDidTap(value: Bool, product: Product)
}

final class ProductCellController {
    private let viewModel: ProductCellViewModel
    private var cell: ProductTableViewCell?
    var cancellable = Set<AnyCancellable>()
    
    private let eventSubject = PassthroughSubject<ProductCellEvent, Never>()
    var eventPublisher: AnyPublisher<ProductCellEvent, Never> {
      eventSubject.eraseToAnyPublisher()
    }
    
    init(viewModel: ProductCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = configured(tableView.dequeueReusableCell())
        bind(cell)
        
        return cell
    }
    
    private func configured(_ cell: ProductTableViewCell) -> ProductTableViewCell {
        self.cell = cell
        
        cell.quantityLabel.text = "\(viewModel.quantity)"
        
        cell.productInfoLabel.text = """
        \(viewModel.name)\n\(viewModel.price)
        """
        cell.productImageView.image = UIImage(systemName: viewModel.imageName)
        
        let heartImage = viewModel.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        cell.heartButton.setImage(heartImage, for: .normal)
        
        return cell
    }
    
    func bind(_ cell: ProductTableViewCell) {

        cell.quantityPublisher
            .sink(receiveValue: { [weak self] count in
                guard let self = self else { return }
                self.viewModel.quantity = count
                self.eventSubject.send(.quantityChanged(value: count, product: self.viewModel.model))
            })
            .store(in: &cell.cancellable)
       
        cell.heartPublisher
            .sink { [weak self] isLike in
                guard let self = self else { return }
                self.viewModel.isLiked = isLike
                self.eventSubject.send(.heartDidTap(value: isLike, product: viewModel.model))
            }
            .store(in: &cell.cancellable)
        
        viewModel.$quantity.sink { [weak cell] num in
            cell?.quantityLabel.text = "\(num)"
        }
        .store(in: &cancellable)
        
    }
    
    
    
}
