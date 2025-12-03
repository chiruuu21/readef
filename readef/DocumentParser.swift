//
//  DocumentParser.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import Foundation
import PDFKit

class DocumentParser {
    
    static func extractText(from url: URL) -> String {
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "txt":
            return (try? String(contentsOf: url, encoding: .utf8)) ?? "Could not read text."
            
        case "pdf":
            return extractPDF(url: url)
            
        case "epub":
            return "EPUB parsing requires third-party library (e.g., EPUBKit). Displaying raw text placeholder."
            
        case "docx":
            return "DOCX parsing requires XML parsing. Displaying raw text placeholder."
            
        default:
            return "Unsupported format"
        }
    }
    
    private static func extractPDF(url: URL) -> String {
        guard let pdf = PDFDocument(url: url) else { return "" }
        var fullText = ""
        let pageCount = pdf.pageCount
        
        for i in 0..<pageCount {
            guard let page = pdf.page(at: i) else { continue }
            fullText += (page.string ?? "") + "\n\n"
        }
        return fullText
    }
}
