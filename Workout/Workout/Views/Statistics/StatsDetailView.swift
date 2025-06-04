//
//  StatsDetailView.swift
//  Workout
//
//  Created by Max Schneider on 18.05.25.
//

import SwiftUI
import Charts

struct StatsDetailView: View {
    var exercises: [DailyStat] = []
    var workouts: [DailyStat] = []
    
    @State private var selectedTimeFrame: TimeFrame = .day
    
    var filteredData: [DailyStat] {
        // Filter data based on selectedTimeFrame
        switch selectedTimeFrame {
        case .day:
            return exercises
        case .week:
            return exercises // Implement week filtering logic
        case .month:
            return exercises // Implement month filtering logic
        case .year:
            return exercises // Implement year filtering logic
        }
    }
    
    var body: some View {
        VStack {
            Picker("Time Frame", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases, id: \ .self) { timeFrame in
                    Text(timeFrame.rawValue.capitalized).tag(timeFrame)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Main Chart for all exercises
            Chart(filteredData) { stat in
                BarMark(
                    x: .value("Date", stat.date, unit: .day),
                    y: .value("Count", stat.count)
                )
            }
            .frame(height: 200)
            .padding()
            
            // Cards for each exercise type
            ScrollView {
                ForEach(exercises) { exercise in
                    NavigationLink(destination: StatsItemDetailView(exercises: [exercise])) {
                        StatItemCardView(exercise: exercise)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Exercise Statistics")
    }
}

struct StatItemCardView: View {
    var exercise: DailyStat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Exercise Name") // Replace with actual exercise name
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.headline)
            
            Divider()
            
            HStack {
                Text("Today:")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text("\(exercise.count)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            // Add a small bar chart for hourly activity
            Chart {
                // Example data, replace with actual hourly data
                ForEach(0..<24, id: \.self) { hour in
                    BarMark(
                        x: .value("Hour", hour),
                        y: .value("Reps", Int.random(in: 0...10))
                    )
                }
            }
            .frame(width: .infinity, height: 50)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

enum TimeFrame: String, CaseIterable {
    case day, week, month, year
}
