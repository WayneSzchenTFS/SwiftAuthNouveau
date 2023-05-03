//
//  SettingsView.swift
//  SwiftAuth
//
//  Created by Wayne Chen on 2023-05-03.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject
{
    func signOut() throws
    {
        try AuthentificationManager.shared.signOut()
        
    }
    
    //Renvoyer le mot de passe
    func resetPassword() async throws
    {
        let authUser=try AuthentificationManager.shared.getAuthentificationUser()
        guard let email = authUser.email
                else
        {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthentificationManager.shared.reserPassword(email: email)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showingSignInView: Bool
    var body: some View {
        List {
            Button("Quitter")
            {
                Task{
                    do{
                        try viewModel.signOut()
                        showingSignInView = true
                    }catch
                    {
                        print(error)
                    }
                }
            }
            Button("Changer mot de passe")
            {
                Task{
                    do{
                        try await viewModel.resetPassword()
                        print("Mot de passe envoyé")
                    }catch
                    {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Paramètres")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showingSignInView: .constant(false))
    }
}
