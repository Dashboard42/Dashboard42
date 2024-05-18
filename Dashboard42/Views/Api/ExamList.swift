//
//  ExamList.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

struct ExamList: View {

    // MARK: - Properties

    let exams: [Api.Exam]
    let maxLength: Int

    init(exams: [Api.Exam], maxLength: Int? = nil) {
        self.exams = exams
        self.maxLength = maxLength != nil ? maxLength! : exams.count
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Examens")
                .foregroundStyle(.secondary)
                .font(.subheadline)

            ForEach(exams.prefix(maxLength), content: ExamRow.init)
        }
    }
}

// MARK: - Previews

#Preview {
    ExamList(exams: .sample)
}

// MARK: - Private Components

extension ExamList {

    private struct ExamRow: View {

        // MARK: - Properties

        let exam: Api.Exam
        
        private var locale: Locale {
            Locale(identifier: UserDefaults.standard.string(forKey: Constants.AppStorage.userLanguage) ?? "fr")
        }

        // MARK: - Body

        var body: some View {
            NavigationLink {
                List {
                    Section("Informations") {
                        HorizontalRow(
                            title: "Date",
                            value: "\(exam.beginAt.formatted(.dateTime.day().month().year().hour().minute().locale(locale)))"
                        )
                        HorizontalRow(title: "Durée", value: Date.duration(beginAt: exam.beginAt, endAt: exam.endAt))
                        HorizontalRow(title: "Participants", value: "\(exam.numberOfSubscribers)")
                        HorizontalRow(title: "Lieu", value: "\(exam.location)")
                    }

                    Section("Projets associés") {
                        ForEach(exam.projects) {
                            Text($0.name)
                        }
                    }
                }
                .navigationTitle(exam.name)
                .navigationBarTitleDisplayMode(.inline)
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "hourglass")
                        .foregroundStyle(.night)
                        .font(.headline)
                        .imageScale(.large)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(exam.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)

                        Text(exam.beginAt, format: .dateTime.day().month().year().hour().minute())
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

        // MARK: - Private Components

        private func HorizontalRow(title: LocalizedStringResource, value: LocalizedStringResource) -> some View {
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
    }

}
