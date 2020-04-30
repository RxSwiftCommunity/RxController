//
//  ProfileViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift

private struct Const {
    
    struct name {
        static let marginTop = 130
    }
    
    struct friends {
        static let marginTop = 30
    }

}

class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    private lazy var nameLabel = UILabel()
    
    private lazy var friendsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Friends", for: .normal)
        button.backgroundColor = .darkGray
        button.rx.tap.bind { [unowned self] in
            self.viewModel.showFriends()
        }.disposed(by: disposeBag)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func subviews() -> [UIView] {
        return [
            nameLabel,
            friendsButton
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.name ~> nameLabel.rx.text
        ]
    }
    
    override func createConstraints() {
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Const.name.marginTop)
        }
        
        friendsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(Const.friends.marginTop)
        }
        
    }
    
}
