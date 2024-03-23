//
//  PetShopUIComposer.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/24.
//

import Foundation

final class PetShopUIComposer {
    
    public static func petShopComposedWith() -> PetShopViewController {
        let vm = PetShopViewModel()
        let vc = PetShopViewController(viewModel: vm)
        return vc
    }
}
