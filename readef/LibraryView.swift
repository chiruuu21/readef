//
//  DashboardView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI
import FirebaseFirestore

struct LibraryView: View {
    @StateObject var fbManager = FirebaseManager.shared
    @FirestoreQuery(collectionPath: "documents") var documents: [ReadingDocument]
    @State private var searchText = ""
    
    // For Edit Sheet
    @State private var documentToEdit: ReadingDocument?
    
    var filteredDocs: [ReadingDocument] {
        if searchText.isEmpty { return documents }
        return documents.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredDocs) { doc in
                    NavigationLink(destination: ReadingView(document: doc)) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text(doc.title)
                                    .font(.headline)
                                Text("Page \(doc.currentPage) • \(doc.fileType.uppercased())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Edit Button
                            Button(action: { documentToEdit = doc }) {
                                Image(systemName: "pencil.circle")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .onDelete(perform: deleteDocument)
            }
            .searchable(text: $searchText, prompt: "Search your library...")
            .navigationTitle("My Library")
            .sheet(item: $documentToEdit) { doc in
                EditDocumentView(document: doc)
            }
        }
        .onAppear {
            if let uid = fbManager.currentUser?.uid {
                $documents.path = "documents"
                $documents.predicates = [
                    .where("userId", isEqualTo: uid),
                    .order(by: "uploadDate", descending: true)
                ]
            }
        }
    }
    
    func deleteDocument(at offsets: IndexSet) {
        offsets.map { filteredDocs[$0] }.forEach { doc in
            guard let id = doc.id else { return }
            fbManager.db.collection("documents").document(id).delete()
        }
    }
}
