//
//  WorkoutAllCardView.swift
//  Workout
//
//  Created by Max Schneider on 21.05.25.
//

import SwiftUI

struct WorkoutAllCardView: View {
    
    let workout: Workout?
    let challengeWorkout: ChallengeWorkout?
    
    // Initializer for regular Workout
    init(workout: Workout) {
        self.workout = workout
        self.challengeWorkout = nil
    }
    
    // Initializer for ChallengeWorkout
    init(challengeWorkout: ChallengeWorkout) {
        self.workout = nil
        self.challengeWorkout = challengeWorkout
    }
    
    // Computed properties to handle optional values
    private var workoutName: String {
        return workout?.name ?? challengeWorkout?.name ?? "Unknown Workout"
    }
    
    private var amountOfExercises: Int {
        return workout?.workoutExercises.count ?? challengeWorkout?.workoutExercises.count ?? 0
    }
    
    private var restTime: Int {
        return workout?.restTimeBetweenExercises ?? challengeWorkout?.restTimeBetweenExercises ?? 0
    }
    
    private var destinationView: some View {
        if let workout = workout {
            return AnyView(WorkoutDetailView(workout: workout))
        } else if let challengeWorkout = challengeWorkout {
            return AnyView(WorkoutDetailView(challengeWorkout: challengeWorkout))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: destinationView) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(workoutName)
                        .font(.headline)
                        .foregroundColor(.white)
                        
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.white)
                        Text("Exercises: \(amountOfExercises)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Image(systemName: "figure.walk")
                            .foregroundColor(.white)
                        Text("Rest time: \(restTime) seconds")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}

