//
//  StatsCardView.swift
//  Workout
//
//  Created by Max Schneider on 18.05.25.
//

import SwiftUI
import SwiftData
import Charts 

// Reusable Stats Card View
struct StatsCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let chartData: [DailyStat]? // Optional chart data

    private var sevenDayAverage: String {
        guard let data = chartData, data.count > 0 else { return "N/A" }
        let last7DaysData = data.suffix(7)
        let total = last7DaysData.reduce(0) { $0 + $1.count }
        return String(format: "%.0f", Double(total) / Double(last7DaysData.count))
    }
    
    private var todayValue: String {
        guard let data = chartData, let todayData = data.first(where: {Calendar.current.isDateInToday($0.date)}) else { return "N/A" }
        return "\(todayData.count)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: iconName)
                            .foregroundColor(iconColor)
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Text(value)
                        .font(.system(size: 34, weight: .bold))
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                // Optional: Add a small icon or chevron for navigation if card is tappable
            }

            if let data = chartData, !data.isEmpty {
                Chart(data.suffix(7)) { stat in // Display last 7 entries
                    BarMark(
                        x: .value("Tag", stat.weekdayString),
                        y: .value("Anzahl", stat.count)
                    )
                    .foregroundStyle(iconColor.gradient)
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks(preset: .automatic, values: .automatic(desiredCount: 3)) { value in
                         AxisGridLine()
                         AxisTick()
                         AxisValueLabel()
                    }
                }
                .frame(height: 100)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("HEUTE")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(todayValue)
                            .font(.title3).bold()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("7-TAGE Ø")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(sevenDayAverage)
                             .font(.title3).bold()
                    }
                }
                .padding(.top, 5)

            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground)) // Card background
        .cornerRadius(12)
    }
}

/*
struct StatsCardView: View {
    
    let exerciseStat: ExerciseStat
    
    var body: some View {
        NavigationLink(destination: StatsDetailView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text(exerciseStat.exercise?.name ?? "unknown")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "repeat")
                    Text("\(exerciseStat.sets) sets")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "figure.walk")
                    Text("\(exerciseStat.reps) reps")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 180, height: 140)
            .background(LinearGradient(gradient: Gradient(colors: [.cyan, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
        }
    }
}
*/
