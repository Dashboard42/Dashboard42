//
//  OnBoardingView+Paragraph.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

extension OnBoardingView {

    struct Paragraph: View {

        // MARK: - Properties

        let icon: String
        let title: String
        let description: String
        let delayAnimation: CGFloat

        // MARK: - Body

        var body: some View {
            HStack(alignment: .top, spacing: 20) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(.primary)
                        .font(.title3)
                        .bold()
                        .lineLimit(1)

                    Text(description)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

}

// MARK: - Previews

#Preview {
    OnBoardingView.Paragraph(
        icon: "heart",
        title: "Titre",
        description: "Ceci est une description",
        delayAnimation: 1.0
    )
}
