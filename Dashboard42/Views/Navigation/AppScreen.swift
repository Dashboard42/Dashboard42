//
//  AppScreen.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

enum AppScreen: Identifiable, CaseIterable {

    // MARK: - Properties

    case home
    case campus
    case search
    case profile
    case settings

    var id: Self { self }

    // MARK: - Label

    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Image(systemName: "house.fill")
        case .campus:
            Image(systemName: "building.2.fill")
        case .search:
            Image(systemName: "magnifyingglass")
        case .profile:
            Image(systemName: "person.fill")
        case .settings:
            Image(systemName: "gear")
        }
    }

    // MARK: - Destination

    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .home:
            Text("Home")
        case .campus:
            Text("Campus")
        case .search:
            Text("Search")
        case .profile:
            Text("Profile")
        case .settings:
            Text("Settings")
        }
    }

}
