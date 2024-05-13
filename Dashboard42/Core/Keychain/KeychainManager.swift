//
//  KeychainManager.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

/// Implements the Keychain protocol to provide secure management of sensitive data such as access tokens and refresh tokens, using the iOS keychain.
/// It enables authentication information to be stored, retrieved, deleted and cleaned.
final class KeychainManager: Keychain {

    // MARK: - Properties

    /// A singleton instance of `KeychainManager`, allowing single global access to keychain management.
    static let shared = KeychainManager()

    private let service = "DASHBOARD42_API_KEYCHAIN_SERVICE"

    // MARK: - Initializers

    private init() {}

    // MARK: - Errors

    /// Defines the potential errors that `KeychainManager` may encounter, allowing better error control and more accurate exception handling.
    enum Errors: Error {
        case unknown(OSStatus)
    }

    // MARK: - Methods

    func save(account: KeychainAccount, data: String) throws {
        let encodedData = data.data(using: .utf8) ?? .init()
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecValueData as String: encodedData as AnyObject,
        ]
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            try delete(account: account)
            return try save(account: account, data: data)
        }

        guard status == errSecSuccess else { throw Errors.unknown(status) }
    }

    func get(account: KeychainAccount) -> String? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let _ = SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data else { return nil }

        return String(decoding: data, as: UTF8.self)
    }

    func delete(account: KeychainAccount) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
        ]
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else { throw Errors.unknown(status) }
    }

    func clear() {
        try? delete(account: .applicationAccessToken)
        try? delete(account: .userAccessToken)
        try? delete(account: .userRefreshToken)
    }

}
