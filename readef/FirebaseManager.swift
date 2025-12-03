//
//  FirebaseManager.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @Published var currentUser: User?
    
    init() {
        self.currentUser = auth.currentUser
    }
    
    // Auth
    func listenToAuthState() {
        auth.addStateDidChangeListener { _, user in
            self.currentUser = user
        }
    }
    
    func uploadDocument(url: URL, text: String, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUser?.uid else { return }
        
        let filename = "\(UUID().uuidString).\(url.pathExtension)"
        let ref = storage.reference().child("documents/\(userId)/\(filename)")
        
        // 1. Upload File
        ref.putFile(from: url, metadata: nil) { _, error in
            if let error = error {
                print("Upload error: \(error)")
                completion(false)
                return
            }
            
            // 2. Get Download URL
            ref.downloadURL { downloadURL, _ in
                guard let downloadURL = downloadURL else { completion(false); return }
                
                // 3. Save Metadata to Firestore
                let doc = ReadingDocument(
                    title: url.lastPathComponent,
                    fileURL: downloadURL.absoluteString,
                    fileType: url.pathExtension.lowercased(),
                    uploadDate: Date(),
                    extractedText: text,
                    userId: userId
                )
                
                do {
                    try self.db.collection("documents").addDocument(from: doc)
                    completion(true)
                } catch {
                    print("Firestore error: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    
    func updateProgress(docId: String, page: Int) {
        db.collection("documents").document(docId).updateData([
            "currentPage": page
        ])
    }
}
