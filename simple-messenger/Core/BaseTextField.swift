//
//  BaseTextField.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import Foundation
import UIKit

class BaseTextField: UITextField {

    var textOffset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
    var borderColorActive =  UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    var borderColorNormal = UIColor(red: 237.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0) {
        didSet {
            layer.borderColor = borderColorNormal.cgColor
        }
    }

    override var isEditing: Bool {
        let result = super.isEditing
        layer.borderColor = (result ? borderColorActive : borderColorNormal).cgColor
        return result
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = borderColorNormal.cgColor
        layer.cornerRadius = 5
        layer.shadowColor = UIColor(red: 44.0 / 255.0, green: 60.0 / 255.0, blue: 94.0 / 255.0, alpha: 0.05).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textColor = UIColor(red: 44.0 / 255.0, green: 82.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: textOffset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
