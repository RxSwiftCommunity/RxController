//
//  NameViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/04/16.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift

private struct Const {
    struct title {
        static let marginLeft = 10
    }
    
    struct name {
        static let marginTop = 10
    }
    
    struct number {
        static let marginRight = 10
    }
    
    struct update {
        static let width = 150
        static let marginTop = 10
    }
    
    struct firstName {
        static let height = 100
        static let marginTop = 30
    }
    
    struct lastName {
        static let height = 100
        static let marginTop = 30
    }
    
}

class NameViewController: BaseViewController<NameViewModel> {
    
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
    
    private lazy var firstNameView = UIView()
    private lazy var lastNameView = UIView()
    
    private lazy var firstNameViewController = FirstNameViewController(viewModel: .init())
    private lazy var lastNameViewController = LastNameViewController(viewModel: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addChild(firstNameViewController, to: firstNameView)
        addChild(lastNameViewController, to: lastNameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateName()
    }
    
    override func subviews() -> [UIView] {
        return [
            titleLabel,
            nameLabel,
            numberLabel,
            updateButton,
            firstNameView,
            lastNameView
        ]
    }

    override func bind() -> [Disposable] {
        return [
            viewModel.name ~> nameLabel.rx.text,
            viewModel.number ~> numberLabel.rx.text
        ]
    }
    
    override func createConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.title.marginLeft)
            $0.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Const.name.marginTop)
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
        
        firstNameView.snp.makeConstraints {
            $0.height.equalTo(Const.firstName.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(updateButton.snp.bottom).offset(Const.firstName.marginTop)
        }
        
        lastNameView.snp.makeConstraints {
            $0.height.equalTo(Const.lastName.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(firstNameView.snp.bottom).offset(Const.lastName.marginTop)
        }
        
    }
    
}
