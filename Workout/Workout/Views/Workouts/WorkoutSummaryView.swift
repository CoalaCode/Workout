//
//  WorkoutSummaryView.swift
//  Workout
//
//  Created by Max Schneider on 23.05.25.
//

import SwiftUI
import SwiftData

/// A view that displays a summary of the completed workout
struct WorkoutSummaryView: View {
    // Input data
    let workout: Workout?
    let challengeWorkout: ChallengeWorkout?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Initializer for Workout
    init(workout: Workout) {
        self.workout = workout
        self.challengeWorkout = nil
    }
    
    // Initializer for ChallengeWorkout
    init(challengeWorkout: ChallengeWorkout) {
        self.challengeWorkout = challengeWorkout
        self.workout = nil
    }
    
    // Computed properties to handle optional values
    private var workoutName: String {
        return challengeWorkout?.name ?? workout?.name ?? "Unknown Workout"
    }
    
    private var exercises: [WorkoutExercise] {
        return challengeWorkout?.workoutExercises ?? workout?.workoutExercises ?? []
    }
    
    private var restTimeBetweenExercises: Int {
        return challengeWorkout?.restTimeBetweenExercises ?? workout?.restTimeBetweenExercises ?? 120
    }
    
    private var totalExercises: Int {
        return exercises.count
    }
    
    private var totalSets: Int {
        return exercises.reduce(0) { $0 + ($1.sets ?? 0) }
    }
    
    private var totalReps: Int {
        return exercises.reduce(0) { $0 + ($1.totalReps) }
    }
    
    private var estimatedDuration: Int {
        // Calculate estimated duration based on exercises and rest periods
        let exerciseTime = totalSets * 60 // Assuming 1 minute per set
        let restTime = (totalExercises - 1) * restTimeBetweenExercises // Rest between exercises
        return exerciseTime + restTime
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Workout Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(workoutName)
                .font(.title)
                .fontWeight(.semibold)
            
            // Statistics Section
            VStack(spacing: 15) {
                StatRow(title: "Total Exercises", value: "\(totalExercises)")
                StatRow(title: "Total Sets", value: "\(totalSets)")
                StatRow(title: "Total Reps", value: "\(totalReps)")
                StatRow(title: "Estimated Duration", value: formatDuration(estimatedDuration))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            
            // Exercises List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(exercises) { workoutExercise in
                        ExerciseSummaryRow(workoutExercise: workoutExercise)
                    }
                }
            }
            
            Spacer()
            
            Button("Done") {
                saveStat()
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.bottom)
        }
        .padding()
    }
    
    /// Saves the completed workout's statistics to the database
    private func saveStat() {
        if let workout = workout {
            let stat = WorkoutStat(
                workout: workout
            )
            modelContext.insert(stat)
        } else if let challengeWorkout = challengeWorkout {
            let stat = WorkoutStat(
                challengeWorkout: challengeWorkout
            )
            modelContext.insert(stat)
        }
    }
    
    /// Formats duration in seconds to a readable string (e.g., "15m 30s")
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes)m \(remainingSeconds)s"
    }
}

/// A view that displays a single row of statistics
struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

/// A view that displays a summary row for a single exercise
struct ExerciseSummaryRow: View {
    let workoutExercise: WorkoutExercise
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workoutExercise.name ?? "Unknown Exercise")
                    .font(.headline)
            }
            
            HStack {
                Text("\(workoutExercise.sets ?? 0) sets × \(workoutExercise.reps ?? 0) reps")
                Spacer()
                Text("Total: \(workoutExercise.totalReps)")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


