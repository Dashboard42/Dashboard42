//
//  ContentView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @AppStorage(Constants.AppStorage.userIsConnected) private var userIsConnected: Bool?
    @State private var isLoading = false

    // MARK: - Body

    var body: some View {
        @Bindable var store = store

        if userIsConnected != true {
            OnBoardingView()
        }
        else {
            VStack {
                if isLoading {
                    ProgressView()
                }
                else {
                    AppTabView(selection: $store.selection)
                }
            }
            .task {
                await fetchConnectedUserInformations()
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ContentView()
}

// MARK: - Private Methods

extension ContentView {

    /// Retrieves full details of the logged-in user, it also handles load status and potential errors.
    func fetchConnectedUserInformations() async {
        isLoading = true

        do {
            let user = try await store.userService.fetchUser()
            let campusId = user.mainCampus?.campusId
            let cursusId = user.mainCursus?.cursusId

            guard let campusId, let cursusId else { return }

            store.user = user
            store.userEvents = try await store.eventService.fetchUserEvents(userId: user.id)
            store.userExams = try await store.examService.fetchUserExams(userId: user.id)
            store.campusEvents = try await store.eventService.fetchCampusEvents(campusId: campusId, cursusId: cursusId)
            store.campusExams = try await store.examService.fetchCampusExams(campusId: campusId)
        }
        catch {
            store.error = error as? Api.Errors
            store.errorAction = {
                Task {
                    await fetchConnectedUserInformations()
                }
            }
        }

        isLoading = false
    }

}
