//
//  ViewController.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/22.
//

import UIKit
import SnapKit
import Combine

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
    
    var tableModel: [ProductCellController] = []
    private var cancellable = Set<AnyCancellable>()
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    private var totalQuantities: Int = 0
    private var totalCost: Int = 0
    private var likedProductIds: Set<Int> = [] // [id]
    private var productQuantities: [Int: Int] = [:] // [id: quantities]
    
    private let output = PassthroughSubject<PetShopViewModel.Input, Never>()
    
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
        bind()
        output.send(.viewDidLoad)
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
        output.send(.onResetButtonTap)
    }
    
    private func bind() {
        
        viewModel.transform(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] event in
                switch event {
                case .setProducts(let products):
                    viewModel.onProductLoad?(products)
                    
                case let .updateView(totalQuantities, totalCost, likedProductIds, productQuantities):
                    self.totalQuantities = totalQuantities
                    self.totalCost = totalCost
                    self.likedProductIds = likedProductIds
                    self.productQuantities = productQuantities
                    
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellable)
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
        
        // 順序 step 很重要, 否則將造成 cell 處理異常
        // step 1: 找到對應的 CellController 與 Product
        let cellController = cellController(forRowAt: indexPath)
        let product = cellController.product
        
        // step 2: 根據現有資料產生新的 CellViewModel
        let newQuantity = productQuantities[product.id] ?? 0
        let newIsLiked = likedProductIds.contains(product.id)
        let newCellViewModel = ProductCellViewModel(model: product)
        
        newCellViewModel.quantity = newQuantity
        newCellViewModel.isLiked = newIsLiked
        
        // step 3: 將原本的 CellViewModel 換成新的
        cellController.setViewModel(viewModel: newCellViewModel)
        
        // step 4: 更新 Cell 畫面
        let cell = cellController.view(in: tableView)
        
        cell.eventPublisher
            .sink { [weak self] event in
                self?.output.send(.onProductCellEvent(event: event, product: product))
            }
            .store(in: &cell.cancellable)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cellController(forRowAt: indexPath)
        cell.cancelLoad()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> ProductCellController {
        return tableModel[indexPath.row]
    }
}

extension PetShopViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "Number of product: %d", totalQuantities)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return String(format: "Total cost: $%d", totalCost)
    }
    
}
