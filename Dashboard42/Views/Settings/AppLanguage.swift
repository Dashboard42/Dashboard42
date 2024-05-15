//
//  AppLanguage.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import Foundation

enum AppLanguages: String, Identifiable, CaseIterable {
    case en
    case fr

    var id: String { rawValue }

    var title: String {
        switch self
        {
        case .en:
            return "English"
        case .fr:
            return "Français"
        }
    }
}
