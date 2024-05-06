//
//  Constants.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation

enum Constants {

    // MARK: - Api

    ///
    enum Api {
        static let CLIENT_ID = getValueOfKeyInApiFile(for: "API_CLIENT_ID")
        static let CLIENT_SECRET = getValueOfKeyInApiFile(for: "API_CLIENT_SECRET")
        static let REDIRECT_URI = getValueOfKeyInApiFile(for: "API_REDIRECT_URI")
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
