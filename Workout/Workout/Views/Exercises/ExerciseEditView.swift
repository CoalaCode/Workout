import SwiftUI
import SwiftData

struct ExerciseEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let exercise: Exercise?
    let workoutExercise: WorkoutExercise?
    
    @State private var name: String
    @State private var sets: Int
    @State private var reps: Int
    @State private var selectedCategory: Category?
    
    // Remove @Query and only use sample categories
    private var categories: [Category] {
        SampleData.category
    }
    
    // Computed properties
    private var exerciseName: String {
        return workoutExercise?.name ?? exercise?.name ?? "Unknown Exercise"
    }
    
    private var effectiveSets: Int {
        return workoutExercise?.sets ?? exercise?.sets ?? 0
    }
    
    private var effectiveReps: Int {
        return workoutExercise?.reps ?? exercise?.reps ?? 0
    }
    
    // Initializer for Exercise
    init(exercise: Exercise) {
        self.exercise = exercise
        self.workoutExercise = nil
        _name = State(initialValue: exercise.name)
        _sets = State(initialValue: exercise.sets)
        _reps = State(initialValue: exercise.reps)
        // Find matching sample category if one exists
        _selectedCategory = State(initialValue: exercise.category.map { category in
            SampleData.category.first { $0.name == category.name }
        } ?? nil)
    }
    
    // Initializer for WorkoutExercise
    init(workoutExercise: WorkoutExercise) {
        self.workoutExercise = workoutExercise
        self.exercise = nil
        _name = State(initialValue: workoutExercise.name ?? "Unknown")
        _sets = State(initialValue: workoutExercise.sets ?? 0)
        _reps = State(initialValue: workoutExercise.reps ?? 0)
        // Find matching sample category if one exists
        _selectedCategory = State(initialValue: workoutExercise.category.map { category in
            SampleData.category.first { $0.name == category.name }
        } ?? nil)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Exercise Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select a category").tag(nil as Category?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }
                    
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    
                    Stepper("Reps: \(reps)", value: $reps, in: 1...100)
                }
            }
            .navigationTitle("Edit Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExercise()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveExercise() {
        if let exercise = exercise {
            // Update existing Exercise
            exercise.name = name
            exercise.sets = sets
            exercise.reps = reps
            exercise.category = selectedCategory!
        } else if let workoutExercise = workoutExercise {
            // Update existing WorkoutExercise
            workoutExercise.name = name
            workoutExercise.sets = sets
            workoutExercise.reps = reps
            workoutExercise.category = selectedCategory
        }
        
        try? modelContext.save()
        dismiss()
    }
} 
