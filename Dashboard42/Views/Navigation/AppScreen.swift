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

    case home
    case campus
    case search
    case profile
    case settings

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
    var destination: some View {
        switch self {
        case .home:
            HomeView()
        case .campus:
            CampusView()
        case .search:
            Text("Search")
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        }
    }

}
