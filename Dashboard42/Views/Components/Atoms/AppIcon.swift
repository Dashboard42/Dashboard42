//
//  AppIcon.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 31/07/2024.
//

import SwiftUI

/// A view that displays the application icon.
struct AppIcon: View {

    /// Creates the application icon image.
    init() {}

    private var appIcon: String {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let iconFileName = iconFiles.last
        else {
            fatalError("Could not find icons in bundle")
        }
        return iconFileName
    }

    var body: some View {
        Image(uiImage: UIImage(imageLiteralResourceName: appIcon))
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    AppIcon()
}
