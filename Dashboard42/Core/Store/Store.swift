//
//  Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import Foundation
import Observation

@Observable
final class Store {

    // MARK: - Properties

    var selection = AppScreen.home

    var error: Api.Errors?
    var errorAction: (() -> Void)?
    var errorIsPresented: Bool { error != nil }

}
