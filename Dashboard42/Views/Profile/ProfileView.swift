//
//  ProfileView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @State private var isLoading = false

    let userParam: Api.User?
    let isSearchedProfile: Bool

    init() {
        self.userParam = nil
        self.isSearchedProfile = false
    }

    init(user: Api.User) {
        self.userParam = user
        self.isSearchedProfile = true
    }

    private var user: Api.User? { isSearchedProfile ? userParam : store.user }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack {
                if let user = user, !isLoading {
                    ScrollView {
                        VStack(spacing: 40) {
                            HStack(spacing: 20) {
                                Avatar(url: user.image.link, isAvailable: user.location != nil)
                                Informations(
                                    name: user.displayname,
                                    email: user.email,
                                    isPostCommonCore: user.postCC,
                                    cursus: user.mainCursus
                                )
                            }
                            GridInformations(
                                location: user.location,
                                grade: user.mainCursus?.grade,
                                poolYear: user.poolYear
                            )
                            Dashboard(user: user, isSearchedProfile: isSearchedProfile)
                        }
                        .padding()
                    }
                    .refreshable {
                        await refresh()
                    }
                }
                else {
                    ProgressView()
                }
            }
        }
    }

    // MARK: - Private Methods

    private func refresh() async {
        isLoading = true
        isLoading = false
    }

}

// MARK: - Previews

#Preview {
    ProfileView()
}
