import Foundation
import SwiftData

@Model
class UserChallenge {
    
    var uuid: UUID
    var name: String
    var startDate: Date
    var completedWorkoutIDs: [String]
    var category: Category?
    var imageName: String?
    var isSample: Bool
    var currentWorkoutIndex: Int
    
    @Relationship(deleteRule: .cascade) var challengeWorkouts: [ChallengeWorkout]
    
    init(name: String, startDate: Date, category: Category, imageName: String, isSample: Bool) {
        self.uuid = UUID()
        self.name = name
        self.challengeWorkouts = []
        self.startDate = startDate
        self.completedWorkoutIDs = []
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
        self.currentWorkoutIndex = 0
    }
    
    func addUserChallengeWorkout(_ workout: Workout) {
        //let order = challengeWorkouts.count
        let challengeWorkout = ChallengeWorkout(
            name: workout.name,
            restTimeBetweenExercises: 120,
            category: workout.category,
            imageName: "fitness",
            isSample: false
            
        )
        //challengeWorkout.workout = workout
        //challengeWorkout.challenge = self
        challengeWorkouts.append(challengeWorkout)
    }
    
    func removeAllChallengeWorkouts() {
        challengeWorkouts.removeAll()
    }
    
    var nextWorkout: ChallengeWorkout? {
        guard currentWorkoutIndex < challengeWorkouts.count else { return nil }
        return challengeWorkouts[currentWorkoutIndex]
    }
}

