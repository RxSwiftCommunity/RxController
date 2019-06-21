//
//  MenuViewController.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxController
import RxDataSourcesSingleSection

class MenuViewController: RxViewController<MenuViewModel> {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 44
        tableView.register(cellType: SelectionTableViewCell.self)
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] in
            self.viewModel.pick(at: $0.row)
        }).disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var dataSource = SelectionTableViewCell.tableViewSingleSectionDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.selectionSection ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    private func createConstraints() {
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
}
