import Foundation
import SwiftData

@Model
class WorkoutStat {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var date: Date
    var year: Int
    var month: Int
    var day: Int
    var category: Category?
    var imageName: String?
    var restTimeBetweenExercises: Int
    var sourceType: String // "workout" or "challenge" or "unknown"
    
    var workout: Workout?
    var challengeWorkout: ChallengeWorkout?

    @Relationship(deleteRule: .cascade)
    var exerciseStats: [ExerciseStat] = []

    init(workout: Workout? = nil, challengeWorkout: ChallengeWorkout? = nil) {
        self.uuid = UUID()
        
        let now = Date()
        self.date = now
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        self.year = components.year ?? 0
        self.month = components.month ?? 0
        self.day = components.day ?? 0
        
        if let w = workout {
            self.name = w.name
            self.category = w.category
            self.imageName = w.imageName
            self.restTimeBetweenExercises = w.restTimeBetweenExercises
            self.sourceType = "workout"
            self.workout = w
            self.challengeWorkout = nil
            self.exerciseStats = w.workoutExercises.map { ExerciseStat(workoutExercise: $0) }
        } else if let cw = challengeWorkout {
            self.name = cw.name
            self.category = cw.category
            self.imageName = cw.imageName
            self.restTimeBetweenExercises = cw.restTimeBetweenExercises
            self.sourceType = "challenge"
            self.workout = nil
            self.challengeWorkout = cw
            self.exerciseStats = cw.workoutExercises.map { ExerciseStat(workoutExercise: $0) }
        } else {
            // Fallback defaults
            self.name = "Unknown Workout"
            self.category = nil
            self.imageName = nil
            self.restTimeBetweenExercises = 0
            self.sourceType = "unknown"
            self.workout = nil
            self.challengeWorkout = nil
            self.exerciseStats = []
        }
    }

    var totalReps: Int {
        exerciseStats.reduce(0) { $0 + $1.totalReps }
    }
}
