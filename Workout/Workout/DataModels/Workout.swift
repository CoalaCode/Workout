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
    
    var uuid: UUID
    var name: String
    var exercises: [Exercise]
    var date: Date
    var duration: TimeInterval
    
    init(name: String, exercises: [Exercise], date: Date, duration: TimeInterval) {
        self.uuid = UUID()
        self.name = name
        self.exercises = exercises
        self.date = date
        self.duration = duration
    }
}
