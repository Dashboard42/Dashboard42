//
//  OnBoardingView+SignInButton.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

extension OnBoardingView {

    struct SignInButton: View {

        // MARK: - Properties

        let placeholder: String
        let action: () -> Void

        // MARK: - Body

        var body: some View {
            Button(placeholder, action: action)
                .font(.body)
                .bold()
                .foregroundStyle(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(.night)
                .clipShape(.buttonBorder)
                .slideIn(rowHeight: 50, duration: 1, delay: 0.8)
        }
    }

}

// MARK: - Previews

#Preview {
    OnBoardingView.SignInButton(placeholder: "Click me", action: {})
}
