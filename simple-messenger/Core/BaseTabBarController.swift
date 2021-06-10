//
//  BaseTabBarController.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation
import UIKit

open class BaseTabBarController: UITabBarController {

    public init() {
        super.init(nibName: nil, bundle: nil)
        prepareViewControllers()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Function sets view controllers to this UITabBarController
    open func prepareViewControllers() {
            self.viewControllers = [
                prepareViewController(title: "Chat Rooms", imageName: "message",
                                      viewController: ChatRoomsListVC()),
                prepareViewController(title: "Users", imageName: "person.3",
                                      viewController: UsersListVC()),
                prepareViewController(title: "Account", imageName: "person",
                                      viewController: UserAccountVC())]
    }

    // MARK: - Sets tabBarItem to view controller and creates UINavigtaionController
    open func prepareViewController(title: String?, imageName: String?, viewController: UIViewController) -> UINavigationController {
        viewController.tabBarItem = prepareTabBarItem(title: title, imageName: imageName)
        return UINavigationController(rootViewController: viewController)
    }

    // MARK - Creates bottom tab bar item
    open func prepareTabBarItem(title: String?, imageName: String?) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.title = title
        // MARK - Image is taken from SF Symbols
        tabBarItem.image = UIImage(systemName: imageName ?? "")

        return tabBarItem
    }
}
