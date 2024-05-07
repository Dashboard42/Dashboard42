//
//  EnvironmentValues+Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

/// Used as a key in a SwiftUI environment, allowing a `Store` instance to be stored and retrieved.
/// It implements SwiftUI's `EnvironmentKey` protocol, allowing custom values to be associated with the application environment.
private struct StoreKey: EnvironmentKey {
    /// The default value associated with this key in the environment.
    /// When store is first accessed in the environment and no value has been explicitly assigned, `defaultValue` is used to initialise the property.
    static var defaultValue = Store()
}

extension EnvironmentValues {
    /// The extension on `EnvironmentValues` adds a store computed property to `EnvironmentValues`, allowing easy access to a `Store` instance through the SwiftUI environment.
    var store: Store {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}
