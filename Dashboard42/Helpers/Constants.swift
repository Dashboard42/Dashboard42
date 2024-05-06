//
//  Constants.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

enum Constants {

    // MARK: - Api

    /// An enumeration of all the tokens and keys linked to the API.
    enum Api {
        static let CLIENT_ID = getValueOfKeyInApiFile(for: "API_CLIENT_ID")
        static let CLIENT_SECRET = getValueOfKeyInApiFile(for: "API_CLIENT_SECRET")
        static let REDIRECT_URI = getValueOfKeyInApiFile(for: "API_REDIRECT_URI")

        static var APPLICATION_ACCESS_TOKEN: String? {
            get { KeychainManager.shared.get(account: .applicationAccessToken) }
            set { saveTokenInKeychain(newValue: newValue, account: .applicationAccessToken) }
        }

        static var USER_ACCESS_TOKEN: String? {
            get { KeychainManager.shared.get(account: .userAccessToken) }
            set { saveTokenInKeychain(newValue: newValue, account: .userAccessToken) }
        }

        static var USER_REFRESH_TOKEN: String? {
            get { KeychainManager.shared.get(account: .userRefreshToken) }
            set { saveTokenInKeychain(newValue: newValue, account: .userRefreshToken) }
        }
    }

}

// MARK: - Private Helpers

/// Try to retrieve a value from the API configuration file.
/// - Parameter key: The key to find.
/// - Returns: Return the value associated with the key found in the API configuration file.
private func getValueOfKeyInApiFile(for key: String) -> String {
    guard let apiFilePath = Bundle.main.path(forResource: "Api", ofType: "plist") else {
        fatalError("error: couldn't find `Api.plist` file.")
    }

    let plist = NSDictionary(contentsOfFile: apiFilePath)

    guard let value = plist?.object(forKey: key) as? String else {
        fatalError("error: couldn't find \(key) key in Api.plist file.")
    }

    return value
}

/// Saves a value in the keychain.
///
/// If `newValue` is nil, then we delete the value associated with `account`.
///
/// - Parameters:
///   - newValue: The value to be saved.
///   - account: The account associated with the value you wish to save.
private func saveTokenInKeychain(newValue: String?, account: KeychainAccount) {
    if let newValue = newValue {
        try? KeychainManager.shared.save(account: account, data: newValue)
    }
    else {
        try? KeychainManager.shared.delete(account: account)
    }
}
