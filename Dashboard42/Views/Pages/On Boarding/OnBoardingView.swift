//
//  OnBoardingView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 02/08/2024.
//

import AuthenticationServices
import SwiftUI

struct OnBoardingView: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession: WebAuthenticationSession
    @Environment(\.store) private var store: Store

    @MainActor private func authenticate() async {
        let authorize = AuthEndpoints.authorize.request.url
        let callback = Constant.redirectUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        guard let authorize = authorize, let callback = callback else {
            return
        }

        do {
            let url = try await self.webAuthenticationSession.authenticate(
                using: authorize,
                callbackURLScheme: callback
            )
            try await self.store.authService.signIn(using: url)
        }
        catch let error {
            print("Erreur : \(error)")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()

            AppIcon()
                .frame(width: 80, height: 80)
                .clipShape(.rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 0) {
                Text("Welcome to")
                Text("Dashboard42")
                    .foregroundStyle(.accent)
            }
            .font(.largeTitle)
            .fontWeight(.heavy)

            Text("An application developed by a student for the 42 student community.")
                .font(.subheadline)

            Spacer()
            Spacer()

            VStack(spacing: 16) {
                AsyncButton("Sign In", action: self.authenticate)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(.accent)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 8))
                    .fontWeight(.medium)

                Text("Developed by Marc MOSCA while eating 🍿.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    OnBoardingView()
}
