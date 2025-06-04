//
//  CategoryExercise.swift
//  Workout
//
//  Created by Max Schneider on 21.05.25.
//

import SwiftData
import Foundation

@Model
class Category {
    var uuid: UUID = UUID()
    var name: String
    var level: Int
    var parent: Category?
    var children: [Category] = []
    
    init(name: String, level: Int = 0, parent: Category? = nil) {
        self.name = name
        self.level = level
        self.parent = parent
    }
}
