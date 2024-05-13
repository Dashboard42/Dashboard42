//
//  CampusView+FilterButton.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension CampusView {

    struct FilterButton: View {

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

// MARK: - Previews

#Preview {
    CampusView.FilterButton(selection: .constant("Tous"), events: .sample)
}
