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
    
    struct nameTitle {
        static let marginLeft = 10
        static let marginTop = 100
    }
    
    struct numberTitle {
        static let marginRight = 10
    }
    
    struct update {
        static let width = 150
        static let marginTop = 10
    }
    
    struct name{
        static let height = 360
        static let marginTop = 30
    }
    
    struct number {
        static let height = 100
        static let marginTop = 30
    }
    
}

class InfoViewController: RxViewController<InfoViewModel> {
    
    private lazy var nameTitleLabel = UILabel()
    
    private lazy var numberTitleLabel: UILabel = {
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
    
    private lazy var nameView = UIView()
    private lazy var numberView = UIView()
    
    private lazy var nameViewController = NameViewController(viewModel: .init())
    private lazy var numberViewController = NumberViewController(viewModel: .init())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(nameTitleLabel)
        view.addSubview(numberTitleLabel)
        view.addSubview(updateButton)
        view.addSubview(nameView)
        view.addSubview(numberView)
        
        addChild(nameViewController, to: nameView)
        addChild(numberViewController, to: numberView)
        
        createConstraints()
        
        disposeBag ~ [
            viewModel.name ~> nameTitleLabel.rx.text,
            viewModel.number ~> numberTitleLabel.rx.text
        ]
    }
    
    private func createConstraints() {
        
        nameTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.nameTitle.marginLeft)
            $0.top.equalToSuperview().offset(Const.nameTitle.marginTop)
        }
        
        numberTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameTitleLabel)
            $0.right.equalToSuperview().offset(-Const.numberTitle.marginRight)
        }
        
        updateButton.snp.makeConstraints {
            $0.width.equalTo(Const.update.width)
            $0.top.equalTo(numberTitleLabel.snp.bottom).offset(Const.update.marginTop)
            $0.right.equalTo(numberTitleLabel)
        }
        
        nameView.snp.makeConstraints {
            $0.height.equalTo(Const.name.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(updateButton.snp.bottom).offset(Const.name.marginTop)
        }
        
        numberView.snp.makeConstraints {
            $0.height.equalTo(Const.number.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(nameView.snp.bottom).offset(Const.number.marginTop)
        }

    }
    
}
