import Foundation

struct SampleData {
    static let exercises: [Exercise] = [
        Exercise(name: "Push-ups", sets: 3, reps: 12),
        Exercise(name: "Squats", sets: 4, reps: 15),
        Exercise(name: "Pull-ups", sets: 3, reps: 8),
        Exercise(name: "Lunges", sets: 3, reps: 12),
        Exercise(name: "Plank", sets: 3, reps: 1),
        Exercise(name: "Burpees", sets: 3, reps: 10),
        Exercise(name: "Mountain Climbers", sets: 3, reps: 20),
        Exercise(name: "Jumping Jacks", sets: 3, reps: 30)
    ]
    
    static var workouts: [Workout] = {
        let workoutOne = Workout(name: "Full Body Workout")
        let workoutTwo = Workout(name: "Cardio Blast")
        
        // Add exercises to workout one
        workoutOne.addExercise(exercises[0])  // Push-ups
        workoutOne.addExercise(exercises[2])  // Pull-ups
        workoutOne.addExercise(exercises[4])  // Plank
        
        return [workoutOne, workoutTwo]
    }()
    
    // Add sample challenge
    static let challenges: [Challenge] = [
        Challenge(
            name: "1 Week Challenge",
            workouts: [workouts[0], workouts[1], workouts[0]], // Full Body, Cardio Blast, Full Body
            startDate: Date(),
            durationDays: 7
        )
    ]
} 