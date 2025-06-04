//
//  ExerciseAllCardView.swift
//  Workout
//
//  Created by Max Schneider on 21.05.25.
//

import SwiftUI

struct ExerciseAllCardView: View {
    
    let exercise: Exercise
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(exercise.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.white)
                        Text("\(exercise.sets) sets")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Image(systemName: "figure.walk")
                            .foregroundColor(.white)
                        Text("\(exercise.reps) reps")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}

/*
#Preview {
    ExerciseAllCardView()
}
*/
