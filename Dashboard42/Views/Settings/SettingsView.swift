//
//  SettingsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 13/05/2024.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    @Environment(\.store) private var store

    @AppStorage(Constants.AppStorage.userIsConnected) private var userIsConnected: Bool?
    @AppStorage(Constants.AppStorage.userColorscheme) private var userColorscheme: Int?
    @AppStorage(Constants.AppStorage.userLanguage) private var userLanguage: String?
    @AppStorage(Constants.AppStorage.userLogtime) private var userLogtime: Int?

    @State private var colorscheme = UserDefaults.standard.integer(forKey: Constants.AppStorage.userColorscheme)
    @State private var language =
        UserDefaults.standard.string(forKey: Constants.AppStorage.userLanguage) ?? Locale.current.identifier.components(
            separatedBy: "_"
        ).first ?? "en"
    @State private var logtime = UserDefaults.standard.integer(forKey: Constants.AppStorage.userLogtime)
    @State private var showLogoutAlert = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Thème", selection: $colorscheme) {
                        ForEach(AppColorScheme.allCases) {
                            Text($0.title)
                                .tag($0.rawValue)
                        }
                    }
                } footer: {
                    Text("Définissez le thème de l'application.")
                }
                .onChange(of: colorscheme) {
                    userColorscheme = colorscheme
                }

                Section {
                    Picker("Langue", selection: $language) {
                        ForEach(AppLanguages.allCases) {
                            Text($0.title)
                                .tag($0.rawValue)
                        }
                    }
                } footer: {
                    Text("Définissez la langue de l'application.")
                }
                .onChange(of: language) {
                    userLanguage = language
                }

                Section {
                    Picker("Logtime", selection: $logtime) {
                        Text("Par défaut")
                            .tag(0)

                        ForEach(1...24, id: \.self) {
                            Text("\($0)h")
                                .tag($0)
                        }
                    }
                } footer: {
                    Text(
                        "Définissez une valeur par défaut pour le nombre d'heures que vous souhaitez travailler par jour. Laissez sur « Défaut » si vous souhaitez que l'application calcule automatiquement le nombre d'heures que vous devriez travailler par mois."
                    )
                }
                .onChange(of: logtime) {
                    userLogtime = logtime
                }

                Section("Aide") {
                    Link(
                        "Signaler un problème",
                        destination: URL(string: "https://github.com/Dashboard42/Dashboard42/issues")!
                    )
                    .foregroundStyle(.primary)
                }

                Section("Compte") {
                    Link(
                        "Profil intranet",
                        destination: URL(string: "https://profile.intra.42.fr/users/\(store.user?.id ?? -1)")!
                    )
                    .foregroundStyle(.primary)

                    Button("Se déconnecter", role: .destructive) {
                        showLogoutAlert = true
                    }
                }
                .alert("Se déconnecter", isPresented: $showLogoutAlert) {
                    Button("Annuler", role: .cancel, action: {})
                    Button("Se déconnecter", role: .destructive, action: store.authService.logout)
                } message: {
                    Text("Souhaitez-vous vraiment vous déconnecter de l'application ?")
                }
            }
            .navigationTitle("Paramètres")
        }
    }

}

// MARK: - Previews

#Preview {
    SettingsView()
}
