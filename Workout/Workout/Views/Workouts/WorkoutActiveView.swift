import SwiftUI

/// A view that manages an active workout session, handling:
/// - Displaying exercises in sequence
/// - Managing rest periods between exercises
/// - Tracking workout completion
/// - Saving workout statistics
/// - Handling challenge progress
///

struct WorkoutActiveView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Input data
    let workout: Workout?
    let challengeWorkout: ChallengeWorkout?
    
    // View state
    @State private var currentExerciseIndex = -1  // Start at -1 so first exercise is at index 0
    @State private var isRestPeriod = false
    @State private var restTimeRemaining = 0
    @State private var isReadyState = true
    @State private var readyTimeRemaining = 15
    @State private var timer: Timer?
    @State private var isFinished = false
    @State private var showSummary = false
    
    // Computed properties to handle optional values
    private var workoutName: String {
        return challengeWorkout?.name ?? workout?.name ?? "Unknown Workout"
    }
    
    private var exercises: [WorkoutExercise] {
        return challengeWorkout?.workoutExercises ?? workout?.workoutExercises ?? []
    }
    
    private var currentExercise: WorkoutExercise? {
        guard currentExerciseIndex >= 0 && currentExerciseIndex < exercises.count else { return nil }
        return exercises[currentExerciseIndex]
    }
    
    /// Initializer for a standalone workout (not part of a challenge)
    init(workout: Workout) {
        self.workout = workout
        self.challengeWorkout = nil
    }
    
    /// Initializer for a workout that is part of a challenge
    init(challengeWorkout: ChallengeWorkout) {
        self.workout = nil
        self.challengeWorkout = challengeWorkout
    }
    
    var body: some View {
        if showSummary {
            if let workout = workout {
                WorkoutSummaryView(workout: workout)
            } else if let challengeWorkout = challengeWorkout {
                WorkoutSummaryView(challengeWorkout: challengeWorkout)
            }
        } else if isReadyState {
            ReadyView(timeRemaining: readyTimeRemaining, skipReady: {
                startWorkout()
            })
            .onAppear {
                startReadyTimer()
            }
        } else if isRestPeriod {
            RestView(timeRemaining: restTimeRemaining, skipRest: {
                startNextExercise()
            })
        } else {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    if let currentExercise = currentExercise {
                        ExerciseActiveView(
                            workoutExercise: currentExercise,
                            onExerciseComplete: handleExerciseComplete
                        )
                    }
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    /// Starts the ready state countdown timer
    private func startReadyTimer() {
        timer?.invalidate()
        readyTimeRemaining = 15
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if readyTimeRemaining > 0 {
                readyTimeRemaining -= 1
            } else {
                timer?.invalidate()
                startWorkout()
            }
        }
    }
    
    /// Starts the workout after the ready state
    private func startWorkout() {
        timer?.invalidate()
        isReadyState = false
        startNextExercise()
    }
    
    /// Handles the completion of an exercise, including:
    /// - Starting rest period if more exercises remain
    /// - Showing summary if workout is complete
    private func handleExerciseComplete() {
        if currentExerciseIndex < exercises.count - 1 {
            startRestPeriod()
        } else {
            finishWorkout()
        }
    }
    
    /// Starts a rest period between exercises
    private func startRestPeriod() {
        isRestPeriod = true
        restTimeRemaining = workout?.restTimeBetweenExercises ?? 120
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if restTimeRemaining > 0 {
                restTimeRemaining -= 1
            } else {
                timer?.invalidate()
                startNextExercise()
            }
        }
    }
    
    /// Moves to the next exercise in the workout
    private func startNextExercise() {
        timer?.invalidate()
        isRestPeriod = false
        currentExerciseIndex += 1
        
        // If we've completed all exercises, show the summary
        if currentExerciseIndex >= exercises.count {
            finishWorkout()
        }
    }
    
    /// Finishes the workout and shows the summary
    private func finishWorkout() {
        isFinished = true
        showSummary = true
    }
}

/// A view that displays a ready state countdown before starting the workout
struct ReadyView: View {
    let timeRemaining: Int
    let skipReady: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Get Ready!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Workout starts in")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Text("\(timeRemaining)")
                        .font(.system(size: 70))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 200)
                
                Button("Skip") {
                    skipReady()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

/// A view that displays a rest period between exercises
struct RestView: View {
    let timeRemaining: Int
    let skipRest: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Rest Time")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Next exercise in")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Text("\(timeRemaining)")
                        .font(.system(size: 70))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 200)
                
                Button("Skip Rest") {
                    skipRest()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

