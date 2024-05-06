//
//  HandleErrorsViewModifier.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct HandleErrorsViewModifier: ViewModifier {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    let error: Api.Errors?
    let actions: (() -> Void)?

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(error != nil), error: error) { error in
                Button("Annuler", role: .cancel) {}

                Button("OK") {
                    actions?()
                    dismiss()
                }
            } message: { error in
                Text(error.failureReason ?? "Une erreur s'est produite. Merci de réessayer plus tard.")
            }

    }

}

// MARK: - Extensions

extension View {

    /// Presents an alert when an error occurs in the application.
    /// - Parameters:
    ///   - error: An ErrorType value indicating the type of error.
    ///   - actions: Actions to be triggered when the button in the error alert is validated.
    /// - Returns: A view with a new error alert.
    func handleError(error: Api.Errors?, actions: (() -> Void)? = nil) -> some View {
        modifier(HandleErrorsViewModifier(error: error, actions: actions))
    }

}
