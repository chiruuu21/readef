//
//  UserProfileView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @StateObject var fbManager = FirebaseManager.shared
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text(fbManager.currentUser?.email ?? "User")
                                .font(.headline)
                            Text("Standard Edition")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    Button("Sign Out") {
                        showSignOutAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("App Info")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0 (Beta)")
                            .foregroundColor(.secondary)
                    }
                    NavigationLink("About ReaDefine") {
                        Text("ReaDefine creates accessible reading experiences.")
                            .padding()
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    try? Auth.auth().signOut()
                }
            }
        }
    }
}
