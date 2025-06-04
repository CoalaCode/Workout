//
//  WorkoutApp.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import SwiftUI
import SwiftData

// The main app entry point that sets up the SwiftData model container and initializes the app's main view.
@main
struct WorkoutApp: App {
    // Creates and configures the SwiftData model container with all required model types
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            Challenge.self,
            ChallengeStat.self,
            ChallengeWorkout.self,
            Exercise.self,
            ExerciseStat.self,
            UserChallenge.self,
            Workout.self,
            WorkoutExercise.self,
            WorkoutStat.self, 
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
