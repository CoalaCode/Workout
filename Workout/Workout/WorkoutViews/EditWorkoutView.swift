import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let workout: Workout
    @State private var name: String
    @State private var duration: TimeInterval
    @State private var selectedExercises: Set<Exercise>
    
    init(workout: Workout) {
        self.workout = workout
        _name = State(initialValue: workout.name)
        _duration = State(initialValue: workout.duration)
        _selectedExercises = State(initialValue: Set(workout.exercises))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Workout Name", text: $name)
                    
                    HStack {
                        Text("Duration")
                        Spacer()
                        TextField("Minutes", value: $duration, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Exercises") {
                    ForEach(Array(selectedExercises)) { exercise in
                        HStack {
                            Text(exercise.name)
                            Spacer()
                            Text("\(exercise.sets) sets × \(exercise.reps) reps")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        let exercises = Array(selectedExercises)
                        indexSet.forEach { index in
                            selectedExercises.remove(exercises[index])
                        }
                    }
                    
                    NavigationLink("Add Exercise") {
                        ExerciseSelectionView(selectedExercises: $selectedExercises)
                    }
                }
            }
            .navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(name.isEmpty || selectedExercises.isEmpty)
                }
            }
        }
    }
    
    private func saveWorkout() {
        workout.name = name
        workout.duration = duration
        workout.exercises = Array(selectedExercises)
        dismiss()
    }
}

struct ExerciseSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    @Binding var selectedExercises: Set<Exercise>
    
    var body: some View {
        List {
            ForEach(exercises + SampleData.exercises) { exercise in
                Button {
                    if selectedExercises.contains(exercise) {
                        selectedExercises.remove(exercise)
                    } else {
                        selectedExercises.insert(exercise)
                    }
                } label: {
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        if selectedExercises.contains(exercise) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Exercises")
    }
} 
