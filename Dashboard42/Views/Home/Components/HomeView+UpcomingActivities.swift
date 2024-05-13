//
//  HomeView+UpcomingActivities.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension HomeView {

    struct UpcomingActivities: View {

        // MARK: - Properties

        @Environment(\.store) private var store

        private var userEvents: [Api.Event] { store.userEvents.filter(\.isInFuture) }
        private var hasUpcomingActivities: Bool {
            !userEvents.isEmpty || !store.userScales.isEmpty || !store.userExams.isEmpty
        }

        // MARK: - Body

        var body: some View {
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    Text("Activités à venir")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if hasUpcomingActivities {
                        NavigationLink("Tous voir") {
                            Details(events: userEvents, scales: store.userScales)
                        }
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    }
                }

                if hasUpcomingActivities {
                    if !store.userExams.isEmpty {
                        ExamList(exams: store.userExams, maxLength: 3)
                    }

                    if !store.userScales.isEmpty {
                        ScaleList(scales: store.userScales, maxLength: 3)
                    }

                    if !store.userEvents.isEmpty {
                        EventList(events: userEvents, maxLength: 3)
                    }
                }
                else {
                    ContentUnavailableView(
                        "Aucune activité prévu",
                        systemImage: "list.bullet.clipboard.fill",
                        description: Text(
                            "Inscrivez-vous à une activité (événement, correction ou examen) pour le voir apparaître sur la page d'accueil."
                        )
                    )
                    .padding(.vertical, 100)
                }
            }
        }
    }

}

// MARK: - Previews

#Preview {
    HomeView.UpcomingActivities()
}

// MARK: - Private Components

extension HomeView.UpcomingActivities {

    private struct Details: View {

        // MARK: - Properties

        @State private var selection = Activities.events

        let events: [Api.Event]
        let scales: [Api.Scale]

        // MARK: - Body

        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selectionne une catégorie d'activité", selection: $selection) {
                        ForEach(Activities.allCases) { activity in
                            Text(activity.rawValue)
                                .tag(activity)
                        }
                    }
                    .pickerStyle(.segmented)

                    if selection == .events && !events.isEmpty {
                        EventList(events: events)
                    }
                    else if selection == .scales && !scales.isEmpty {
                        ScaleList(scales: scales)
                    }
                    else {
                        ContentUnavailableView(
                            selection.unavailableTitle,
                            systemImage: selection.unavailableImage,
                            description: Text(selection.unavailableDescription)
                        )
                        .padding(.vertical, 175)
                    }
                }
                .padding()
            }
            .navigationTitle("Activités à venir")
        }

        // MARK: - Types

        enum Activities: String, Identifiable, CaseIterable {
            case events = "Évènements"
            case scales = "Corrections"

            var id: Self { self }

            var unavailableTitle: String {
                switch self {
                case .events:
                    return "Aucun événement prévu"
                case .scales:
                    return "Aucune correction prévu"
                }
            }

            var unavailableImage: String {
                switch self {
                case .events:
                    return "calendar"
                case .scales:
                    return "person.badge.clock.fill"
                }
            }

            var unavailableDescription: String {
                switch self {
                case .events:
                    return "Inscrivez-vous à un événement proposé par votre campus pour le voir apparaître ici."
                case .scales:
                    return
                        "Lorsqu'un étudiant prendra l’un de vos créneaux de correction pour se faire corriger, vous le verrez apparaître ici."
                }
            }
        }
    }

}
