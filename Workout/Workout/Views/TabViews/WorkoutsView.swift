//
//  WorkoutListView.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//
// The main view of the app that displays workouts, exercises, and challenges.
// This view is organized into several sections:
// - Today: Shows the next workout from active challenges
// - All Workouts: Displays available workout templates
// - All Exercises: Shows individual exercises
// - Available Challenges: Lists challenge templates users can start
// - Your Challenges: Shows the user's active challenges

import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    @Query private var exercises: [Exercise]
    @Query private var challenges: [Challenge] // Template challenges
    @Query private var userChallenges: [UserChallenge] // User's active challenges
    @State private var searchText = ""
    @State private var selectedWorkoutCategory: Category?
    @State private var selectedChallengeCategory: Category?
    @State private var selectedExerciseCategory: Category?
    @State private var showStartChallengeAlert = false
    //@State private var challengeToStart: Challenge?
    //@State private var createdUserChallenge: UserChallenge?
    //@State private var navigateToUserChallenge = false
    
    var filteredExerciseCategories: [Category] {
        let allCategories = SampleData.category
        if searchText.isEmpty {
            return allCategories
        }
        return allCategories.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
    }
    
    var filteredWorkoutCategories: [Category] {
        let allCategories = SampleData.category
        if searchText.isEmpty {
            return allCategories
        }
        return allCategories.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
    }
    
    // Returns all exercises, including sample data, filtered by search text
    var filteredExercises: [Exercise] {
        let allExercises = exercises + SampleData.exercises
        var filtered = allExercises
        
        // Apply category filter if a category is selected
        if let selectedCategory = selectedExerciseCategory {
            filtered = filtered.filter { $0.category?.name == selectedCategory.name }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    // Returns all workouts, including sample data, filtered by search text
    var filteredWorkouts: [Workout] {
        let allWorkouts = workouts + SampleData.workouts
        var filtered = allWorkouts
        
        //Apply category filter if category is selected
        if let selectedCategory = selectedWorkoutCategory {
            filtered = filtered.filter { $0.category?.name == selectedCategory.name }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
        return filtered
    }
    
    // Returns all challenges, including sample data, filtered by search text
    var filteredChallenges: [Challenge] {
        let allChallenges = challenges + SampleData.challenges
        var filtered = allChallenges
        
        // Apply category filter if category is selected
        if let selectedCategory = selectedChallengeCategory {
            filtered = filtered.filter { $0.category?.name == selectedCategory.name }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    
    
    // Returns all challenges, including sample data, filtered by search text
    var filteredUserChallenges: [UserChallenge] {
        let allUserChallenges = userChallenges
        var filtered = allUserChallenges
        
        // Apply category filter if category is selected
        if let selectedCategory = selectedChallengeCategory {
            filtered = filtered.filter { $0.category?.name == selectedCategory.name }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    
    // Finds the next incomplete workout from any active challenge
    // Returns an array of tuples containing the challenge and the next workout to complete
    var nextUserChallengeWorkout: [(Challenge, ChallengeWorkout)] {
        var result: [(Challenge, ChallengeWorkout)] = []
        for challenge in filteredChallenges {
            guard !challenge.challengeWorkouts.isEmpty else { continue }
            // Find the first workout that hasn't been completed
            for (index, challengeWorkout) in challenge.challengeWorkouts.enumerated() {
                let completionID = "\(challengeWorkout.uuid)-\(index)"
                if !challenge.completedWorkoutIDs.contains(completionID) {
                    result.append((challenge, challengeWorkout))
                    break // Only add the next incomplete workout for each challenge
                }
            }
        }
        return result
    }
     
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Today Section (UserChallenge)
                    if !nextUserChallengeWorkout.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Today")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(nextUserChallengeWorkout, id: \.0.id) { challenge, workout in
                                        TodayCardView(challenge: challenge, workout: workout)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    // All Workouts Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("All Workouts")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: WorkoutAllView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Add "All" category option
                                Button(action: {
                                    selectedWorkoutCategory = nil
                                }) {
                                    VStack {
                                        Text("All")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 132, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(selectedWorkoutCategory == nil ? Color.green : Color.gray.opacity(0.2))
                                    )
                                }
                                
                                ForEach(filteredWorkoutCategories) { category in
                                    Button(action: {
                                        selectedWorkoutCategory = category
                                    }) {
                                        VStack {
                                            Text("\(category.name)")
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 132, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(selectedWorkoutCategory?.name == category.name ? Color.green : Color.gray.opacity(0.2))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredWorkouts) { workout in
                                    WorkoutCardView(workout: workout)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // All Exercises Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("All Exercises")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: ExerciseAllView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Add "All" category option
                                Button(action: {
                                    selectedExerciseCategory = nil
                                }) {
                                    VStack {
                                        Text("All")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 132, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(selectedExerciseCategory == nil ? Color.blue : Color.gray.opacity(0.2))
                                    )
                                }
                                
                                ForEach(filteredExerciseCategories) { category in
                                    Button(action: {
                                        selectedExerciseCategory = category
                                    }) {
                                        VStack {
                                            Text("\(category.name)")
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 132, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(selectedExerciseCategory?.name == category.name ? Color.blue : Color.gray.opacity(0.2))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredExercises) { exercise in
                                    ExerciseCardView(exercise: exercise)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // All Challenges Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("All Challenges")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: ChallengeAllView()) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Add "All" category option
                                Button(action: {
                                    selectedChallengeCategory = nil
                                }) {
                                    VStack {
                                        Text("All")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 132, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(selectedChallengeCategory == nil ? Color.purple : Color.gray.opacity(0.2))
                                    )
                                }
                                
                                ForEach(filteredExerciseCategories) { category in
                                    Button(action: {
                                        selectedChallengeCategory = category
                                    }) {
                                        VStack {
                                            Text(category.name)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 132, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(selectedChallengeCategory?.name == category.name ? Color.purple : Color.gray.opacity(0.2))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredChallenges) { challenge in
                                    ChallengeCardView(challenge: challenge)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
            .navigationTitle("Workouts")
        }
        .searchable(text: $searchText, prompt: "Search workouts")
    }
        
}
/*
#Preview {
    WorkoutsView()
        .modelContainer(for: [Workout.self, Exercise.self, UserChallenge.self], inMemory: true)
}
*/

/*
// User's Active Challenges Section
if !nextUserChallengeWorkout.isEmpty {
    VStack(alignment: .leading, spacing: 16) {
        HStack {
            Text("Your Challenges")
                .font(.title2)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(filteredUserChallenges) { userChallenge in
                    NavigationLink(destination: ChallengeDetailView(challenge: userChallenge)) {
                        ChallengeCardView(challenge: userChallenge)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
 */
