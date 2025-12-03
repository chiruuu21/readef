//
//  Models.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import Foundation
import FirebaseFirestore

// Milestone 2 & 3: Document Metadata
struct ReadingDocument: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var fileURL: String
    var fileType: String // "pdf", "docx", "txt", "epub"
    var uploadDate: Date
    var extractedText: String? // Storing text for adaptive reading
    var currentPage: Int = 0
    var totalPages: Int = 0
    var userId: String
}

// Milestone 3: Theme Settings
struct ReadingSettings {
    var fontSize: CGFloat = 18.0
    var fontFamily: String = "San Francisco"
    var lineSpacing: CGFloat = 5.0
    var themeColor: ThemeColor = .system
    var isBold: Bool = false
}

enum ThemeColor: String, CaseIterable, Identifiable {
    case system = "System"
    case sepia = "Sepia"
    case night = "Night"
    case highContrast = "High Contrast"
    
    var id: String { self.rawValue }
}

struct UserStats: Codable {
    var totalReadingTime: TimeInterval = 0 // in seconds
    var booksCompleted: Int = 0
    var currentStreak: Int = 0
    var lastReadDate: Date?
}
