//
//  OnBoardingView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import AuthenticationServices
import SwiftUI

struct OnBoardingView: View {

    // MARK: - Properties

    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(\.store) private var store
    @AppStorage(Constants.AppStorage.userIsConnected) private var userIsConnected: Bool?

    // MARK: - Body

    var body: some View {
        VStack {
            VStack(spacing: 50) {
                Title()

                Paragraph(
                    icon: "list.bullet.clipboard",
                    title: "Vos activités",
                    description:
                        "Consulter et gérer vos futurs événements, vos futurs examens et vos futures corrections.",
                    delayAnimation: 0.4
                )
                Paragraph(
                    icon: "magnifyingglass",
                    title: "Connectivité",
                    description:
                        "Rechercher et consulter le profil de n’importe quel autre étudiant du réseau 42 mondial.",
                    delayAnimation: 0.5
                )
                Paragraph(
                    icon: "person",
                    title: "Votre profil",
                    description:
                        "Consulter vos projets, votre logtime, vos événements et biens d’autres informations relative à votre cursus.",
                    delayAnimation: 0.6
                )
            }
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 15) {
                SignInButton(placeholder: "Se connecter", action: authenticate)
                Author()
            }
        }
        .padding()
    }
}

// MARK: - Previews

#Preview {
    OnBoardingView()
}

// MARK: - Private Methods

extension OnBoardingView {

    /// Orchestrates the OAuth authentication process for the application.
    /// It uses a web authentication session to open an authorisation URL where the user can connect and grant access to the application.
    /// It then manages the redirect response to obtain the necessary tokens and registers them using the authentication service.
    func authenticate() {
        Task {
            let authorizeUrl = Api.OAuthEndpoints.authorize.url
            let callbackUrl = Constants.Api.redirectUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

            guard let authorizeUrl = authorizeUrl, let callbackUrl = callbackUrl else {
                store.error = .invalidUrl
                return
            }

            do {
                let url = try await webAuthenticationSession.authenticate(
                    using: authorizeUrl,
                    callbackURLScheme: callbackUrl
                )
                try await store.authService.signIn(using: url)

                userIsConnected = true
            }
            catch {
                if error is Api.Errors {
                    store.error = error as? Api.Errors
                }
            }
        }
    }

}
