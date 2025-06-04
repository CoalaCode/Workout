//
//  Workout.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import Foundation
import SwiftData

@Model
class Workout {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var date: Date
    var restTimeBetweenExercises: Int
    var category: Category?
    var imageName: String?
    var isSample: Bool
    
    @Relationship(deleteRule: .cascade)
    var workoutExercises: [WorkoutExercise] = []
    
    init(name: String, restTimeBetweenExercises: Int = 120, category: Category? = nil, imageName: String? = nil, isSample: Bool = false) {
        self.uuid = UUID()
        self.name = name
        self.date = Date()
        self.restTimeBetweenExercises = restTimeBetweenExercises
        self.category = category
        self.imageName = imageName
        self.isSample = isSample
    }
    
    func addExercise(_ exercise: Exercise, sets: Int? = nil, reps: Int? = nil) {
        let workoutExercise = WorkoutExercise(
            name: exercise.name,
            workout: self,
            sets: sets,
            reps: reps,
            order: workoutExercises.count,
            category: exercise.category,
            imageName: exercise.imageName,
            isSample: exercise.isSample
        )
        workoutExercises.append(workoutExercise)
    }
    
    func addWorkoutExercise(_ workoutExercise: WorkoutExercise, sets: Int? = nil, reps: Int? = nil) {
        workoutExercise.workout = self
        workoutExercise.order = workoutExercises.count
        workoutExercises.append(workoutExercise)
    }
    func removeAllExercises() {
        workoutExercises.removeAll()
    }
     
    /*
    var allWorkoutExercises: [WorkoutExercise] {
        return workoutExercises.compactMap { $0. }
    }
     */
    var totalReps: Int {
        workoutExercises.reduce(0) { $0 + ($1.sets! * $1.reps!) }
    }
}
