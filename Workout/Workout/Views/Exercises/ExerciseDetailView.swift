import SwiftUI

struct ExerciseDetailView: View {
    
    let exercise: Exercise?
    let workoutExercise: WorkoutExercise?
    
    @State private var isActiveExecise = false
    @State private var showingEditSheet = false
    
    // Computed properties to handle optional values
    private var exerciseName: String {
        return workoutExercise?.name ?? exercise?.name ?? "Unknown Exercise"
    }
    
    private var effectiveSets: Int {
        return workoutExercise?.sets ?? exercise?.sets ?? 0
    }
    
    private var effectiveReps: Int {
        return workoutExercise?.reps ?? exercise?.reps ?? 0
    }
    
    private var image: String {
        return workoutExercise?.imageName ?? exercise?.imageName ?? "Unknown"
    }
    
    // Initializer for Exercise
    init(exercise: Exercise) {
        self.exercise = exercise
        self.workoutExercise = nil
    }
    
    // Initializer for WorkoutExercise
    init(workoutExercise: WorkoutExercise) {
        self.workoutExercise = workoutExercise
        self.exercise = nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    // Header
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                        .clipped()
                    //Data
                    VStack(alignment: .leading, spacing: 16) {
                        Text(exerciseName)
                            .font(.title)
                            .bold()
                        
                        HStack {
                            Image(systemName: "repeat")
                                .foregroundColor(.blue)
                            Text("\(effectiveSets) sets")
                                .font(.headline)
                        }
                        
                        HStack {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.blue)
                            Text("\(effectiveReps) reps")
                                .font(.headline)
                        }
                        HStack {
                            Text("Category: ")
                            Text(workoutExercise?.category?.name ?? exercise?.category?.name ?? "Uncategorized")
                                .font(.headline)
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Description:")
                                .font(.headline)
                                .bold()
                            Text("Lorep ipsum balw dajndsa mogekas pqomdasb feksnas kmdasnd! Wignwalg dsdw,almoeng, algeiwin.")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    // Add padding at the bottom to account for the fixed button
                    Spacer()
                        .frame(height: 80)
                }
                .ignoresSafeArea()
                Spacer()
                // Start Exercise Button
                VStack {
                    Button(action: {
                        isActiveExecise = true
                    }) {
                        Text("Start Exercise")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .padding(.top, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !SampleData.exercises.contains(where: { $0.id == exercise?.id}) {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingEditSheet = true
                        } label: {
                            Text("Edit")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingEditSheet) {
                if let exercise = exercise {
                    ExerciseEditView(exercise: exercise)
                } else if let workoutExercise = workoutExercise {
                    ExerciseEditView(workoutExercise: workoutExercise)
                }
            }
            .navigationDestination(isPresented: $isActiveExecise) {
                if let exercise = exercise {
                    ExerciseActiveView(exercise: exercise)
                } else if let workoutExercise = workoutExercise {
                    ExerciseActiveView(workoutExercise: workoutExercise)
                }
            }
        }
    }
}
