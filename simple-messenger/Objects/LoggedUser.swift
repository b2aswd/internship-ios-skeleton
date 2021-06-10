//
//  LoggedUser.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 09.06.2021.
//

import Foundation

public struct LoggedUser: Codable {
    var id: Int
    var name: String
    var surname: String
    var apiKey: String
}
