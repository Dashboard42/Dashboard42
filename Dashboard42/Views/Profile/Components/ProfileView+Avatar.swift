//
//  ProfileView+Avatar.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension ProfileView {

    struct Avatar: View {

        // MARK: - Properties

        let url: String
        let isAvailable: Bool

        // MARK: - Body

        var body: some View {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .clipShape(.circle)
            .padding(3)
            .overlay {
                Circle()
                    .fill(.clear)
                    .stroke(isAvailable ? .green.opacity(0.7) : .gray.opacity(0.5), lineWidth: 2)
            }
            .frame(width: 100, height: 100)
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.Avatar(url: "", isAvailable: true)
}
