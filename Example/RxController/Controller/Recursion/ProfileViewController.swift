//
//  ProfileViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

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
        view.addSubview(nameLabel)
        view.addSubview(friendsButton)
        createConstraints()
        
        disposeBag ~ [
            viewModel.name ~> nameLabel.rx.text
        ]
    }
    
    private func createConstraints() {
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(130)
        }
        
        friendsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(30)
        }
        
    }
    
}
