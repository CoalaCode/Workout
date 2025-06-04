//
//  TodayCardView.swift
//  Workout
//
//  Created by Max Schneider on 21.05.25.
//

import SwiftUI

struct TodayCardView: View {
    var challenge: Challenge
    var workout: ChallengeWorkout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(challenge.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            
            
            Text("\(challenge.challengeWorkouts.count) Workouts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 300, height: 250)
        .background(LinearGradient(gradient: Gradient(colors: [.gray, .mint]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
    }
    
}

