//
//  Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import Foundation

@Observable final class Store {

    let errors: Dashboard42Errors? = nil
    let authService: AuthService = AuthService()

}
