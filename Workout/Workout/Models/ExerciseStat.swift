import Foundation
import SwiftData


@Model
class ExerciseStat {
    @Attribute(.unique) var id: UUID
    var name: String
    var date: Date
    var year: Int
    var month: Int
    var day: Int
    var sets: Int
    var reps: Int
    var totalReps: Int
    var category: Category
    var imageName: String
    var sourceType: String // "standalone" or "workout"
    
    // Optional metadata
    var durationInSeconds: Int?
    var perceivedDifficulty: Int? // 1–10 scale
    var notes: String?

    init(exercise: Exercise? = nil, workoutExercise: WorkoutExercise? = nil) {
        let now = Date()
        self.id = UUID()
        self.date = now
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        self.year = components.year ?? 0
        self.month = components.month ?? 0
        self.day = components.day ?? 0

        if let ex = exercise {
            self.name = ex.name
            self.sets = ex.sets
            self.reps = ex.reps
            self.totalReps = ex.sets * ex.reps
            self.category = ex.category!
            self.imageName = ex.imageName
            self.sourceType = "standalone"
        } else if let we = workoutExercise {
            self.name = we.name ?? "unknown"
            self.sets = we.sets ?? 0
            self.reps = we.reps ?? 0
            self.totalReps = we.sets! * we.reps!
            self.category = we.category!
            self.imageName = we.imageName ?? "fitness"
            self.sourceType = "workout"
        } else {
            // Fallback, though this should be avoided
            self.name = "Unknown"
            self.sets = 0
            self.reps = 0
            self.totalReps = 0
            self.category = SampleData.category[0]
            self.imageName = "fitness"
            self.sourceType = "unknown"
        }
    }
}
