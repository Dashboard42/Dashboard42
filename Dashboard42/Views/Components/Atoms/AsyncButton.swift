//
//  AsyncButton.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 25/07/2024.
//

import SwiftUI

struct AsyncButton<Label>: View where Label: View {
    let action: () async -> Void
    let label: () -> Label

    @State private var isPerformingTask: Bool = false

    var body: some View {
        Button(
            action: {
                isPerformingTask = true

                Task {
                    await action()
                    isPerformingTask = false
                }
            },
            label: {
                ZStack {
                    label().opacity(isPerformingTask ? 0 : 1)

                    if isPerformingTask {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isPerformingTask)
    }
}

extension AsyncButton where Label == Text {
    init(_ label: LocalizedStringKey, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(label)
        }
    }
}

extension AsyncButton where Label == Image {
    init(systemImageName: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Image(systemName: systemImageName)
        }
    }
}

#Preview {
    AsyncButton("Hello, World", action: { try? await Task.sleep(for: .seconds(2)) })
}
