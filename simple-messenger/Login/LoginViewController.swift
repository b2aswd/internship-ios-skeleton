//
//  LoginViewController.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class LoginViewController: UIViewController {

    let loginButton = UIButton()
    let usernameInput = BaseTextField()
    let passwordInput = BaseTextField()
    let navyBlueColor = UIColor(red: 44.0 / 255.0, green: 82.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    var buttonBottomConstraint: Constraint!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserService.shared.loggedUser != nil {
            presentViewController()
        }
    }

    // MARK: - This method is called after the view controller has loaded its view hierarchy into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    open func prepareView() {
        view.backgroundColor = .white
        prepareTopImage()
        prepareLoginTitle()
        prepareUserInput()
        preparePasswordInput()
        prepareLoginButton()
        prepareKeyboardHandlers()
    }

    func prepareTopImage() {
        let image = UIImage(named: "b2a-logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 162, height: 32))
        }
    }

    func prepareLoginTitle() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textColor = navyBlueColor
        label.text = "Log in"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(94)
            make.leading.equalToSuperview().offset(24)
        }
    }

    func prepareUserInput() {
        let inputTitle = getInputTitle(text: "Username")
        view.addSubview(inputTitle)
        inputTitle.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(171)
            make.leading.equalToSuperview().offset(24)
        }

        prepareInput(usernameInput, placeholder: "Your username")
        usernameInput.autocapitalizationType = .none
        usernameInput.autocorrectionType = .no
        view.addSubview(usernameInput)
        usernameInput.snp.makeConstraints { make in
            make.top.equalTo(inputTitle.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }

    func preparePasswordInput() {
        let inputTitle = getInputTitle(text: "Password")
        view.addSubview(inputTitle)
        inputTitle.snp.makeConstraints { make in
            make.top.equalTo(self.usernameInput.snp.bottom).offset(16)
            make.leading.equalTo(self.usernameInput)
        }

        prepareInput(passwordInput, placeholder: "Your password")
        passwordInput.isSecureTextEntry = true
        view.addSubview(passwordInput)
        passwordInput.snp.makeConstraints { make in
            make.top.equalTo(inputTitle.snp.bottom).offset(7)
            make.leading.trailing.equalTo(self.usernameInput)
        }
    }

    func prepareLoginButton() {
        loginButton.setTitle("Sign in", for: .normal)
        loginButton.setTitleColor(navyBlueColor, for: .normal)
        loginButton.setTitleColor(navyBlueColor.withAlphaComponent(0.3), for: .disabled)
        loginButton.backgroundColor = .white
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(red: 237.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0).cgColor
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        loginButton.addTarget(self, action: #selector(performLogin), for: .primaryActionTriggered)
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.buttonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
            make.height.equalTo(60)
        }
        loginButton.isEnabled = false
    }

    // MARK: - This is called when is log in button tapped
    @objc open func performLogin() {
        view.endEditing(true)
        sendLoginRequest()
    }

    func sendLoginRequest() {
        // MARK: - Change to your endpoint
        let url = "https://simple-messenger-backend.dev07.b2a.cz/api/v1/user/login"

        let params = ["email": usernameInput.text ?? "", "password": passwordInput.text ?? ""]
        // MARK: - Login Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            // MARK: - Parse response
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any]
                {
                    if json["error"] as? Bool == false {
                        // MARK: - User logged successfully, save user to UserService
                        UserService.shared.saveUser(data: json["data"] as? [String: Any])
                        self.presentViewController()
                    } else {
                        // MARK: - Login error
                        guard let message = json["messages"] as? [String] else {
                            print("Login error \(json)")
                            return
                        }
                        print("Login Error \(message)")
                    }
                }
                break
            case .failure(let error):
                // MARK: - Error, wrong response
                print(error)
            }
        }
    }

    // MARK: - Present BaseTabBar Controller
    func presentViewController() {
        let tabBarController = BaseTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }

    func getInputTitle(text: String?) -> UILabel {
        let inputTitle = UILabel()
        inputTitle.text = text
        inputTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        inputTitle.textColor = navyBlueColor
        return inputTitle
    }

    func prepareInput(_ textField: UITextField, placeholder: String?) {
        textField.placeholder = placeholder
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }

    func prepareKeyboardHandlers() {
        prepareKeyboardNotifications()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardCloseTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    public func prepareKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc public func keyboardCloseTap() {
        // MARK: - Hides keyboard on tap
        view.endEditing(true)
    }

    @objc open func textFieldChanged() {
        // MARK: - Login button is enabled when username and password is filled
        loginButton.isEnabled = usernameInput.text?.isEmpty == false && passwordInput.text?.isEmpty == false
    }

    // MARK: - KeyboardDelegate
    // MARK: - Moves log in button to visible position when keyboard is presented
    @objc open func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height else { return }
        buttonBottomConstraint.update(offset: -keyboardHeight+view.safeAreaInsets.bottom)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc open func keyboardWillHide(_ notification: NSNotification) {
        buttonBottomConstraint.update(offset: 0)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
