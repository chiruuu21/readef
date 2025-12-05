//
//  MainTabView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
            
            UploadView()
                .tabItem {
                    Label("Upload", systemImage: "square.and.arrow.up.fill")
                }
            
            UserProfileView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
