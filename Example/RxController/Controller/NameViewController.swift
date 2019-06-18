//
//  NameViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 MuShare. All rights reserved.
//

import UIKit
import RxController

class NameViewController: RxViewController<NameViewModel> {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NameMidChildViewController"
        label.textColor = .blue
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Name", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.rx.tap.bind { [unowned self] in
            self.viewModel.updateName()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var firstNameViewController = FirstNameViewController(viewModel: viewModel.firstNameViewModel)
    
    private lazy var lastNameViewController = LastNameViewController(viewModel: viewModel.lastNameViewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(numberLabel)
        view.addSubview(updateButton)
        createConstraints()

        addRxChild(firstNameViewController) {
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(100)
                $0.top.equalTo(self.updateButton.snp.bottom).offset(30)
            }
        }
        
        addRxChild(lastNameViewController) {
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(100)
                $0.top.equalTo(self.firstNameViewController.view.snp.bottom).offset(30)
            }
        }
        
        viewModel.name ~> nameLabel.rx.text ~ disposeBag
        viewModel.number ~> numberLabel.rx.text ~ disposeBag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateName()
    }
    
    private func createConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.right.equalToSuperview().offset(-10)
        }
        
        updateButton.snp.makeConstraints {
            $0.right.equalTo(numberLabel)
            $0.top.equalTo(numberLabel.snp.bottom).offset(10)
            $0.width.equalTo(150)
        }
        
    }
    
}
