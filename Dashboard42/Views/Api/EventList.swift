//
//  EventList.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

struct EventList: View {

    // MARK: - Properties

    let events: [Api.Event]
    let maxLength: Int

    init(events: [Api.Event], maxLength: Int? = nil) {
        self.events = events
        self.maxLength = maxLength != nil ? maxLength! : events.count
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Évènements")
                .foregroundStyle(.secondary)
                .font(.subheadline)

            ForEach(events.prefix(maxLength), content: EventRow.init)
        }
    }
}

// MARK: - Previews

#Preview {
    EventList(events: .sample, maxLength: 3)
}

// MARK: - Private Components

extension EventList {

    // MARK: - Event Row

    private struct EventRow: View {

        // MARK: - Properties

        let event: Api.Event

        // MARK: - Body

        var body: some View {
            NavigationLink {
                EventDetails(event: event)
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundStyle(.night)
                        .font(.headline)
                        .imageScale(.large)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)

                        Text(event.beginAt, format: .dateTime.day().month().year().hour().minute())
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.secondary)
                        .imageScale(.small)
                }
                .padding(.vertical, 8)
            }
            .foregroundStyle(.primary)
        }
    }

    // MARK: - Event Details

    private struct EventDetails: View {

        // MARK: - Properties

        @Environment(\.dismiss) private var dismiss
        @Environment(\.store) private var store
        @State private var actionAlert: Bool = false

        let event: Api.Event

        private var userIsSubscribe: Bool { store.userEvents.contains(where: { $0.id == event.id }) }

        // MARK: - Body

        var body: some View {
            List {
                Section("Informations") {
                    HorizontalRow(
                        title: "Date",
                        value: event.beginAt.formatted(.dateTime.day().month().year().hour().minute())
                    )
                    HorizontalRow(title: "Durée", value: Date.duration(beginAt: event.beginAt, endAt: event.endAt))
                    HorizontalRow(title: "Inscrit", value: userIsSubscribe ? "Oui" : "Non")
                    HorizontalRow(title: "Participants", value: event.numberOfSubscribers)
                    HorizontalRow(title: "Lieu", value: event.location)
                }

                Section("Description") {
                    Text(event.description)
                }
            }
            .navigationTitle(event.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if event.beginAt > Date.now {
                    Button(userIsSubscribe ? "Se désinscrire" : "S'inscrire") {
                        actionAlert = true
                    }
                }
            }
            .alert(
                userIsSubscribe ? "Se désinscrire de l'événement" : "S'inscrire à l'événement",
                isPresented: $actionAlert
            ) {
                Button("Annuler", role: .cancel, action: {})
                Button(userIsSubscribe ? "Se désinscrire" : "S'inscrire", action: handleAction)
            } message: {
                Text(
                    userIsSubscribe
                        ? "Souhaitez vous vraiment vous désinscrire de cet événement ?"
                        : "Souhaitez vous vraiment vous inscrire à cet événement ?"
                )
            }
        }

        // MARK: - Private Components

        private func HorizontalRow(title: String, value: String) -> some View {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                    .padding(.trailing, 10)

                Spacer()

                Text(value)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.vertical, 4)
        }

        // MARK: - Private Methods

        /// Manages the action associated with an event for a given user.
        private func handleAction() {
            guard let user = store.user else { return }

            Task {
                do {
                    if userIsSubscribe {
                        try await store.eventService.deleteUserEvent(userId: user.id, eventId: event.id)
                        store.userEvents.removeAll(where: { $0.id == event.id })
                    }
                    else {
                        try await store.eventService.updateUserEvent(userId: user.id, eventId: event.id)
                        store.userEvents.append(event)
                    }
                }
                catch {
                    store.error = error as? Api.Errors
                }
            }
        }

    }

}
