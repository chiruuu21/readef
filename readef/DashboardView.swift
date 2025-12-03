//
//  DashboardView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI
import FirebaseFirestore

struct DashboardView: View {
    @StateObject var fbManager = FirebaseManager.shared
    @State private var showFileImporter = false
    @State private var isUploading = false
    
    // Live Query for Library
    @FirestoreQuery(collectionPath: "documents") var documents: [ReadingDocument]
    
    var body: some View {
        NavigationView {
            List(documents) { doc in
                NavigationLink(destination: ReadingView(document: doc)) {
                    VStack(alignment: .leading) {
                        Text(doc.title).font(.headline)
                        Text(doc.fileType.uppercased()).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("ReaDefine Library")
            .toolbar {
                Button(action: { showFileImporter = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.pdf, .plainText], // Add .epub if supported later
                allowsMultipleSelection: false
            ) { result in
                handleUpload(result: result)
            }
            .overlay {
                if isUploading {
                    ProgressView("Parsing & Uploading...")
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            // Filter query for current user
            if let uid = fbManager.currentUser?.uid {
                $documents.path = "documents"
                $documents.predicates = [.where("userId", isEqualTo: uid)]
            }
        }
    }
    
    func handleUpload(result: Result<[URL], Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            
            // Security Scoped Access (Required for iOS file picker)
            if selectedFile.startAccessingSecurityScopedResource() {
                defer { selectedFile.stopAccessingSecurityScopedResource() }
                
                isUploading = true
                
                // 1. Extract Text (Milestone 3 Parsing)
                let text = DocumentParser.extractText(from: selectedFile)
                
                // 2. Upload to Firebase
                fbManager.uploadDocument(url: selectedFile, text: text) { success in
                    isUploading = false
                    if !success {
                        print("Upload failed")
                    }
                }
            }
        } catch {
            print("File selection error: \(error.localizedDescription)")
        }
    }
}
