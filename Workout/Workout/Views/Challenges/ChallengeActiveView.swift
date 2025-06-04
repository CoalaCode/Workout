import SwiftUI
import SwiftData

struct ChallengeActiveView: View {
    // Input data
    let challenge: Challenge?
    let userChallenge: UserChallenge?
    
    @State private var isActiveWorkout = false
    @State private var completedWorkoutIDs: Set<String> = []
    @State private var currentWorkoutIndex: Int = 0
    
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
    
    private var nextWorkout: ChallengeWorkout? {
        if let challenge = challenge {
            return challenge.currentWorkoutIndex < challenge.challengeWorkouts.count ? challenge.challengeWorkouts[challenge.currentWorkoutIndex] : nil
        } else if let userChallenge = userChallenge {
            return userChallenge.currentWorkoutIndex < userChallenge.challengeWorkouts.count ? userChallenge.challengeWorkouts[userChallenge.currentWorkoutIndex] : nil
        }
        return nil
    }
    
    private var progress: Double {
        let total = challengeWorkouts.count
        guard total > 0 else { return 0 }
        return Double(completedWorkoutIDs.count) / Double(total)
    }
    
    private var completedWorkouts: Int {
        return completedWorkoutIDs.count
    }
    
    private var totalWorkouts: Int {
        return challengeWorkouts.count
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Progress Section
            VStack(spacing: 16) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.blue)
                
                Text("\(completedWorkouts) of \(totalWorkouts) workouts complete")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Next Workout Section
            if let nextWorkout = nextWorkout {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Next Workout")
                        .font(.headline)
                    
                    WorkoutAllCardView(challengeWorkout: nextWorkout)
                    
                    Button(action: {
                        isActiveWorkout = true
                    }) {
                        Text("Start Workout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            } else {
                if let challenge = challenge {
                    ChallengeSummaryView(challenge: challenge)
                } else if let userChallenge = userChallenge {
                    ChallengeSummaryView(userChallenge: userChallenge)
                }
            }
            
            Spacer()
        }
        .navigationTitle(challengeName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isActiveWorkout) {
            if let nextWorkout = nextWorkout {
                WorkoutActiveView(challengeWorkout: nextWorkout)
                    .onDisappear {
                        // Update state when workout is completed
                        completedWorkoutIDs.insert(nextWorkout.uuid.uuidString)
                        currentWorkoutIndex += 1
                        
                        // Update model
                        if let challenge = challenge {
                            challenge.completedWorkoutIDs.append(nextWorkout.uuid.uuidString)
                            challenge.currentWorkoutIndex = currentWorkoutIndex
                        } else if let userChallenge = userChallenge {
                            userChallenge.completedWorkoutIDs.append(nextWorkout.uuid.uuidString)
                            userChallenge.currentWorkoutIndex = currentWorkoutIndex
                        }
                    }
            }
        }
        .onAppear {
            // Initialize state from model
            if let challenge = challenge {
                completedWorkoutIDs = Set(challenge.completedWorkoutIDs)
                currentWorkoutIndex = challenge.currentWorkoutIndex
            } else if let userChallenge = userChallenge {
                completedWorkoutIDs = Set(userChallenge.completedWorkoutIDs)
                currentWorkoutIndex = userChallenge.currentWorkoutIndex
            }
        }
    }
}

#Preview {
    ChallengeActiveView(challenge: SampleData.challenges[0])
}
