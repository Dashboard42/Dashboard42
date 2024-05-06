//
//  OnBoardingView+Title.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

extension OnBoardingView {

    struct Title: View {

        // MARK: - Body

        var body: some View {
            VStack(alignment: .leading) {
                Text("Bienvenue sur")
                Text("Dashboard42")
                    .foregroundStyle(.night)
            }
            .font(.system(size: 44, weight: .heavy))
            .lineSpacing(1.0)
            .multilineTextAlignment(.center)
            .frame(minWidth: 0, maxWidth: .infinity)
            .slideIn(rowHeight: 50, duration: 1, delay: 0.2)
        }
    }

}

// MARK: - Previews

#Preview {
    OnBoardingView.Title()
}
