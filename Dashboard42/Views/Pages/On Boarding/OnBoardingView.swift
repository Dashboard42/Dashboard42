//
//  OnBoardingView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 02/08/2024.
//

import SwiftUI

struct OnBoardingView: View {
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
                AsyncButton("Sign In", action: {})
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(.accent)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 8, style: .continuous))
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
