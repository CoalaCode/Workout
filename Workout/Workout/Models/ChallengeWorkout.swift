import Foundation
import SwiftData

@Model
class ChallengeWorkout {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var date: Date
    var restTimeBetweenExercises: Int
    var category: Category?
    var imageName: String?
    var isSample: Bool
    
    @Relationship(deleteRule: .cascade)
    var workoutExercises: [WorkoutExercise] = []
    
    init(name: String, restTimeBetweenExercises: Int = 120, category: Category?, imageName: String? = nil, isSample: Bool = false) {
        self.uuid = UUID()
        self.name = name
        self.date = Date()
        self.restTimeBetweenExercises = restTimeBetweenExercises
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
        self.workoutExercises = workoutExercises
    }
    
    func addExercise(_ exercise: Exercise, sets: Int? = nil, reps: Int? = nil, category: Category? = nil, imageName: String? = nil, isSample: Bool = false) {
        let workoutExercise = WorkoutExercise(
            name: exercise.name,
            challengeWorkout: self,
            sets: sets,
            reps: reps,
            order: workoutExercises.count,
            category: category,
            imageName: imageName,
            isSample: isSample
        )
        workoutExercises.append(workoutExercise)
    }
    
    
    func addWorkoutExercise(_ workoutExercise: WorkoutExercise, sets: Int? = nil, reps: Int? = nil, category: Category? = nil, imageName: String? = nil, isSample: Bool = false) {
        let workoutExercise = WorkoutExercise(
            name: workoutExercise.name ?? "Unknown",
            challengeWorkout: self,
            sets: sets,
            reps: reps,
            order: workoutExercises.count,
            category: category,
            imageName: imageName,
            isSample: isSample
        )
        workoutExercises.append(workoutExercise)
    }
     
    func removeAllExercises() {
        workoutExercises.removeAll()
    }
}

