//
//  AppScreen.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

/// Represents the different screens or sections of the application.
/// It incorporates SwiftUI features to facilitate navigation and visual representation of each screen using specific icons and navigation destinations.
enum AppScreen: Identifiable, CaseIterable {

    // MARK: - Properties

    /// Represents the application's home screen.
    case home

    /// Represents a screen associated with information relating to the user campus.
    case campus

    /// Represents a screen used to search for user profile of 42Network students.
    case search

    /// Represents the user profile screen where users can view their personal information.
    case profile

    /// Represents settings screen where users can adjust the application's configurations.
    case settings

    /// Each instance of the enumeration returns itself as an identifier, conforming to the Identifiable protocol, which makes it easy to use in lists or collections that require unique elements.
    var id: Self { self }

    // MARK: - Label

    @ViewBuilder
    /// Depending on the enumeration, this view contains a representative icon used to display navigation elements or buttons in the user interface.
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
    /// Encapsulates the navigation logic and makes the destination view directly accessible from the current screen.
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
