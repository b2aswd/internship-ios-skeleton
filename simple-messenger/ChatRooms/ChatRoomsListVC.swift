//
//  ChatRoomListVC.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation
import UIKit

public class ChatRoomsListVC: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

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
        // MARK: - Its your turn
    }
}
