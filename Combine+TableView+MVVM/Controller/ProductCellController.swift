//
//  ProductCellController.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import Foundation
import UIKit

final class ProductCellController {
    private let viewModel: ProductCellViewModel
    private var cell: ProductTableViewCell?
    
    init(viewModel: ProductCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        return cell
    }
    
    private func binded(_ cell: ProductTableViewCell) -> ProductTableViewCell {
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
    
}
