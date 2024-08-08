//
//  Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

@Observable final class Store: Sendable {

    private let network: Network

    let errors: Dashboard42Errors?
    let authService: AuthService

    init(network: Network) {
        self.network = network

        self.errors = nil
        self.authService = AuthService(network: self.network)
    }
}
