//
//  ChallengeAllCardView.swift
//  Workout
//
//  Created by Max Schneider on 26.05.25.
//

//
//  WorkoutAllCardView.swift
//  Workout
//
//  Created by Max Schneider on 21.05.25.
//

import SwiftUI

struct ChallengeAllCardView: View {
    
    let challenge: Challenge?
    let userChallenge: UserChallenge?
    
    // Initializer for regular Workout
    init(challenge: Challenge) {
        self.challenge = challenge
        self.userChallenge = nil
    }
    
    // Initializer for ChallengeWorkout
    init(userChallenge: UserChallenge) {
        self.challenge = nil
        self.userChallenge = userChallenge
    }
    
    // Computed properties to handle optional values
    private var challengeName: String {
        return challenge?.name ?? userChallenge?.name ?? "Unknown Workout"
    }
    
    private var amountOfWorkouts: Int {
        return challenge?.challengeWorkouts.count ?? userChallenge?.challengeWorkouts.count ?? 0
    }
    
    
    
    private var destinationView: some View {
        if let challenge = challenge {
            return AnyView(ChallengeDetailView(challenge: challenge))
        } else if let userChallenge = userChallenge {
            return AnyView(ChallengeDetailView(userChallenge: userChallenge))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: destinationView) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(challengeName)
                        .font(.headline)
                        .foregroundColor(.white)
                        
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.white)
                        Text("Workouts: \(amountOfWorkouts)")
                            .font(.subheadline)
                            .foregroundColor(.white)
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

