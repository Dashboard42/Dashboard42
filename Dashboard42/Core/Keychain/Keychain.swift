//
//  Keychain.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

/// A type that can interact with the user's keychain.
protocol Keychain {

    /// Saves a value in the user's access keychain.
    /// - Parameters:
    ///   - account: The account (key) associated with the value you wish to store.
    ///   - data: The value to be stored.
    func save(account: KeychainAccount, data: String) throws

    /// Retrieve the value corresponding to an account in the user's keychain.
    /// - Parameter account: The account (key) associated with the value you wish to fetch.
    /// - Returns: The value corresponding to the account passed in parameter. Nil if no value is found.
    func get(account: KeychainAccount) -> String?

    /// Delete a value from the user's keychain.
    /// - Parameter account: The account (key) associated with the value you wish to delete.
    func delete(account: KeychainAccount) throws

    /// Deletes all the values stored in the keychain associated with the API.
    func clear()

}

/// An object containing the various keys used to identify the values stored in the user's access keychain.
enum KeychainAccount: String {
    case applicationAccessToken
    case userAccessToken
    case userRefreshToken
}
