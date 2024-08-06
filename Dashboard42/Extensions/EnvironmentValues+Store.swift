//
//  EnvironmentValues+Store.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/08/2024.
//

import SwiftUI

private struct StoreKey: EnvironmentKey {
    static var defaultValue = Store(network: Network())
}

extension EnvironmentValues {
    var store: Store {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }
}
