//
//  AllChallengesView.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import SwiftUI
import SwiftData

struct AllChallengesView: View {
    @Query private var challenges: [Challenge]
    
    var body: some View {
        List {
            ForEach(challenges) { challenge in
                NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                    Text(challenge.name)
                }
            }
        }
        .navigationTitle("All Challenges")
    }
}

#Preview {
    AllChallengesView()
        .modelContainer(for: [Challenge.self], inMemory: true)
}
