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
        return vc
    }
}
