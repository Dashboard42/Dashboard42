//
//  CampusView+CategoryPicker.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

extension CampusView {

    struct CategoryPicker: View {

        // MARK: - Properties

        @Binding var selection: CampusCategoryPicker

        // MARK: - Body

        var body: some View {
            Picker("Sélectionner une categorie d'activité", selection: $selection) {
                ForEach(CampusCategoryPicker.allCases) { category in
                    Text(category.title)
                }
            }
            .pickerStyle(.segmented)
        }

        // MARK: - Type

        enum CampusCategoryPicker: Identifiable, CaseIterable {
            case events
            case exams

            var id: Self { self }

            var title: String {
                switch self {
                case .events:
                    return "Évènenents"
                case .exams:
                    return "Examens"
                }
            }

            var unavailableTitle: String {
                switch self {
                case .events:
                    return "Aucun événement prévu"
                case .exams:
                    return "Aucun examen prévu"
                }
            }

            var unavailableImage: String {
                switch self {
                case .events:
                    return "calendar"
                case .exams:
                    return "hourglass"
                }
            }

            var unavailableDescription: String {
                switch self {
                case .events:
                    return "Inscrivez-vous à un événement proposé par votre campus pour le voir apparaître ici."
                case .exams:
                    return "Aucun examen n'est proposé par votre campus pour le moment."
                }
            }
        }

    }

}

// MARK: - Previews

#Preview {
    CampusView.CategoryPicker(selection: .constant(.events))
}
