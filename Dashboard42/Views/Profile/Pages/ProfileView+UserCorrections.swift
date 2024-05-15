//
//  ProfileView+UserCorrections.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 14/05/2024.
//

import Charts
import SwiftUI

extension ProfileView {

    struct UserCorrections: View {

        // MARK: - Properties

        @Environment(\.store) private var store
        @State private var showCorrectionSheet = false

        // MARK: - Body

        var body: some View {
            VStack(spacing: 30) {
                GroupBox {
                    CorrectionPointHistoricsChart(correctionPointHistorics: store.userCorrectionPointHistorics)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Points de corrections")
                        Text(store.user?.correctionPoint ?? 0, format: .number)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                }

                CorrectionSlotList(showCorrectionSheet: $showCorrectionSheet)
            }
            .navigationTitle("Corrections")
            .padding()
            .toolbar {
                Button {
                    showCorrectionSheet = true
                } label: {
                    Label("Add a correction slot", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .imageScale(.small)
                }
            }
            .sheet(isPresented: $showCorrectionSheet) {
                CorrectionSheet(showCorrectionSheet: $showCorrectionSheet)
            }
        }
    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserCorrections()
}

// MARK: - Private Components

extension ProfileView.UserCorrections {

    private struct CorrectionPointHistoricsChart: View {

        // MARK: - Properties

        let correctionPointHistorics: [Api.CorrectionPointHistorics]

        // MARK: - Body

        var body: some View {
            Chart(correctionPointHistorics.prefix(20)) {
                AreaMark(x: .value("Date", $0.updatedAt), y: .value("Total", $0.total))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.night, .night.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .frame(height: 150)
        }
    }

    private struct CorrectionSlotList: View {

        // MARK: - Properties

        @Environment(\.store) private var store
        @Binding var showCorrectionSheet: Bool

        private var slotsAvailable: [Api.GroupedSlots] {
            let slotsAvailable = store.userSlots.filter { $0.scaleTeam == nil }
            return Api.GroupedSlots.create(for: slotsAvailable)
        }

        private var slotsTaken: [Api.GroupedSlots] {
            let slotsTaken = store.userSlots.filter { $0.scaleTeam != nil }
            return Api.GroupedSlots.create(for: slotsTaken)
        }

        private var isSlots: Bool { !slotsAvailable.isEmpty || !slotsTaken.isEmpty }

        // MARK: - Body

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Créneau de correction")
                    .font(.headline)
                    .padding(.horizontal)

                if isSlots {
                    List {
                        if !slotsTaken.isEmpty {
                            Section("Créneau pris") {
                                ForEach(slotsTaken, content: SlotRow.init)
                            }
                        }

                        if !slotsAvailable.isEmpty {
                            Section("Créneau disponible") {
                                ForEach(slotsAvailable, content: SlotRow.init)
                                    .onDelete(perform: onDelete)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                else {
                    ContentUnavailableView {
                        Label("Aucun créneau de correction trouvé", systemImage: "scroll")
                    } description: {
                        Text("Créez un créneau de correction pour le voir apparaître dans la liste.")
                    } actions: {
                        Button("Créer un créneau de correction") {
                            showCorrectionSheet = true
                        }
                    }

                }
            }
        }

        // MARK: - Private Methods

        private func onDelete(indexSet: IndexSet) {
            Task {
                for index in indexSet {
                    guard slotsAvailable.count > index else { return }

                    for slot in slotsAvailable[index].slots {
                        guard slot.scaleTeam == nil else { return }
                    }

                    for slotId in slotsAvailable[index].slotsIds {
                        do {
                            let endpoint = Api.CorrectionEndpoints.deleteUserSlot(slotId: slotId)
                            try await Api.shared.delete(endpoint)
                        }
                        catch {
                            store.error = error as? Api.Errors
                        }
                    }
                }

                do {
                    let endpoint = Api.CorrectionEndpoints.fetchUserSlots
                    store.userSlots = try await Api.shared.fetch(endpoint, type: [Api.Slot].self)
                }
                catch {
                    store.error = error as? Api.Errors
                }
            }
        }

    }

    private struct CorrectionSheet: View {

        // MARK: - Properties

        @Environment(\.store) private var store
        @Binding var showCorrectionSheet: Bool

        @State private var defaultBeginAt = Date(timeIntervalSinceNow: 2_700)
        @State private var defaultEndBeginAt = Date(timeIntervalSinceNow: 1_204_200)
        @State private var defaultEndAt = Date(timeIntervalSinceNow: 1_207_800)
        @State private var beginAt = Date(timeIntervalSinceNow: 2_700)
        @State private var endAt = Date(timeIntervalSinceNow: 6_300)

        // MARK: - Body

        var body: some View {
            NavigationStack {
                VStack {
                    Text(
                        "A slot is an interval of time during which you declare yourself available to assess other users. A slot can be defined each day between 45 minutes and 2 weeks in advance and must last at least one hour."
                    )
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.horizontal, 14)

                    Form {
                        DatePicker("Begin", selection: $beginAt, in: defaultBeginAt...defaultEndBeginAt)
                        DatePicker(
                            "End",
                            selection: $endAt,
                            in: Date(timeInterval: 3_600, since: beginAt)...defaultEndAt
                        )
                    }
                    .onChange(of: beginAt, onBeginAtChange)
                }
                .navigationTitle("New correction slot")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) { showCorrectionSheet = false }
                    }

                    ToolbarItem {
                        Button("Add", action: createSlot)
                    }
                }
            }
            .onAppear { UIDatePicker.appearance().minuteInterval = 15 }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }

        // MARK: - Private Methods

        private func createSlot() {
            guard Date.now < beginAt else { return }
            guard beginAt < endAt else { return }
            guard let user = store.user else { return }
            guard let difference = Calendar.current.dateComponents([.hour], from: beginAt, to: endAt).hour,
                difference >= 1
            else { return }

            Task {
                do {
                    var endpoint = Api.CorrectionEndpoints.createUserSlot(
                        userId: user.id,
                        beginAt: beginAt,
                        endAt: endAt
                    )
                    try await Api.shared.post(endpoint)

                    endpoint = Api.CorrectionEndpoints.fetchUserSlots
                    store.userSlots = try await Api.shared.fetch(endpoint, type: [Api.Slot].self)
                }
                catch {
                    store.error = error as? Api.Errors
                }
            }
            showCorrectionSheet = false
        }

        private func onBeginAtChange() {
            let date = Date(timeInterval: 3_600, since: beginAt)

            guard let difference = Calendar.current.dateComponents([.hour], from: beginAt, to: endAt).hour,
                difference <= 1
            else { return }

            if date < defaultEndAt {
                endAt = date
            }
        }

    }

}
