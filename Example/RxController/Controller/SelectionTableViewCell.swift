//
//  SelectionTableViewCell.swift
//  RxController_Example
//
//  Created by Meng Li on 2019/06/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import RxDataSourcesSingleSection
import UIKit

private struct Const {
    static let margin = 16
    
    struct Icon {
        static let size = 30
    }
    
    struct Title {
        static let marginRight = 40
    }
}

struct Selection {
    
    let identifier = UUID().uuidString
    var icon: UIImage?
    var title: String
    var subtitle: String?
    var accessory: UITableViewCell.AccessoryType = .none
    
    init(icon: UIImage?, title: String, subtitle: String, accessory: UITableViewCell.AccessoryType) {
        self.init(icon: icon, title: title, subtitle: subtitle)
        self.accessory = accessory
    }
    
    init(icon: UIImage?, title: String, subtitle: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
    
    init(icon: UIImage?, title: String) {
        self.icon = icon
        self.title = title
    }
    
    init(title: String) {
        self.title = title
    }
    
}

extension Selection: Equatable {
    public static func == (lhs: Selection, rhs: Selection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class SelectionTableViewCell: UITableViewCell {
    
    private lazy var iconImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.size.equalTo(Const.Icon.size)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(Const.margin)
            $0.centerY.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.Title.marginRight)
            $0.centerY.equalToSuperview()
        }
    }
    
}

extension SelectionTableViewCell: Configurable {
    
    typealias Model = Selection
    
    func configure(_ selection: Selection) {
        if selection.icon == nil {
            iconImageView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(0)
                $0.width.equalTo(0)
            }
        } else {
            iconImageView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(Const.margin)
                $0.width.equalTo(Const.Icon.size)
            }
        }
        
        iconImageView.image = selection.icon
        titleLabel.text = selection.title
        subtitleLabel.text = selection.subtitle
        accessoryType = selection.accessory
    }
    
}
