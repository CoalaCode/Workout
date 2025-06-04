import SwiftUI
import SwiftData

struct WorkoutAddView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var exercises: [Exercise]
    let isChallengeWorkout: Bool = false
    
    @State private var name = ""
    @State private var selectedCategory: Category?
    @State private var selectedExercises: [Exercise] = []
    @State private var customSets: [PersistentIdentifier: Int] = [:]
    @State private var customReps: [PersistentIdentifier: Int] = [:]
    //@State private var duration: TimeInterval = 0
    
    private var categories: [Category] {
        SampleData.category
    }
    
    private var allExercises: [Exercise] {
        exercises + SampleData.exercises
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
            .navigationTitle("Add Workout")
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
        if isChallengeWorkout == false {
            let workout = Workout(name: name, restTimeBetweenExercises: 120, category: selectedCategory, imageName: "fitness", isSample: false)
            modelContext.insert(workout)
            
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
        } else {
            let workout = Workout(name: name, restTimeBetweenExercises: 120, category: selectedCategory, imageName: "fitness", isSample: false)
            
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
            //challenge?.addChallengeWorkout(workout)
        }
        
        
        try? modelContext.save()
        dismiss()
    }
} 

