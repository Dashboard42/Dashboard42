//
//  ProfileView+UserEvents.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 14/05/2024.
//

import SwiftUI

extension ProfileView {

    struct UserEvents: View {

        // MARK: - Properties

        @Environment(\.store) private var store
        @State private var selectedFilter = "Tous"
        @State private var searched = ""

        private var events: [Api.Event] {
            let filteredEvents =
                selectedFilter == "Tous"
                ? store.userEvents : store.userEvents.filter { $0.kind.capitalized == selectedFilter }

            guard !searched.isEmpty else { return filteredEvents }
            return filteredEvents.filter { $0.name.lowercased().contains(searched.lowercased()) }
        }

        // MARK: - Body

        var body: some View {
            ScrollView {
                VStack {
                    EventList(events: events)
                }
                .padding()
            }
            .navigationTitle("Évènements")
            .searchable(text: $searched)
            .toolbar {
                FilterButton(selection: $selectedFilter, events: store.userEvents)
            }
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserEvents()
}

// MARK: - Private Components

extension ProfileView.UserEvents {

    private struct FilterButton: View {

        // MARK: - Properties

        @Binding var selection: String
        let filters: [String]

        init(selection: Binding<String>, events: [Api.Event]) {
            self._selection = selection

            var filters: Set<String> = Set(events.map(\.kind.capitalized))
            filters.insert("Tous")

            self.filters = Array(filters).sorted()
        }

        // MARK: - Body

        var body: some View {
            Menu {
                Picker("Select a filter", selection: $selection) {
                    ForEach(filters, id: \.self, content: Text.init)
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .imageScale(.large)
            }
            .tint(.night)
        }
    }

}
