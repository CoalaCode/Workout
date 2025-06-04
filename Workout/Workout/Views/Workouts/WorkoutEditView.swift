import SwiftUI
import SwiftData

struct WorkoutEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let workout: Workout?
    let challengeWorkout: ChallengeWorkout?
    
    @Query private var exercises: [Exercise]
    
    @State private var name = ""
    @State private var selectedCategory: Category?
    @State private var selectedExercises: [Exercise] = []
    @State private var customSets: [PersistentIdentifier: Int] = [:]
    @State private var customReps: [PersistentIdentifier: Int] = [:]
    
    private var categories: [Category] {
        SampleData.category
    }
    
    private var allExercises: [Exercise] {
        exercises + SampleData.exercises
    }
    
    private var workoutName: String {
        return workout?.name ?? challengeWorkout?.name ?? "Unknown Workout"
    }
    
    private var existingWorkoutExercises: [WorkoutExercise] {
        workout?.workoutExercises ?? challengeWorkout?.workoutExercises ?? []
    }
    
    // Initializer for Workout
    init(workout: Workout) {
        self.workout = workout
        self.challengeWorkout = nil
        _name = State(initialValue: workout.name)
        _selectedCategory = State(initialValue: workout.category)
        
        // Initialize selected exercises and their custom sets/reps from existing WorkoutExercises
        var initialExercises: [Exercise] = []
        var initialSets: [PersistentIdentifier: Int] = [:]
        var initialReps: [PersistentIdentifier: Int] = [:]
        
        for workoutExercise in workout.workoutExercises {
            let exercise = Exercise(
                name: workoutExercise.name ?? "",
                sets: workoutExercise.sets ?? 0,
                reps: workoutExercise.reps ?? 0,
                category: workoutExercise.category,
                imageName: "fitness",
                isSample: false
            )
            initialExercises.append(exercise)
            initialSets[exercise.id] = workoutExercise.sets
            initialReps[exercise.id] = workoutExercise.reps
        }
        
        _selectedExercises = State(initialValue: initialExercises)
        _customSets = State(initialValue: initialSets)
        _customReps = State(initialValue: initialReps)
    }
    
    // Initializer for ChallengeWorkout
    init(challengeWorkout: ChallengeWorkout) {
        self.challengeWorkout = challengeWorkout
        self.workout = nil
        _name = State(initialValue: challengeWorkout.name)
        _selectedCategory = State(initialValue: challengeWorkout.category)
        
        // Initialize selected exercises and their custom sets/reps from existing WorkoutExercises
        var initialExercises: [Exercise] = []
        var initialSets: [PersistentIdentifier: Int] = [:]
        var initialReps: [PersistentIdentifier: Int] = [:]
        
        for workoutExercise in challengeWorkout.workoutExercises {
            let exercise = Exercise(
                name: workoutExercise.name ?? "",
                sets: workoutExercise.sets ?? 0,
                reps: workoutExercise.reps ?? 0,
                category: workoutExercise.category,
                imageName: "fitness",
                isSample: false
            )
            initialExercises.append(exercise)
            initialSets[exercise.id] = workoutExercise.sets
            initialReps[exercise.id] = workoutExercise.reps
        }
        
        _selectedExercises = State(initialValue: initialExercises)
        _customSets = State(initialValue: initialSets)
        _customReps = State(initialValue: initialReps)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Workout Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select a category").tag(nil as Category?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }
                }
                
                Section("Current Exercises") {
                    ForEach(selectedExercises) { exercise in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(exercise.name)
                            
                            HStack {
                                Stepper("Sets: \(customSets[exercise.id] ?? exercise.sets)", value: Binding(
                                    get: { customSets[exercise.id] ?? exercise.sets },
                                    set: { customSets[exercise.id] = $0 }
                                ), in: 1...20)
                                
                                Stepper("Reps: \(customReps[exercise.id] ?? exercise.reps)", value: Binding(
                                    get: { customReps[exercise.id] ?? exercise.reps },
                                    set: { customReps[exercise.id] = $0 }
                                ), in: 1...100)
                            }
                            .font(.caption)
                        }
                    }
                    .onDelete { indexSet in
                        selectedExercises.remove(atOffsets: indexSet)
                    }
                }
                
                Section("Add Exercises") {
                    ForEach(allExercises) { exercise in
                        if !selectedExercises.contains(where: { $0.id == exercise.id }) {
                            Button {
                                selectedExercises.append(exercise)
                                customSets[exercise.id] = exercise.sets
                                customReps[exercise.id] = exercise.reps
                            } label: {
                                HStack {
                                    Text(exercise.name)
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
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
        if let workout = workout {
            // Update existing Workout
            workout.name = name
            workout.category = selectedCategory
            workout.removeAllExercises()
            
            for (index, exercise) in selectedExercises.enumerated() {
                let workoutExercise = WorkoutExercise(
                    name: exercise.name,
                    workout: workout,
                    sets: customSets[exercise.id] ?? exercise.sets,
                    reps: customReps[exercise.id] ?? exercise.reps,
                    order: index,
                    category: exercise.category,
                    imageName: "fitness",
                    isSample: false
                )
                workout.addWorkoutExercise(workoutExercise)
            }
        } else if let challengeWorkout = challengeWorkout {
            // Update existing ChallengeWorkout
            challengeWorkout.name = name
            challengeWorkout.category = selectedCategory
            challengeWorkout.removeAllExercises()
            
            for (index, exercise) in selectedExercises.enumerated() {
                let workoutExercise = WorkoutExercise(
                    name: exercise.name,
                    challengeWorkout: challengeWorkout,
                    sets: customSets[exercise.id] ?? exercise.sets,
                    reps: customReps[exercise.id] ?? exercise.reps,
                    order: index,
                    category: exercise.category,
                    imageName: "fitness",
                    isSample: false
                )
                challengeWorkout.addWorkoutExercise(workoutExercise)
            }
        }
        
        try? modelContext.save()
        dismiss()
    }
}

/*
struct ExerciseSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    @Binding var selectedExercises: [Exercise]
    
    var body: some View {
        List {
            ForEach(exercises + SampleData.exercises) { exercise in
                Button {
                    if selectedExercises.contains(where: { $0.id == exercise.id }) {
                        selectedExercises.removeAll { $0.id == exercise.id }
                    } else {
                        selectedExercises.append(exercise)
                    }
                } label: {
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        if selectedExercises.contains(where: { $0.id == exercise.id }) {
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


*/
