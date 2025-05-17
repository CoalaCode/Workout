import Foundation
import SwiftData

@Model
class Challenge {
    var uuid: UUID
    var name: String
    var workouts: [Workout]
    var startDate: Date
    var completedWorkoutIDs: [UUID]
    var durationDays: Int
    
    init(name: String, workouts: [Workout], startDate: Date, durationDays: Int) {
        self.uuid = UUID()
        self.name = name
        self.workouts = workouts
        self.startDate = startDate
        self.completedWorkoutIDs = []
        self.durationDays = durationDays
    }
} 