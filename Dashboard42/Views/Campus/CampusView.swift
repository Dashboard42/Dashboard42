//
//  CampusView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

struct CampusView: View {

    // MARK: - Properties

    @Environment(\.store) private var store
    @State private var isLoading = false
    @State private var selection = CategoryPicker.CampusCategoryPicker.events
    @State private var selectedFilter = "Tous"
    @State private var searched = ""

    private var events: [Api.Event] {
        let filteredEvents =
            selectedFilter == "Tous"
            ? store.campusEvents : store.campusEvents.filter { $0.kind.capitalized == selectedFilter }

        guard !searched.isEmpty else { return filteredEvents }
        return filteredEvents.filter { $0.name.lowercased().contains(searched.lowercased()) }
    }

    private var exams: [Api.Exam] {
        guard !searched.isEmpty else { return store.campusExams }
        return store.campusExams.filter { $0.name.lowercased().contains(searched.lowercased()) }
    }

    private var isSearchedButNoResultFound: Bool {
        !searched.isEmpty && ((selection == .events && events.isEmpty) || (selection == .exams && exams.isEmpty))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack {
                if !isLoading {
                    ScrollView {
                        VStack(spacing: 20) {
                            CategoryPicker(selection: $selection)

                            if isSearchedButNoResultFound {
                                ContentUnavailableView.search(text: searched)
                                    .padding(.vertical, 200)
                            }
                            else if selection == .events && !events.isEmpty {
                                EventList(events: events)
                            }
                            else if selection == .exams && !exams.isEmpty {
                                ExamList(exams: exams)
                            }
                            else {
                                ContentUnavailableView(
                                    selection.unavailableTitle,
                                    systemImage: selection.unavailableImage,
                                    description: Text(selection.unavailableDescription)
                                )
                                .padding(.vertical, 150)
                            }
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
            .navigationTitle("Mon campus")
            .searchable(text: $searched)
            .toolbar {
                if selection == .events {
                    FilterButton(selection: $selectedFilter, events: store.campusEvents)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    CampusView()
}

// MARK: - Private Methods

extension CampusView {

    private func refresh() async {
        let campusId = store.user?.mainCampus?.campusId
        let cursusId = store.user?.mainCursus?.cursusId

        guard let campusId, let cursusId else { return }

        isLoading = true

        do {
            store.campusEvents = try await store.eventService.fetchCampusEvents(campusId: campusId, cursusId: cursusId)
            store.campusExams = try await store.examService.fetchCampusExams(campusId: campusId)
        }
        catch {
            store.error = error as? Api.Errors
        }

        isLoading = false
    }

}
