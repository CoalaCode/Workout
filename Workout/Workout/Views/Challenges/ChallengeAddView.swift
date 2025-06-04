//
//  ChallengeAddView.swift
//  Workout
//
//  Created by Max Schneider on 27.05.25.
//

import SwiftUI
import SwiftData

struct ChallengeAddView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var workouts: [Workout]
    
    @State private var name = ""
    @State private var selectedCategory: Category?
    @State private var selectedWorkouts: [Workout] = []
    
    private var categories: [Category] {
        SampleData.category
    }
    
    private var allWorkouts: [Workout] {
        workouts + SampleData.workouts
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Challenge Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select a category").tag(nil as Category?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }
                }
                Section("Selected Workouts") {
                    ForEach(selectedWorkouts) { workout in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(workout.name)
                                .font(.headline)
                            
                        }
                    }
                    .onDelete { indexSet in
                        selectedWorkouts.remove(atOffsets: indexSet)
                    }
                }
                Section("Available Workouts") {
                    ForEach(allWorkouts) { workout in
                        if !selectedWorkouts.contains(where: { $0.id == workout.id }) {
                            Button {
                                selectedWorkouts.append(workout)
                            } label: {
                                HStack {
                                    Text(workout.name)
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChallenge()
                    }
                    .disabled(name.isEmpty || selectedWorkouts.isEmpty)
                }
            }
        }
    }
    
    private func saveChallenge() {
        let challenge = Challenge(
            name: name,
            startDate: Date(),
            category: selectedCategory ?? categories[0],
            imageName: "fitness",
            isSample: false
        )
        
        for workout in selectedWorkouts {
            challenge.addChallengeWorkout(workout)
        }
        
        modelContext.insert(challenge)
        dismiss()
    }
}

#Preview {
    ChallengeAddView()
}

// This function in line 48 in selected workouts under Text
/*
ForEach(workout.workoutExercises) { exercise in
    HStack {
        Text(exercise.name)
        Spacer()
        Text("\(exercise.sets) sets × \(exercise.reps) reps")
            .foregroundColor(.secondary)
    }
    .font(.subheadline)
}
*/
