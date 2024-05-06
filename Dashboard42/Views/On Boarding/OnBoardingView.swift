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
                SignInButton(placeholder: "Se connecter") {
                }

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

}
