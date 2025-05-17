import SwiftUI

struct ChallengeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var challenge: Challenge
    
    var progress: Double {
        guard !challenge.workouts.isEmpty else { return 0 }
        let completed = challenge.completedWorkoutIDs.count
        return Double(completed) / Double(challenge.workouts.count)
    }
    
    var nextWorkout: Workout? {
        challenge.workouts.first { !challenge.completedWorkoutIDs.contains($0.uuid) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(challenge.name)
                    .font(.largeTitle)
                    .bold()
                ProgressView(value: progress) {
                    Text("Progress")
                }
                .progressViewStyle(LinearProgressViewStyle())
                Text("\(challenge.completedWorkoutIDs.count) of \(challenge.workouts.count) workouts complete")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Divider()
                Text("Workouts")
                    .font(.title2)
                    .bold()
                ForEach(challenge.workouts, id: \ .uuid) { workout in
                    HStack {
                        Text(workout.name)
                        Spacer()
                        if challenge.completedWorkoutIDs.contains(workout.uuid) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
                if let next = nextWorkout {
                    Button(action: {
                        // Navigation to workout session or mark as complete logic here
                    }) {
                        Text("Start Next Workout: \(next.name)")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text("Challenge Complete!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle(challenge.name)
    }
}

#Preview {
    ChallengeDetailView(challenge: Challenge(name: "1 Week Challenge", workouts: [], startDate: Date(), durationDays: 7))
} 