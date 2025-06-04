//
//  WorkoutExercise.swift
//  Workout
//
//  Created by Max Schneider on 18.05.25.
//

import Foundation
import SwiftData

@Model
final class WorkoutExercise {
    @Attribute(.unique) var uuid: UUID?
    var name: String?
    var sets: Int?
    var reps: Int?
    var order: Int // To maintain exercise order in workout
    var category: Category?
    var imageName: String?
    var isSample: Bool
    
    @Relationship(inverse: \Workout.workoutExercises)
    var workout: Workout?
    
    @Relationship(inverse: \ChallengeWorkout.workoutExercises)
    var challengeWorkout: ChallengeWorkout?
    
    init(name: String, workout: Workout, sets: Int? = nil, reps: Int? = nil, order: Int = 0, category: Category? = nil, imageName: String? = nil, isSample: Bool = false) {
        self.uuid = UUID()
        self.name = name
        self.workout = workout
        self.sets = sets
        self.reps = reps
        self.order = order
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
    }
    
    init(name: String, challengeWorkout: ChallengeWorkout, sets: Int? = nil, reps: Int? = nil, order: Int = 0, category: Category? = nil, imageName: String? = nil, isSample: Bool = false) {
        self.uuid = UUID()
        self.name = name
        self.challengeWorkout = challengeWorkout
        self.sets = sets
        self.reps = reps
        self.order = order
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
    }
    
    var totalReps: Int {
        guard let sets = sets, let reps = reps else { return 0 }
        return sets * reps
    }
    
    /*
    var effectiveSets: Int {
        return sets ?? exercise?.sets ?? 0
    }
    
    var effectiveRepsPerSet: Int {
        return reps ?? exercise?.reps ?? 0
    }
    
   
    
    var isCustomized: Bool {
        return sets != nil || reps != nil
    }
    
    var name: String {
        return exercise?.name ?? "Unknown Exercise"
    }
     */
}
