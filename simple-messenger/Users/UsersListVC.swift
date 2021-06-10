//
//  ViewController.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import UIKit
import Alamofire

public class UsersListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users: [User] = [] // variable holds all currently loaded users
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)

    // MARK: - Hides navigation bar
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    func prepareView() {
        view.backgroundColor = .white
        prepareTableView()
        getApiData()
    }

    // MARK: - Example of HTTP GET request
    func getApiData() {

        // MARK: - Change to your endpoint
        let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/user"
        // MARK: - Headers
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(UserService.shared.getUserApiKey() ?? "")"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            // MARK: - Parse response
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any]
                {
                    if json["error"] as? Bool == false {
                        // MARK: - Success, your response is in variable json

                        guard let dataUnwrapped = json["data"],
                              let jsonAsData = try? JSONSerialization.data(withJSONObject: dataUnwrapped) else {
                            return
                        }

                        do {
                            self.users = try JSONDecoder().decode([User].self, from: jsonAsData)
                            self.tableView.reloadData()
                        } catch {
                            print("Failed to parse object")
                        }

                    } else {
                        // MARK: - Response error
                        guard let message = json["messages"] as? [String] else {
                            print("Error \(json)")
                            return
                        }
                        print("Error \(message)")
                    }
                }
            case .failure(let error):
                // MARK: - Error, wrong response
                print(error)
            }
        }
    }

    func prepareTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView.register(UsersListTVCell.self, forCellReuseIdentifier: UsersListTVCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
    }

    // MARK: - UITableViewDelegate
    // MARK: - Function counts how many cells will be displayed
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    // MARK: - Function creates instance of UITableViewCell for every displayed row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: UsersListTVCell.reuseIdentifier) as? UsersListTVCell ?? UsersListTVCell()
        if users.count > indexPath.row {
            cell.data = users[indexPath.row]
        }
        return cell
    }

    // MARK: - Function is called when row is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIViewController()
        if users.count > indexPath.row {
            detailViewController.title = "\(users[indexPath.row].name) \(users[indexPath.row].surname)"
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

