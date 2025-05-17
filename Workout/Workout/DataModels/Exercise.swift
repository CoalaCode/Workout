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
    var uuid: UUID
    var name: String
    var sets: Int
    var reps: Int
    
    init(name: String, sets: Int, reps: Int) {
        self.uuid = UUID()
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}
