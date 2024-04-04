//
//  OrderUIComposer.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/4/5.
//

import Foundation

final class OrderUIComposer {
    
    public static func orderComposedWith(from vc: PetShopViewController, quantity: Int, cost: Int) -> OrderViewController {
        
        let orderVM = OrderViewModel(totalQuantities: quantity, totalCost: cost)
        let orderVC = OrderViewController(viewModel: orderVM)
        
        orderVC.modalPresentationStyle = .popover
        orderVC.preferredContentSize = .init(width: 300, height: 300)
        
        orderVC.popoverPresentationController?.sourceView = vc.view
        orderVC.popoverPresentationController?.sourceRect = CGRect(
            origin: CGPoint(
                x: vc.view.bounds.midX,
                y: vc.view.bounds.midY
            ),
            size: .zero
        )
        
        orderVC.popoverPresentationController?.permittedArrowDirections = []
        orderVC.popoverPresentationController?.delegate = vc
        
        orderVM.leaveOrderPage = {
            vc.dismiss(animated: false)
            vc.reset()
        }
        
        return orderVC
    }
}
