//
//  ContentView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

// MARK: - App Entry Point
// If using the new SwiftUI App lifecycle, this goes in your [AppName]App.swift file
/*
@main
struct ReaDefineApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/

// MARK: - Root View
struct ContentView: View {
    @StateObject var fbManager = FirebaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        if fbManager.currentUser != nil {
            // User is logged in, show Dashboard
            DashboardView()
        } else {
            // User needs to auth
            authView
        }
    }
    
    var authView: some View {
        VStack(spacing: 20) {
            Text("ReaDefine")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button(action: handleAuth) {
                Text(isSignUp ? "Sign Up" : "Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Already have an account? Log In" : "Create Account")
            }
        }
        .padding()
        .onAppear {
            fbManager.listenToAuthState()
        }
    }
    
    func handleAuth() {
        if isSignUp {
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error = error { print(error.localizedDescription) }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error = error { print(error.localizedDescription) }
            }
        }
    }
}
