//
//  OnBoardingView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 02/08/2024.
//

import AuthenticationServices
import SwiftUI

@MainActor
struct OnBoardingView: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(\.store) private var store: Store

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
                AsyncButton("Sign In", action: self.signIn)
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

extension OnBoardingView {

    private func signIn() async {
        let url: URL?
        let callback: String?
        let authenticationURL: URL

        url = AuthEndpoints.authorize.request.url
        callback = Constant.redirectUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        do {
            authenticationURL = try await self.authenticate(url: url, callback: callback)
            try await self.store.authService.signIn(using: authenticationURL)
        }
        catch let error {
            print("Erreur : \(error)")
        }
    }

    private func authenticate(url: URL?, callback: String?) async throws -> URL {
        guard let url = url, let callback = callback else { throw NSError() }

        if #available(iOS 17.4, *) {
            return try await self.webAuthenticationSession.authenticate(
                using: url,
                callback: .customScheme(callback),
                additionalHeaderFields: [:]
            )
        }
        else {
            return try await self.webAuthenticationSession.authenticate(using: url, callbackURLScheme: callback)
        }
    }

}

#Preview {
    OnBoardingView()
}
