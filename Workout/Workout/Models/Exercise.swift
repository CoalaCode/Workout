//
//  Exercise.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import Foundation
import SwiftData

@Model
class Exercise {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var sets: Int
    var reps: Int
    var category: Category?
    var imageName: String
    var isSample: Bool

    @Relationship(deleteRule: .cascade)
    var workoutExercises: [WorkoutExercise] = []

    init(name: String, sets: Int, reps: Int, category: Category? = nil, imageName: String, isSample: Bool = false) {
        self.uuid = UUID()
        self.name = name
        self.sets = sets
        self.reps = reps
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
    }

    var totalReps: Int {
        sets * reps
    }
}
