//
//  ChallengeSummaryView.swift
//  Workout
//
//  Created by Max Schneider on 02.06.25.
//

import SwiftUI

struct ChallengeSummaryView: View {
    
    // Input data
    let challenge: Challenge?
    let userChallenge: UserChallenge?
    
    init(challenge: Challenge) {
        self.challenge = challenge
        self.userChallenge = nil
    }
    
    init(userChallenge: UserChallenge) {
        self.challenge = nil
        self.userChallenge = userChallenge
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

