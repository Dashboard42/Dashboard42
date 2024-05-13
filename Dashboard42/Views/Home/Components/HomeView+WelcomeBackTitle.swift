//
//  HomeView+WelcomeBackTitle.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 12/05/2024.
//

import SwiftUI

extension HomeView {

    struct WelcomeBackTitle: View {

        // MARK: - Properties

        let name: String

        // MARK: - Body

        var body: some View {
            VStack(alignment: .leading) {
                Text("Bon retour parmi nous !")
                    .foregroundStyle(.secondary)
                    .font(.body)

                Text("\(name) 👋")
                    .foregroundStyle(.primary)
                    .font(.title2)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}

// MARK: - Previews

#Preview {
    HomeView.WelcomeBackTitle(name: "Marc MOSCA")
}
