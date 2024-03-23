//
//  ViewController.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/22.
//

import UIKit
import SnapKit

final class PetShopViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.showsHorizontalScrollIndicator = false
        tbv.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.cellIdentifier())
        
        return tbv
    }()
    
    var tableModel: [ProductCellController] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var viewModel: PetShopViewModel
    init(viewModel: PetShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let products: [Product] = Product.collection
        
        let cellControllers = products.map { product in
            let vm = ProductCellViewModel(model: product)
            let vc = ProductCellController(viewModel: vm)
            return vc
        }
        
        self.tableModel = cellControllers
        
    }
    
    private func setupUI() {
        title = "Pet Shop"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", image: nil, target: self, action: #selector(reset))
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
    }
    
    @objc func reset() {
        
    }

}
 
extension PetShopViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension PetShopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellController(forRowAt: indexPath).view(in: tableView, at: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> ProductCellController {
        return tableModel[indexPath.row]
    }

    
}

