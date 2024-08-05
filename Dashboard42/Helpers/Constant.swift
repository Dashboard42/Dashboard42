//
//  Constant.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

enum Constant {

    static var clientId: String {
        do {
            return try Configuration.value(for: "API_CLIENT_ID")
        }
        catch {
            fatalError("Cannot find `API_CLIENT_ID` in configuration file.")
        }
    }

    static var clientSecret: String {
        do {
            return try Configuration.value(for: "API_CLIENT_SECRET")
        }
        catch {
            fatalError("Cannot find `API_CLIENT_SECRET` in configuration file.")
        }
    }

    static var redirectUri: String {
        do {
            return try Configuration.value(for: "API_REDIRECT_URI")
        }
        catch {
            fatalError("Cannot find `API_REDIRECT_URI` in configuration file.")
        }
    }

}
