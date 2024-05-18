//
//  SlotRow.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 15/05/2024.
//

import SwiftUI

struct SlotRow: View {

    // MARK: - Properties

    let slot: Api.GroupedSlots

    private var isSameDay: Bool { slot.beginAt != slot.endAt }
    private var duration: LocalizedStringResource { Date.duration(beginAt: slot.beginAt, endAt: slot.endAt) }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "scroll")
                .foregroundStyle(.night)
                .font(.headline)
                .imageScale(.large)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(slot.beginAt, format: .dateTime.day().month().year())

                    if !isSameDay {
                        Text("- \(slot.endAt, format: .dateTime.day().month().year())")
                    }
                }
                .foregroundStyle(.primary)
                .font(.system(.subheadline, weight: .semibold))

                HStack {
                    Text(
                        "\(slot.beginAt, format: .dateTime.hour().minute()) - \(slot.endAt, format: .dateTime.hour().minute())"
                    )
                    Text(duration)
                }
                .foregroundStyle(.secondary)
                .font(.footnote)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}
