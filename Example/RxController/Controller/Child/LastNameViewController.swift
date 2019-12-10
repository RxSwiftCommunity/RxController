//
//  LastNameViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/03.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxController

class LastNameViewController: RxViewController<LastNameViewModel> {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "LastNameChildViewController"
        label.textColor = .cyan
        return label
    }()
    
    private lazy var firstNameLabel = UILabel()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Name", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.rx.tap.bind { [unowned self] in
            self.viewModel.updateLastName()
        }.disposed(by: disposeBag)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(firstNameLabel)
        view.addSubview(lastNameLabel)
        view.addSubview(updateButton)
        createConstraints()
        
        disposeBag ~ [
            viewModel.firstName ~> firstNameLabel.rx.text,
            viewModel.lastName ~> lastNameLabel.rx.text
        ]
    }
    
    private func createConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview()
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        lastNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(firstNameLabel)
            $0.left.equalTo(firstNameLabel.snp.right).offset(10)
        }
        
        updateButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(firstNameLabel.snp.bottom).offset(10)
            $0.width.equalTo(150)
        }
        
    }
    
}
