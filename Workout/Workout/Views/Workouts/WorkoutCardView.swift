import SwiftUI

struct WorkoutCardView: View {
    
    let workout: Workout?
    let challengeWorkout: ChallengeWorkout?
    
    init(workout: Workout) {
        self.workout = workout
        self.challengeWorkout = nil
    }
    
    init(challengeWorkout: ChallengeWorkout) {
        self.workout = nil
        self.challengeWorkout = challengeWorkout
    }
    
    // Computed properties to handle optional values
    private var workoutName: String {
        return workout?.name ?? challengeWorkout?.name ?? "Unknown Workout"
    }
    
    private var workoutImage: String {
        return workout?.imageName ?? challengeWorkout?.imageName ?? "Unknown Workout"
    }
    
    private var amountOfExercises: Int {
        return workout?.workoutExercises.count ?? challengeWorkout?.workoutExercises.count ?? 0
    }
    
    private var destinationView: some View {
        if let workout = workout {
            return AnyView(WorkoutDetailView(workout: workout))
        } else if let challengeWorkout = challengeWorkout {
            return AnyView(WorkoutDetailView(challengeWorkout: challengeWorkout))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: destinationView) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(workoutName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(amountOfExercises) exercises")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(width: 200, height: 150)
                .background(
                    Image(workoutImage)
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            Color.black.opacity(0.3)
                        )
                )
                .cornerRadius(10)
                .clipped()
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
} 

