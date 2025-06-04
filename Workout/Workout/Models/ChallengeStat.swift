import Foundation
import SwiftData

@Model
class ChallengeStat {
    @Attribute(.unique) var uuid: UUID
    var challenge: Challenge
    var name: String
    var dateStarted: Date
    var dateCompleted: Date?
    var completedWorkouts: Int
    var totalWorkouts: Int
    var totalReps: Int
    var progressPercent: Double {
        totalWorkouts == 0 ? 0.0 : Double(completedWorkouts) / Double(totalWorkouts)
    }

    @Relationship(deleteRule: .cascade)
    var workoutStats: [WorkoutStat] = []

    init(challenge: Challenge) {
        self.uuid = UUID()
        self.challenge = challenge
        self.name = challenge.name
        self.dateStarted = Date()
        self.totalWorkouts = challenge.totalWorkouts
        self.completedWorkouts = 0
        self.totalReps = 0
    }

    func recordWorkoutStat(_ stat: WorkoutStat) {
        workoutStats.append(stat)
        completedWorkouts += 1
        totalReps += stat.totalReps
        if completedWorkouts == totalWorkouts {
            dateCompleted = Date()
        }
    }
}
