//
//  ContentView.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import SwiftUI
import SwiftData

// The root view of the app that manages the main tab-based navigation.
// This view organizes the app into three main sections:

struct ContentView: View {
    // Tracks the currently selected tab (0: Statistics, 1: Workouts, 2: Account)
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar")
                }
                .tag(0)
            
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.strengthtraining.traditional")
                }
                .tag(1)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Workout.self, Exercise.self, WorkoutExercise.self], inMemory: true)
}
