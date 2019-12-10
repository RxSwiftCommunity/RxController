//
//  InfoViewController.swift
//  RxController
//
//  Created by Meng Li on 04/01/2019.
//  Copyright (c) 2019 XFLAG. All rights reserved.
//

import UIKit
import RxController
import SnapKit

private struct Const {
    
    struct name {
        static let marginLeft = 10
        static let marginTop = 100
    }
    
    struct number {
        static let marginRight = 10
    }
    
    struct update {
        static let width = 150
        static let marginTop = 10
    }
    
    struct nameContainer {
        static let height = 360
        static let marginTop = 30
    }
    
    struct numbeContainer {
        static let height = 100
        static let marginTop = 30
    }
    
}

class InfoViewController: RxViewController<InfoViewModel> {
    
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
        button.rx.tap.bind { [unowned self] in
            self.viewModel.updateAll()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var nameContainerView = UIView()
    private lazy var numberContainer = UIView()
    
    private lazy var nameViewController = NameViewController(viewModel: .init())
    private lazy var numberViewController = NumberViewController(viewModel: .init())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(nameLabel)
        view.addSubview(numberLabel)
        view.addSubview(updateButton)
        view.addSubview(nameContainerView)
        view.addSubview(numberContainer)
        
        addChild(nameViewController, to: nameContainerView)
        addChild(numberViewController, to: numberContainer)
        
        createConstraints()
        
        disposeBag ~ [
            viewModel.name ~> nameLabel.rx.text,
            viewModel.number ~> numberLabel.rx.text
        ]
    }
    
    private func createConstraints() {
        
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.name.marginLeft)
            $0.top.equalToSuperview().offset(Const.name.marginTop)
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.right.equalToSuperview().offset(-Const.number.marginRight)
        }
        
        updateButton.snp.makeConstraints {
            $0.width.equalTo(Const.update.width)
            $0.top.equalTo(numberLabel.snp.bottom).offset(Const.update.marginTop)
            $0.right.equalTo(numberLabel)
        }
        
        nameContainerView.snp.makeConstraints {
            $0.height.equalTo(Const.nameContainer.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(updateButton.snp.bottom).offset(Const.nameContainer.marginTop)
        }
        
        numberContainer.snp.makeConstraints {
            $0.height.equalTo(Const.numbeContainer.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(nameContainerView.snp.bottom).offset(Const.numbeContainer.marginTop)
        }

    }
    
}
