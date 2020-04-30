//
//  LastNameViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/03.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift

private struct Const {
    
    struct title {
        static let marginLeft = 30
    }
    
    struct firstName {
        static let marginTop = 10
    }
    
    struct lastNameLabel {
        static let marginTop = 10
    }
    
    struct update {
        static let width = 150
        static let marginTop = 10
        static let marginRight = 10
    }
    
}

class LastNameViewController: BaseViewController<LastNameViewModel> {
    
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
    }
    
    override func subviews() -> [UIView] {
        return [
            titleLabel,
            firstNameLabel,
            lastNameLabel,
            updateButton
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.firstName ~> firstNameLabel.rx.text,
            viewModel.lastName ~> lastNameLabel.rx.text
        ]
    }
    
    override func createConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.title.marginLeft)
            $0.top.equalToSuperview()
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Const.firstName.marginTop)
        }
        
        lastNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(firstNameLabel)
            $0.left.equalTo(firstNameLabel.snp.right).offset(Const.lastNameLabel.marginTop)
        }
        
        updateButton.snp.makeConstraints {
            $0.width.equalTo(Const.update.width)
            $0.top.equalTo(firstNameLabel.snp.bottom).offset(Const.update.marginTop)
            $0.right.equalToSuperview().offset(-Const.update.marginRight)
        }
        
    }
    
}
