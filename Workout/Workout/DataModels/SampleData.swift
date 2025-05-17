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
    
    static let workouts: [Workout] = [
        Workout(
            name: "Full Body Workout",
            exercises: [exercises[0], exercises[1], exercises[2], exercises[3]],
            date: Date(),
            duration: 45 * 60,
        ),
        Workout(
            name: "Cardio Blast",
            exercises: [exercises[4], exercises[5], exercises[6], exercises[7]],
            date: Date().addingTimeInterval(-86400),
            duration: 30 * 60,
        )
    ]
    
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
