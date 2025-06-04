import SwiftUI

struct ChallengeCardView: View {
    let challenge: Challenge?
    let userChallenge: UserChallenge?
    
    private var name: String {
        challenge?.name ?? userChallenge?.name ?? "Unknown Challenge"
    }
    
    
    private var completedWorkoutIDs: [String] {
        challenge?.completedWorkoutIDs ?? userChallenge?.completedWorkoutIDs ?? []
    }
    
    private var totalWorkouts: Int {
        challenge?.challengeWorkouts.count ?? userChallenge?.challengeWorkouts.count ?? 0
    }
    
    private var challengeImage: String {
        challenge?.imageName ?? userChallenge?.imageName ?? "hantel"
    }
    
    var progress: Double {
        guard totalWorkouts > 0 else { return 0 }
        let completed = completedWorkoutIDs.count
        return Double(completed) / Double(totalWorkouts)
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
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(totalWorkouts) workouts")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    HStack {
                        Text("\(completedWorkoutIDs.count) of \(totalWorkouts) complete")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 300, height: 250)
                .background(
                    Image(challengeImage)
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            Color.black.opacity(0.7)
                        )
                )
                .cornerRadius(10)
                .clipped()
            }
        }
    }
    
    // Initializers for both cases
    init(challenge: Challenge) {
        self.challenge = challenge
        self.userChallenge = nil
    }
    
    init(userChallenge: UserChallenge) {
        self.userChallenge = userChallenge
        self.challenge = nil
    }
}


#Preview {
    ChallengeCardView(challenge: SampleData.challenges[0])
        .padding()
}


