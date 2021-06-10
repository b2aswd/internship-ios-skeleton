//
//  UserAccountVC.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation
import UIKit

open class UserAccountVC: UIViewController {

    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let logOutButton = UIButton()

    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareLogOutButton()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // MARK: - Set name of currently logged user to nameLabel
        nameLabel.text = UserService.shared.getFullName()
    }

    // MARK: - Hides navigation bar
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    open func prepareView() {
        self.view.backgroundColor = .white
        prepareIconImageView()
        prepareNameLabel()
        prepareLogOutButton()
    }

    // MARK: - Creates users icon
    open func prepareIconImageView() {
        view.addSubview(iconImageView)
        iconImageView.image = UIImage(systemName: "person.crop.circle.fill")
        iconImageView.tintColor = UIColor.black.withAlphaComponent(0.8)
        iconImageView.contentMode = .scaleToFill
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }

    // MARK: - Creates name label
    open func prepareNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 30)
    }

    open func prepareLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = .systemBlue
        logOutButton.layer.cornerRadius = 10
        logOutButton.addTarget(self, action: #selector(logOut), for: .primaryActionTriggered)
    }

    @objc open func logOut() {
        self.dismiss(animated: true, completion: nil)
        UserService.shared.logOut()
    }
}
