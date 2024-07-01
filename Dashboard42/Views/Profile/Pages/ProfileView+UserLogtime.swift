//
//  ProfileView+UserLogtime.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 14/05/2024.
//

import Charts
import SwiftUI

extension ProfileView {

    struct UserLogtime: View {

        // MARK: - Properties

        @Environment(\.store) private var store

        private var logtimes: [Api.Logtime] {
            guard !store.userLogtimes.contains(where: { $0.fullmonth == Date.currentMonthDate }) else {
                return store.userLogtimes
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"

            guard let date = dateFormatter.date(from: Date.currentMonthDate) else { return store.userLogtimes }

            dateFormatter.dateFormat = "yyyy-MM"
            let month = dateFormatter.string(from: date)

            let currentMonthLogtime = Api.Logtime(
                month: month,
                total: Date.currentMonthLogtime(store.userLogtimes),
                details: Api.LogtimeResult(),
                numberOfDaysToWork: Date.getNumberOfDaysToWorkPerMonth(month)
            )
            store.userLogtimes.insert(currentMonthLogtime, at: 0)
            return store.userLogtimes
        }

        // MARK: - Body

        var body: some View {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(logtimes) { logtime in
                            VStack {
                                GroupBox {
                                    LogtimeChart(
                                        month: logtime.fullmonth,
                                        currentLogtime: logtime.total,
                                        numberOfDaysToWork: logtime.numberOfDaysToWork
                                    )
                                } label: {
                                    HStack {
                                        Label(logtime.fullmonth, systemImage: "clock")
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                                        if !logtime.details.isEmpty {
                                            NavigationLink("Détails") {
                                                LogtimeDetails(logtimes: logtime)
                                            }
                                            .foregroundStyle(.secondary)
                                            .font(.footnote)
                                        }
                                    }
                                }
                                .frame(maxHeight: 450)

                                HStack {
                                    GroupBox("Total") {
                                        Text("\(String(format: "%.2f", logtime.total)) heures")
                                            .foregroundStyle(.secondary)
                                    }

                                    GroupBox("Moyenne") {
                                        let average =
                                            logtime.total == 0 || logtime.details.count == 0
                                            ? 0 : logtime.total / Double(logtime.details.count)

                                        Text("\(String(format: "%.2f", average))h / jour")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(16, for: .scrollContent)
                .scrollTargetBehavior(.paging)
            }
            .navigationTitle("Logtime")
        }

    }

}

// MARK: - Previews

#Preview {
    ProfileView.UserLogtime()
}

// MARK: - Private Components

extension ProfileView {

    private struct LogtimeChart: View {

        // MARK: - Properties

        @AppStorage(Constants.AppStorage.userLogtime) private var userLogtime: Int?

        let month: String
        let currentLogtime: Double
        let numberOfDaysToWork: Double

        private var timeToWork: Double {
            guard let userLogtime, userLogtime != 0 else { return numberOfDaysToWork * 7 }
            return numberOfDaysToWork * Double(userLogtime)
        }

        private var logtimeChartData: [(type: String, time: Double)] {
            [
                (type: month, time: currentLogtime),
                (type: "default", time: timeToWork - currentLogtime < 0 ? 0 : timeToWork - currentLogtime),
            ]
        }

        // MARK: - Body

        var body: some View {
            Chart(logtimeChartData, id: \.type) {
                SectorMark(
                    angle: .value("Valeur", $1),
                    innerRadius: .ratio(0.618),
                    outerRadius: .inset(10),
                    angularInset: 1
                )
                .cornerRadius(8)
                .foregroundStyle(.night)
                .opacity($0 == "default" ? 0.5 : 1)
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]

                    VStack {
                        Text("Objectif")
                            .font(.title2.bold())
                            .foregroundColor(.primary)

                        Text(currentLogtime / timeToWork, format: .percent.precision(.fractionLength(2)))
                            .foregroundStyle(.secondary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                    .font(.callout)
                }
            }
        }
    }

    private struct LogtimeDetails: View {

        // MARK: - Properties

        let logtimes: Api.Logtime

        private var sortedLogtimes: [Dictionary<String, String>.Element] {
            logtimes.details.sorted(by: { $0.key < $1.key })
        }

        // MARK: - Body

        var body: some View {
            List {
                ForEach(sortedLogtimes, id: \.key) { date, time in
                    HStack {
                        Text(formattedDate(date))
                            .foregroundStyle(.primary)
                            .padding(.trailing, 10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                        Text(formattedTime(time))
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(logtimes.fullmonth)
        }

        // MARK: - Private Methods

        private func formattedDate(_ dateStr: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let date = dateFormatter.date(from: dateStr) else { return dateStr }

            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "EE dd MMM yyyy"
            newDateFormatter.locale = Locale(
                identifier: UserDefaults.standard.string(forKey: Constants.AppStorage.userLanguage) ?? "fr"
            )

            return newDateFormatter.string(from: date).capitalized
        }

        private func formattedTime(_ time: String) -> String {
            let split = time.split(separator: ":")
            guard split.count > 2 else { return time }
            return "\(split[0])h \(split[1])min"
        }

    }

}
