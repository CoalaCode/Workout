import Foundation
import SwiftData

@Model
class ExerciseStat {
    @Attribute(.unique) var id: UUID
    var exerciseName: String
    var date: Date
    var sets: Int
    var reps: Int
    var totalReps: Int
    
    init(exerciseName: String, date: Date, sets: Int, reps: Int, totalReps: Int) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.date = date
        self.sets = sets
        self.reps = reps
        self.totalReps = totalReps
    }
} 
