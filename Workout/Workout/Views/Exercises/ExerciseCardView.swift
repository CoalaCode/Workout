import SwiftUI

struct ExerciseCardView: View {
    
    let exercise: Exercise?
    let workoutExercise: WorkoutExercise?
    let width: CGFloat?
    
    init(exercise: Exercise? = nil, width: CGFloat? = 150) {
        self.exercise = exercise
        self.workoutExercise = nil
        self.width = width
    }
    
    init(workoutExercise: WorkoutExercise?, width: CGFloat? = 150) {
        self.exercise = nil
        self.workoutExercise = workoutExercise
        self.width = width
    }
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
    
    private var destinationView: some View {
        if let exercise = exercise {
            return AnyView(ExerciseDetailView(exercise: exercise))
        } else if let workoutExercise = workoutExercise {
            return AnyView(ExerciseDetailView(workoutExercise: workoutExercise))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: destinationView) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(exerciseName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.white)
                        Text("\(effectiveSets) sets")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "figure.walk")
                            .foregroundColor(.white)
                        Text("\(effectiveReps) reps")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(width: width, height: 120)
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
            }
        }
    }
} 
