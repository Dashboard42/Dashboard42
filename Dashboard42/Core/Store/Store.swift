//
//  Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation
import Observation

@Observable
/// Centralised container for managing the state of the application.
final class Store {

    // MARK: - Properties

    /// Represents the screen currently selected in the application.
    /// The initial value is `AppScreen.home`, indicating that the home screen is the default screen when the application is opened.
    var selection = AppScreen.home

    /// Contains the current connected user informations.
    var user: Api.User?

    // MARK: Errors

    /// Contains any errors encountered in the application.
    /// It can be any of the errors defined in the `Api.Errors` enumeration, allowing errors to be managed centrally.
    var error: Api.Errors?

    /// An optional closure that is executed in response to an error.
    var errorAction: (() -> Void)?

    // MARK: Services

    /// An instance of `AuthService` used to manage authentication processes in the application, such as user login.
    let authService = AuthService()

    /// An instance of `UserService` used to manage user.
    let userService = UserService()

}
