import Foundation
import SwiftData

@Model
class Challenge {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var startDate: Date
    var endDate: Date?
    var completedWorkoutIDs: [String]
    var category: Category?
    var imageName: String?
    var isSample: Bool
    var currentWorkoutIndex: Int
    
    @Relationship(deleteRule: .cascade)
    var challengeWorkouts: [ChallengeWorkout]
    
    init(name: String, startDate: Date, endDate: Date? = nil, category: Category, imageName: String, isSample: Bool) {
        self.uuid = UUID()
        self.name = name
        self.challengeWorkouts = []
        self.startDate = startDate
        self.endDate = endDate
        self.completedWorkoutIDs = []
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
        self.currentWorkoutIndex = 0
    }
    
    func addChallengeWorkout(_ workout: Workout) {
        let challengeWorkout = ChallengeWorkout(
            name: workout.name,
            restTimeBetweenExercises: workout.restTimeBetweenExercises,
            category: workout.category,
            imageName: workout.imageName ?? "fitness",
            isSample: false
        )
        
        // Add each exercise from the original workout to the challenge workout
        for exercise in workout.workoutExercises {
            challengeWorkout.addWorkoutExercise(exercise)
        }
        
        challengeWorkouts.append(challengeWorkout)
    }
    
    func removeAllChallengeWorkouts() {
        challengeWorkouts.removeAll()
    }
    
    var nextWorkout: ChallengeWorkout? {
        guard currentWorkoutIndex < challengeWorkouts.count else { return nil }
        return challengeWorkouts[currentWorkoutIndex]
    }
    
    var totalWorkouts: Int {
            challengeWorkouts.count
        }
}

