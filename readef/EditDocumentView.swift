//
//  EditDocumentView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI

struct EditDocumentView: View {
    @Environment(\.dismiss) var dismiss
    var document: ReadingDocument
    @State private var newTitle: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Document Details")) {
                    TextField("Title", text: $newTitle)
                }
            }
            .navigationTitle("Edit Document")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    saveChanges()
                }
                .disabled(newTitle.isEmpty)
            )
            .onAppear {
                newTitle = document.title
            }
        }
    }
    
    func saveChanges() {
        guard let docId = document.id else { return }
        FirebaseManager.shared.db.collection("documents").document(docId).updateData([
            "title": newTitle
        ])
        dismiss()
    }
}
