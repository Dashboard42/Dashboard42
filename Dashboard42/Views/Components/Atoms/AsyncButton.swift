//
//  AsyncButton.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 25/07/2024.
//

import SwiftUI

/// A control that initiates an asynchronous action.
struct AsyncButton<Label>: View where Label: View {
    private let action: () async -> Void
    private let label: () -> Label

    /// Creates a button that displays a custom label.
    ///
    /// - Parameters:
    ///   - action: The asynchronous action to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    init(action: @escaping () async -> Void, label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    @State private var isPerformingTask: Bool = false

    var body: some View {
        Button(
            action: {
                self.isPerformingTask = true

                Task {
                    await self.action()
                    self.isPerformingTask = false
                }
            },
            label: {
                ZStack {
                    self.label()
                        .opacity(self.isPerformingTask ? 0 : 1)

                    if self.isPerformingTask {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(self.isPerformingTask)
    }
}

extension AsyncButton where Label == Text {

    /// Creates a button that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes the purpose of the button's `action`.
    ///   - action: The action to perform when the user triggers the button.
    init(_ titleKey: LocalizedStringKey, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(titleKey)
        }
    }

}

extension AsyncButton where Label == Image {

    /// Creates a button that generates its label from a system image name.
    ///
    /// - Parameters:
    ///   - systemImage: The name of the image resource to lookup.
    ///   - action: The action to perform when the user triggers the button.
    init(systemImage: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Image(systemName: systemImage)
        }
    }
}

#Preview {
    AsyncButton("Hello, World", action: { try? await Task.sleep(for: .seconds(2)) })
}
