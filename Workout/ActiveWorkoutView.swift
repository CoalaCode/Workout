import SwiftUI

struct ActiveWorkoutView: View {
    // ... existing code ...
    
    private func saveExerciseStat() {
        let stat = ExerciseStat(
            exerciseName: currentWorkoutExercise.name,
            date: Date(),
            sets: currentWorkoutExercise.effectiveSets,
            reps: currentWorkoutExercise.effectiveRepsPerSet,
            totalReps: currentWorkoutExercise.totalReps
        )
        modelContext.insert(stat)
    }
    
    // ... rest of the code ...
} 