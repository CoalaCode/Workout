//
//  StatsItemDetailView.swift
//  Workout
//
//  Created by Max Schneider on 03.06.25.
//

import SwiftUI
import SwiftData
import Charts

struct StatsItemDetailView: View {
    
    var exercises: [DailyStat] = []
    //var workouts: [Workout] = []
    //var challenges: [Challenge] = []
    
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
            
            Chart(filteredData) { stat in
                BarMark(
                    x: .value("Date", stat.date, unit: .day),
                    y: .value("Count", stat.count)
                )
            }
            .frame(height: 200)
            .padding()
            
            // Additional cards for each exercise can be added here
        }
        .navigationTitle("Exercise Details")
    }
}

#Preview {
    StatsItemDetailView()
}
