//
//  OrderViewController.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/4/5.
//

import UIKit
import Combine
import SnapKit

final class OrderViewController: UIViewController {

    lazy var detailTextView: UITextView = {
        let txv = UITextView()
        txv.textColor = .black
        txv.textAlignment = .center
        txv.backgroundColor = .clear
        txv.isEditable = false
        return txv
    }()
    
    lazy var oKButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemRed
        btn.setTitle("Ok", for: .normal)
        btn.layer.cornerRadius = 8
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private let output = PassthroughSubject<OrderViewModel.Input, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    var viewModel: OrderViewModel
    init(viewModel: OrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        bind()
        output.send(.viewDidLoad)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray4
        view.addSubview(detailTextView)
        view.addSubview(oKButton)
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.leading.equalTo(view.snp.leadingMargin).offset(10)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-10)
            make.bottom.equalTo(oKButton.snp.top).offset(-10)
        }
        
        oKButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-10)
        }
        
    }
    
    private func setAction() {
        oKButton.addTarget(self, action: #selector(leave), for: .touchUpInside)
    }
    
    @objc func leave() {
        viewModel.leaveOrderPage?()
    }

    private func bind() {
        viewModel.transform(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] output in
                switch output {
                case .updateView(totalQuantities: let quantities, totalCost: let cost):
                    
                    detailTextView.text = """
                    Total Quantities: \(quantities)
                    Total Cost: \(cost)
                    """
                }
            }
            .store(in: &cancellable)
        
    }
}
