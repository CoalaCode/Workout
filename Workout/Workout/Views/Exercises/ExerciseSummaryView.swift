//
//  ExerciseSummaryView.swift
//  Workout
//
//  Created by Max Schneider on 22.05.25.
//

import SwiftUI
import SwiftData

struct ExerciseSummaryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let exercise: Exercise
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Exercise Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(exercise.name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Sets completed: \(exercise.sets)")
                    .font(.title3)
                
                Text("Reps per set: \(exercise.reps)")
                    .font(.title3)
                
                Text("Total reps: \(exercise.totalReps)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            Button("Done") {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.bottom)
        }
        .padding()
    }
}

