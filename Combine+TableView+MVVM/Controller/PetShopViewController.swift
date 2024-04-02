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
    
    private let cellEventSubject = PassthroughSubject<ProductCellEvent, Never>()
    
    private var result: (totalCount: Int, totalCost: Int) = (0,0)
    
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
        viewDidLoadSubject.send(())
        
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
    
    private func bind() {
        let input = PetShopViewModel.Input(productsPublisher: viewDidLoadSubject.eraseToAnyPublisher(),
                                           cellEventPublisher: cellEventSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.setProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] products in
                self.tableModel = products.map({ product in
                    let vm = ProductCellViewModel(model: product)
                    let vc = ProductCellController(viewModel: vm)
                    return vc
                })
                
            }.store(in: &cancellable)
        
        output.reloadTableView
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] () in
                self.tableView.reloadData()
            }.store(in: &cancellable)
        
        viewModel.$cart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] productDic in
                let totalCount = productDic.reduce(0.0, { $0 + $1.value })
                let totalCost = productDic.reduce(0.0, { $0 + ($1.value * Double($1.key.price)) })
                self?.result = (totalCount: Int(totalCount), totalCost: Int(totalCost))
            
                // Mark: cause problem
//                self?.tableView.reloadData()
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
        
        let controller = cellController(forRowAt: indexPath)
        controller.eventPublisher
            .sink { [weak self] event in
                self?.cellEventSubject.send(event)
            }
            .store(in: &cancellable)
        
        return controller.view(in: tableView)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> ProductCellController {
        return tableModel[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "Number of product: %d", result.totalCount)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return String(format: "Total cost: $%d", result.totalCost)
    }
    
}

