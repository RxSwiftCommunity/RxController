//
//  NumberViewController.swift
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
    
    struct number {
        static let marginTop = 10
    }
    
    struct update {
        static let width = 150
        static let marginTop = 10
        static let marginRight = 10
    }
    
}

class NumberViewController: BaseViewController<NumberViewModel> {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NumberChildViewController"
        label.textColor = .blue
        return label
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .red
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Number", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.rx.tap.bind { [unowned self] in
            self.viewModel.updateNumber()
        }.disposed(by: disposeBag)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateNumber()
    }
    
    override func subviews() -> [UIView] {
        return [
            titleLabel,
            numberLabel,
            updateButton
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.number ~> numberLabel.rx.text
        ]
    }
    
    override func createConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.title.marginLeft)
            $0.top.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Const.number.marginTop)
        }
        
        updateButton.snp.makeConstraints {
            $0.width.equalTo(Const.update.width)
            $0.top.equalTo(numberLabel.snp.bottom).offset(Const.update.marginTop)
            $0.right.equalToSuperview().offset(-Const.update.marginRight)
        }
        
    }
    
}
