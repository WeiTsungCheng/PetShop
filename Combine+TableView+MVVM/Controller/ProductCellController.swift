////
////  ProductCellController.swift
////  Combine+TableView+MVVM
////
////  Created by WEI-TSUNG CHENG on 2024/3/23.
////
//
import Foundation
import Combine
import UIKit

final class ProductCellController {
    var viewModel: ProductCellViewModel
    private var cell: ProductTableViewCell?
    
    var product: Product {
        return viewModel.model
    }
    
    func setViewModel(viewModel: ProductCellViewModel) {
        self.viewModel = viewModel
    }
    
    init(viewModel: ProductCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> ProductTableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        return cell
    }
    
    func binded(_ cell: ProductTableViewCell) -> ProductTableViewCell {
        self.cell = cell
        
        let product = viewModel.model
        let quantity = viewModel.quantity
        let isLiked = viewModel.isLiked
        
        cell.productInfoLabel.text = """
                \(product.name)\n\(product.price)
                """
        cell.quantityLabel.text = String(quantity)
        cell.stepper.value = Double(quantity)
        let image: UIImage? = isLiked ? .init(systemName: "heart.fill"): .init(systemName: "heart")
        cell.heartButton.setImage(image, for: .normal)
        cell.productImageView.image = UIImage(systemName: product.imageName)
        
        return cell
    }
    
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
    
}
