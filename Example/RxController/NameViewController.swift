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
    
    private lazy var nameLabel = UILabel()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update All", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(nameLabel)
        view.addSubview(numberLabel)
        view.addSubview(updateButton)
        createConstraints()
        
        nameLabel.text = "Alice"
        numberLabel.text = "1234567890"
    }
    
    private func createConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
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
