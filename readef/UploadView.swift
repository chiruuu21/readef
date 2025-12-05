//
//  UploadView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI

struct UploadView: View {
    @StateObject var fbManager = FirebaseManager.shared
    @State private var showFileImporter = false
    @State private var isUploading = false
    @State private var uploadStatusMessage = ""
    @State private var showSuccessCheck = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                Spacer()
                
                if isUploading {
                    ProgressView()
                        .scaleEffect(2)
                    Text("Processing Document...")
                        .font(.headline)
                        .padding(.top)
                } else if showSuccessCheck {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    Text("Upload Complete!")
                        .font(.title2)
                        .bold()
                } else {
                    Image(systemName: "icloud.and.arrow.up")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Upload PDF or Text Files")
                        .font(.title2)
                        .bold()
                    
                    Text("Import documents to your library to start reading with ReaDefine's adaptive features.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button(action: { showFileImporter = true }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Select File")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(15)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Upload")
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.pdf, .plainText],
                allowsMultipleSelection: false
            ) { result in
                handleUpload(result: result)
            }
        }
    }
    
    func handleUpload(result: Result<[URL], Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            
            if selectedFile.startAccessingSecurityScopedResource() {
                defer { selectedFile.stopAccessingSecurityScopedResource() }
                
                withAnimation { isUploading = true }
                
                let text = DocumentParser.extractText(from: selectedFile)
                
                fbManager.uploadDocument(url: selectedFile, text: text) { success in
                    withAnimation {
                        isUploading = false
                        if success {
                            showSuccessCheck = true
                            // Hide success check after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessCheck = false
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
