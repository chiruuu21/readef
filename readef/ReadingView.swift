//
//  ReadingView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI
import AVFoundation

struct ReadingView: View {
    let document: ReadingDocument
    @ObservedObject var fbManager = FirebaseManager.shared
    
    // Adaptive Settings (Milestone 3)
    @State private var settings = ReadingSettings()
    @State private var showSettings = false
    
    // TTS (Milestone 3)
    let synthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false
    
    var body: some View {
        ZStack {
            backgroundColor(for: settings.themeColor)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                Text(document.extractedText ?? "No content available")
                    .font(.custom(settings.fontFamily, size: settings.fontSize))
                    .lineSpacing(settings.lineSpacing)
                    .foregroundColor(textColor(for: settings.themeColor))
                    .padding()
            }
        }
        .navigationTitle(document.title)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: toggleTTS) {
                    Image(systemName: isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                }
                
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "textformat.size")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: $settings)
                .presentationDetents([.medium])
        }
        .onDisappear {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    // Helpers
    func toggleTTS() {
        if isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        } else {
            let utterance = AVSpeechUtterance(string: document.extractedText ?? "")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
            isSpeaking = true
        }
    }
    
    func backgroundColor(for theme: ThemeColor) -> Color {
        switch theme {
        case .sepia: return Color(red: 0.98, green: 0.95, blue: 0.85)
        case .night: return .black
        case .highContrast: return .yellow
        default: return .white
        }
    }
    
    func textColor(for theme: ThemeColor) -> Color {
        switch theme {
        case .night: return .white
        case .highContrast: return .black
        default: return .black
        }
    }
}

// Adaptive Settings UI
struct SettingsView: View {
    @Binding var settings: ReadingSettings
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: $settings.themeColor) {
                    ForEach(ThemeColor.allCases) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Typography")) {
                Stepper("Font Size: \(Int(settings.fontSize))", value: $settings.fontSize, in: 12...36)
                Stepper("Line Spacing: \(Int(settings.lineSpacing))", value: $settings.lineSpacing, in: 0...20)
                
                Picker("Font", selection: $settings.fontFamily) {
                    Text("San Francisco").tag("San Francisco")
                    Text("Serif").tag("Times New Roman")
                    Text("Monospaced").tag("Courier New")
                    // Milestone 3: Dyslexia friendly could be added here if you add the font file
                }
            }
        }
    }
}
