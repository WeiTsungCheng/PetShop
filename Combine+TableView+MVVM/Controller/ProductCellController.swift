//
//  ProductCellController.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation
import Combine
import UIKit

final class ProductCellController {
    private let viewModel: ProductCellViewModel
    private var cell: ProductTableViewCell?
    private var cancellable = Set<AnyCancellable>()
    var cancellable = Set<AnyCancellable>()
    
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
                self?.viewModel.quantity = count
            })
            .store(in: &cancellable)
       
        cell.heartPublisher
            .sink { [weak self] isLike in
                self?.viewModel.isLiked = isLike
            }
            .store(in: &cancellable)
        
        viewModel.$quantity.sink { [weak cell] num in
            cell?.quantityLabel.text = "\(num)"
        }
        .store(in: &cell.cancellable)
        
        
    }
    
    
    
}
