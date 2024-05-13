//
//  Constants.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

/// Container for static constants and configurations used in the application.
/// It is structured into sub-enumerations to organise the constants linked to the application's APIs and local storage.
enum Constants {

    /// Groups together constants and properties related to API configuration, including client identifiers, secrets, redirection URIs and access token managers.
    enum Api {
        static let clientId = getValueOfKeyInApiFile(for: "API_CLIENT_ID")
        static let clientSecret = getValueOfKeyInApiFile(for: "API_CLIENT_SECRET")
        static let redirectUri = getValueOfKeyInApiFile(for: "API_REDIRECT_URI")

        static var applicationAccessToken: String? {
            get { KeychainManager.shared.get(account: .applicationAccessToken) }
            set { saveTokenInKeychain(newValue: newValue, account: .applicationAccessToken) }
        }

        static var userAccessToken: String? {
            get { KeychainManager.shared.get(account: .userAccessToken) }
            set { saveTokenInKeychain(newValue: newValue, account: .userAccessToken) }
        }

        static var userRefreshToken: String? {
            get { KeychainManager.shared.get(account: .userRefreshToken) }
            set { saveTokenInKeychain(newValue: newValue, account: .userRefreshToken) }
        }
    }

    /// Contains the keys used to store application data in `UserDefaults` or other persistent storage mechanisms.
    enum AppStorage {
        static let userIsConnected: String = "APPSTORAGE_USER_IS_CONNECTED"
    }

}

// MARK: - Private Helpers

/// Extracts specific values from an Api.plist configuration file located in the main application bundle.
/// Is used to retrieve secure configurations and other critical constants required for API operations.
/// - Parameter key: The key for which the value is to be retrieved from the Api.plist file.
/// - Returns: The character string associated with the key specified in the Api.plist file.
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

/// Saves or deletes access tokens and refresh tokens in the application's keychain.
/// Supports conditional management of tokens based on the presence or absence of a value.
/// - Parameters:
///   - newValue: The new value of the token to be saved. If `nil`, the function will delete the existing token associated with the account specified in the keyring.
///   - account: The specific keychain account under which the token is to be saved or deleted.
private func saveTokenInKeychain(newValue: String?, account: KeychainAccount) {
    if let newValue = newValue {
        try? KeychainManager.shared.save(account: account, data: newValue)
    }
    else {
        try? KeychainManager.shared.delete(account: account)
    }
}
