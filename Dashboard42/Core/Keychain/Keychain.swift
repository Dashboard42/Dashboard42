//
//  Keychain.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

/// Defines a standardised interface for interacting with the keychain in an application.
/// It specifies the methods needed to store, retrieve, delete and erase authentication data, such as access and refresh tokens.
protocol Keychain {
    
    /// Store data, typically access tokens or refresh tokens, in the device's keychain.
    /// It encodes the data in UTF-8 and uses Apple's keychain APIs to secure the information.
    /// - Parameters:
    ///   - account: The account under which the data is to be saved. This determines the `kSecAttrAccount` attribute for the keychain request.
    ///   - data: The character string to be registered. Typically, this will be an access or refresh token.
    func save(account: KeychainAccount, data: String) throws
    
    /// Retrieves data stored under a specific account in the device's keychain.
    /// It uses Apple's keychain APIs to securely access the information.
    /// - Parameter account: The specified account for which data is to be retrieved.
    /// - Returns: Returns the data as a character string if found and correctly decoded, otherwise returns `nil`.
    func get(account: KeychainAccount) -> String?
    
    /// Deletes data associated with a specific account from the device's keychain.
    /// It uses Apple's keychain APIs to perform the deletion securely.
    /// - Parameter account: The specified account for which data is to be deleted from the keychain.
    func delete(account: KeychainAccount) throws
    
    /// Deletes all authentication data stored in the device's keychain.
    /// It calls the `delete` method for each account type defined in the `KeychainAccount` enumeration, ensuring that all access and refresh tokens are deleted.
    func clear()

}

/// Defines the different accounts under which data can be stored in the keychain.
enum KeychainAccount: String {
    /// Used to store the application's access token.
    case applicationAccessToken
    
    /// Used to store the user's access token.
    case userAccessToken
    
    /// Used to store the user's refresh token.
    case userRefreshToken
}
