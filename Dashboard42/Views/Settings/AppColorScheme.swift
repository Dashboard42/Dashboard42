//
//  AppColorScheme.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

enum AppColorScheme: Int, Identifiable, CaseIterable {
    case system
    case light
    case dark

    var id: Int { rawValue }

    var title: LocalizedStringResource {
        switch self
        {
        case .system:
            return "Système"
        case .light:
            return "Clair"
        case .dark:
            return "Sombre"
        }
    }

    static func transformToColorScheme(colorScheme: Int) -> ColorScheme? {
        guard let colorScheme = AppColorScheme(rawValue: colorScheme) else { return nil }

        switch colorScheme
        {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
