//
//  UserListTVCell.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation
import UIKit

public class UsersListTVCell: UITableViewCell {

    open class var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    var titleLabel = UILabel()

    open var data: Any? {
        didSet {
            if data != nil{
                updateView()
            }
        }
    }

    override public init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func prepareView() {
        prepareTitleLabel()
    }

    open func updateView() {
        guard let dataUnwrapped = data as? User else {
            return
        }
        titleLabel.text = "\(dataUnwrapped.name) \(dataUnwrapped.surname)"
    }

    open func prepareTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.bottom.equalToSuperview()
        }
    }

}
