//
//  UserService.swift
//  simple-messenger
//
//  Created by Pavel Odstrčilík on 08.06.2021.
//

import Foundation

public class UserService {

    public static let shared = UserService()
    public var loggedUser: LoggedUser?
    internal var defaults = UserDefaults.standard

    private init() {}

    // MARK: - Function parses data from [String:Any] to LoggedUser Struct
    public func saveUser(data: [String:Any]?) {
        guard let dataUnwrapped = data,
              let jsonAsData = try? JSONSerialization.data(withJSONObject: dataUnwrapped) else {
            return
        }

        do {
            let user = try JSONDecoder().decode(LoggedUser.self, from: jsonAsData)
            loggedUser = user
            saveUserToDefaults()
        } catch {
            print("Failed to parse object")
        }
    }

    // MARK: - Function sets logged user to User Defaults
    public func saveUserToDefaults() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(loggedUser)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                defaults.set(jsonString, forKey: "user")
                defaults.synchronize()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Function gets user from User Defaults and saves it to variable loggedUser
    public func initUserFromDefaults() {
        guard let json = defaults.object(forKey: "user") as? String else { return }
        do {
            let user = try JSONDecoder().decode(LoggedUser.self, from: Data(json.utf8))
            loggedUser = user
        } catch {
            print("Failed to parse object")
        }
    }

    public func getUserApiKey() -> String? {
        return loggedUser?.apiKey
    }

    public func getFullName() -> String? {
        guard let loggedUserUnwrapped = loggedUser else {
            return nil
        }
        return "\(loggedUserUnwrapped.name) \(loggedUserUnwrapped.surname)"
    }

    // MARK: - Removes user from User Default and from variable loggedUser
    public func logOut() {
        loggedUser = nil
        defaults.removeObject(forKey: "user")
        defaults.synchronize()
    }
}
