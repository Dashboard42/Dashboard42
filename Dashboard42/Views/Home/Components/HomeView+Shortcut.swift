//
//  HomeView+Shortcut.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension HomeView {

    struct Shortcut<T: View>: View {

        // MARK: - Properties

        let image: String
        let destination: T

        // MARK: - Body

        var body: some View {
            NavigationLink(destination: destination) {
                Image(systemName: image)
                    .imageScale(.medium)
                    .font(.headline)
                    .frame(width: 48, height: 48)
                    .background(.thickMaterial)
                    .clipShape(.rect(cornerRadius: 8))
            }
            .foregroundStyle(.secondary)
        }
    }

}

// MARK: - Previews

#Preview {
    HomeView.Shortcut(image: "heart", destination: EmptyView())
}
