//
//  WorkoutListView.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    @Query private var exercises: [Exercise]
    @Query private var challenges: [Challenge]
    @State private var searchText = ""
    
    var filteredWorkouts: [Workout] {
        let allWorkouts = workouts + SampleData.workouts
        if searchText.isEmpty {
            return allWorkouts
        }
        return allWorkouts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredExercises: [Exercise] {
        let allExercises = exercises + SampleData.exercises
        if searchText.isEmpty {
            return allExercises
        }
        return allExercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredChallenges: [Challenge] {
        let allChallenges = challenges + SampleData.challenges
        if searchText.isEmpty {
            return allChallenges
        }
        return allChallenges.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var nextChallengeWorkout: (Challenge, Workout)? {
        let today = Calendar.current.startOfDay(for: Date())
        for challenge in challenges {
            let daysSinceStart = Calendar.current.dateComponents([.day], from: challenge.startDate, to: today).day ?? 0
            if daysSinceStart < challenge.durationDays {
                let workoutIndex = daysSinceStart % challenge.workouts.count
                let nextWorkout = challenge.workouts[workoutIndex]
                if !challenge.completedWorkoutIDs.contains(nextWorkout.uuid) {
                    return (challenge, nextWorkout)
                }
            }
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 24) {
                    // Today Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Today")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: AllWorkoutsView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        if let (challenge, workout) = nextChallengeWorkout {
                            VStack(alignment: .leading) {
                                Text("Next Challenge Workout: \(challenge.name)")
                                    .font(.headline)
                                Text("Workout: \(workout.name)")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                    
                    // All Workouts Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("All Workouts")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: AllWorkoutsView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredWorkouts) { workout in
                                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                        WorkoutCardView(workout: workout)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // All Exercises Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("All Exercises")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: AllExercisesView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredExercises) { exercise in
                                    ExerciseCardView(exercise: exercise)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Challenges Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Challenges")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: AllChallengesView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredChallenges) { challenge in
                                    NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                                        ChallengeCardView(challenge: challenge)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Workouts")
            .searchable(text: $searchText, prompt: "Search workouts")
        }
    }
}

#Preview {
    WorkoutsView()
        .modelContainer(for: [Workout.self, Exercise.self], inMemory: true)
}
