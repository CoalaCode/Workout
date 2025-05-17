import SwiftUI

struct ChallengeCardView: View {
    let challenge: Challenge
    
    var progress: Double {
        guard !challenge.workouts.isEmpty else { return 0 }
        let completed = challenge.completedWorkoutIDs.count
        return Double(completed) / Double(challenge.workouts.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(challenge.name)
                .font(.headline)
                .foregroundColor(.primary)
            Text("\(challenge.completedWorkoutIDs.count)/\(challenge.workouts.count) Workouts")
                .font(.subheadline)
                .foregroundColor(.secondary)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
        }
        .padding()
        .frame(width: 280, height: 180)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ChallengeCardView(challenge: Challenge(name: "1 Week Challenge", workouts: [], startDate: Date(), durationDays: 7))
} 
