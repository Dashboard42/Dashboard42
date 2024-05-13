//
//  HomeView+Avatar.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 12/05/2024.
//

import SwiftUI

extension HomeView {

    struct Avatar: View {

        // MARK: - Properties

        let url: String

        // MARK: - Body

        var body: some View {
            AsyncImage(url: URL(string: url)!) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(maxWidth: 50, maxHeight: 50)
            .clipShape(.rect(cornerRadius: 8))
        }
    }

}

// MARK: - Previews

#Preview {
    HomeView.Avatar(url: UUID().uuidString)
}
