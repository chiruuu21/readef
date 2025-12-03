//
//  StatsView.swift
//  readef
//
//  Created by Chirag Dhungana on 12/3/25.
//

import SwiftUI

struct StatsView: View {
    // For a real app, you'd fetch this from Firestore.
    // For the demo, we can use state or dummy data.
    @State private var stats = UserStats(totalReadingTime: 12500, booksCompleted: 3, currentStreak: 5, lastReadDate: Date())

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Your Progress")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Stat Cards Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        StatCard(title: "Books Read", value: "\(stats.booksCompleted)", icon: "book.closed.fill", color: .blue)
                        StatCard(title: "Streak", value: "\(stats.currentStreak) Days", icon: "flame.fill", color: .orange)
                        StatCard(title: "Reading Time", value: formatTime(stats.totalReadingTime), icon: "clock.fill", color: .green)
                        StatCard(title: "Avg. Speed", value: "250 WPM", icon: "speedometer", color: .purple)
                    }
                    .padding()

                    // Weekly Activity Placeholder (Bar Chart style)
                    VStack(alignment: .leading) {
                        Text("Weekly Activity")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        HStack(alignment: .bottom, spacing: 10) {
                            ForEach(0..<7) { day in
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.blue.opacity(0.7))
                                        .frame(height: CGFloat.random(in: 20...100))
                                    Text(["M", "T", "W", "T", "F", "S", "S"][day])
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(height: 150)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding()
                }
            }
            .navigationTitle("Statistics")
        }
    }

    func formatTime(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval) ?? "0m"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            Text(value)
                .font(.title2)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
