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
    
    // Settings
    @State private var fontSize: CGFloat = 18
    @State private var lineSpacing: CGFloat = 8
    @State private var fontFamily: String = "System"
    @State private var themeColor: Color = .white
    @State private var textColor: Color = .black
    
    // TTS
    let synthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false
    
    // UI State
    @State private var showSettings = false

    var body: some View {
        ZStack {
            themeColor.ignoresSafeArea()
            
            VStack {
                // Custom Toolbar for TTS
                HStack {
                    Spacer()
                    Button(action: toggleTTS) {
                        Image(systemName: isSpeaking ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                
                ScrollView {
                    Text(document.extractedText ?? "No content.")
                        .font(.system(size: fontSize, design: getFontDesign()))
                        .lineSpacing(lineSpacing)
                        .foregroundColor(textColor)
                        .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "textformat.size")
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            ReadingSettingsSheet(
                fontSize: $fontSize,
                lineSpacing: $lineSpacing,
                fontFamily: $fontFamily,
                themeColor: $themeColor,
                textColor: $textColor
            )
            .presentationDetents([.medium, .large])
        }
        .onDisappear {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func toggleTTS() {
        if isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            isSpeaking = false
        } else {
            if synthesizer.isPaused {
                synthesizer.continueSpeaking()
            } else {
                let utterance = AVSpeechUtterance(string: document.extractedText ?? "")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                synthesizer.speak(utterance)
            }
            isSpeaking = true
        }
    }
    
    func getFontDesign() -> Font.Design {
        switch fontFamily {
        case "Serif": return .serif
        case "Monospaced": return .monospaced
        default: return .default
        }
    }
}

struct ReadingSettingsSheet: View {
    @Binding var fontSize: CGFloat
    @Binding var lineSpacing: CGFloat
    @Binding var fontFamily: String
    @Binding var themeColor: Color
    @Binding var textColor: Color
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    Stepper("Font Size: \(Int(fontSize))", value: $fontSize, in: 12...32)
                    Stepper("Line Spacing: \(Int(lineSpacing))", value: $lineSpacing, in: 0...20)
                }
                
                Section(header: Text("Font Style")) {
                    Picker("Font", selection: $fontFamily) {
                        Text("System").tag("System")
                        Text("Serif").tag("Serif")
                        Text("Monospaced").tag("Monospaced")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Theme")) {
                    HStack(spacing: 20) {
                        ThemeButton(color: .white, text: .black, name: "Light", action: setTheme)
                        ThemeButton(color: Color(red: 0.96, green: 0.93, blue: 0.88), text: .black, name: "Sepia", action: setTheme)
                        ThemeButton(color: .black, text: .white, name: "Dark", action: setTheme)
                    }
                }
            }
            .navigationTitle("Reading Settings")
        }
    }
    
    func setTheme(bg: Color, txt: Color) {
        themeColor = bg
        textColor = txt
    }
}

struct ThemeButton: View {
    let color: Color
    let text: Color
    let name: String
    let action: (Color, Color) -> Void
    
    var body: some View {
        Button(action: { action(color, text) }) {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .overlay(Text("Aa").foregroundColor(text).font(.caption))
        }
    }
}
