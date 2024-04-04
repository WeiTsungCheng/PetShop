//
//  PetShopUIComposer.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/24.
//

import Foundation

final class PetShopUIComposer {
    
    public static func petShopComposedWith(service: FetchProduct) -> PetShopViewController {
        let vm = PetShopViewModel(service: service)
        let vc = PetShopViewController(viewModel: vm)
        
        vm.presentOrderPage = { (quantity, cost) in
            
            let orderVC = OrderUIComposer.orderComposedWith(from: vc, quantity: quantity, cost: cost)
            
            vc.present(orderVC, animated: true)
        }
        
        vm.onProductLoad = adaptProductsToCellControllers(forwardingTo: vc)
        
        return vc
    }
    
    private static func adaptProductsToCellControllers(forwardingTo controller: PetShopViewController) -> ([Product]) -> Void {
        return { [weak controller] products in
            controller?.tableModel =  products.map({ product in
                let vm = ProductCellViewModel(model: product)
                let vc = ProductCellController(viewModel: vm)
                return vc
            })
        }
    }
}
