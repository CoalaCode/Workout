import SwiftUI

struct ChallengeDetailView: View {
    
    // Input data
    let challenge: Challenge?
    let userChallenge: UserChallenge?
    
    @State private var isActiveChallenge = false
    @State private var showingEditSheet = false
    @State private var startSession = false
    
    init(challenge: Challenge) {
        self.challenge = challenge
        self.userChallenge = nil
    }
    
    init(userChallenge: UserChallenge) {
        self.challenge = nil
        self.userChallenge = userChallenge
    }
    
    private var challengeName: String {
        return challenge?.name ?? userChallenge?.name ?? "Unknown Challenge"
    }
    
    private var challengeWorkouts: [ChallengeWorkout] {
        return challenge?.challengeWorkouts ?? userChallenge?.challengeWorkouts ?? []
    }
    
    private var buttonTitle: String {
        if let challenge = challenge {
            return challenge.completedWorkoutIDs.isEmpty ? "Start Challenge" : "Continue Challenge"
        } else if let userChallenge = userChallenge {
            return userChallenge.completedWorkoutIDs.isEmpty ? "Start Challenge" : "Continue Challenge"
        }
        return "Start Challenge"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    Image("fitness")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(height: 200)
                    
                    // Header
                    VStack(alignment: .leading, spacing: 20) {
                        Text(challengeName)
                            .font(.title)
                            .bold()
                        HStack() {
                            Text("Category")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Text("Upper Body")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.gray)
                        }
                        HStack() {
                            Text("Workout Level")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Text("Intermediate")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    
                    // Exercises
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Workouts")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(challengeWorkouts) { challengeWorkout in
                                    WorkoutCardView(challengeWorkout: challengeWorkout)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Add padding at the bottom to account for the fixed button
                    Spacer()
                        .frame(height: 80)
                }
            }
            .ignoresSafeArea()
            
            // Start Workout Button
            VStack {
                Button(action: {
                    isActiveChallenge = true
                }) {
                    Text(buttonTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isActiveChallenge) {
            if let challenge = challenge {
                ChallengeActiveView(challenge: challenge)
            } else if let userChallenge = userChallenge {
                ChallengeActiveView(userChallenge: userChallenge)
            }
        }
    }
}
