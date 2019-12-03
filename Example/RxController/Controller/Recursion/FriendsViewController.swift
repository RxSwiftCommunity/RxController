//
//  FriendsViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 12/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

class FriendsViewController: BaseViewController<FriendsViewModel> {
 
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: SelectionTableViewCell.self)
        tableView.rx.itemSelected.bind { [unowned self] in
            self.viewModel.pick(at: $0.row)
        }.disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var dataSource = SelectionTableViewCell.tableViewSingleSectionDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.friendSection ~> tableView.rx.items(dataSource: dataSource)
        ]
        
    }
    
    private func createConstraints() {
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top)
        }
    }
    
}
