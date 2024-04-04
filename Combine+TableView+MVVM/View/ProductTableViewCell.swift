//
//  PetTableViewCell.swift
//  Combine+TableView+MVVM
//
//  Created by WEI-TSUNG CHENG on 2024/3/23.
//

import UIKit
import SnapKit
import Combine

enum ProductCellEvent {
    case quantityDidChange(value: Int)
    case heartDidTap
}

final class ProductTableViewCell: UITableViewCell {
    
    var horizontalStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .fill
        stv.distribution = .fill
        stv.spacing = 16
        return stv
    }()
    
    var quantityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.backgroundColor = .black
        lbl.clipsToBounds = true
        
        return lbl
    }()
    
    var productStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .fill
        stv.distribution = .fill
        stv.spacing = 8
        return stv
    }()
    
    var productImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(systemName: "photo")
        return imv
    }()
    
    var productInfoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "name"
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    var stepperContainerView: UIView = {
        let v = UIView()
        return v
    }()
    
    var stepper: UIStepper = {
        let stp = UIStepper()
        stp.value = 0.0
        stp.minimumValue = 0.0
        return stp
    }()
    
    var heartButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .red
        return btn
    }()
   
    private let eventSubject = PassthroughSubject<ProductCellEvent, Never>()
    var eventPublisher: AnyPublisher<ProductCellEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        setupUI()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var cancellable = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable = Set<AnyCancellable>()
    }
    
    func setupUI() {
        
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        horizontalStackView.addArrangedSubview(quantityLabel)
        horizontalStackView.addArrangedSubview(productStackView)
        horizontalStackView.addArrangedSubview(stepperContainerView)
        horizontalStackView.addArrangedSubview(heartButton)
        
        quantityLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        stepperContainerView.snp.makeConstraints { make in
            make.width.equalTo(65)
        }
        
        heartButton.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        productStackView.addArrangedSubview(productImageView)
        productStackView.addArrangedSubview(productInfoLabel)
        
        productStackView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        stepperContainerView.addSubview(stepper)
        stepper.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setAction() {
        stepper.addTarget(self, action: #selector(tapStepper), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc private func tapStepper(_ sender: UIStepper) {
        let value = Int(sender.value)
        eventSubject.send(.quantityDidChange(value: value))
    }
    
    @objc private func tapButton(_ sender: UIButton) {
        eventSubject.send(.heartDidTap)
    }
    
}
