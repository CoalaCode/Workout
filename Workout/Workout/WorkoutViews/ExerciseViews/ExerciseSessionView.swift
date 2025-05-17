import SwiftUI
import SwiftData

struct ExerciseSessionView: View {
    let exercise: Exercise
    let source: ExerciseSource
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Binding var isRestingWorkout: Bool
    
    @State private var currentSet = 1
    @State private var isResting = false
    @State private var restTime = 30
    @State private var timer: Timer? = nil
    @State private var totalReps = 0
    @State private var sessionComplete = false
    @State private var statSaved = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Exercise Image
            Image("yoga")
                .resizable()
                .scaledToFill()
                .frame(height: 240)
                .clipped()
                .overlay(
                    VStack {
                        Spacer()
                        Text(exercise.name)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.bottom, 40)
                        Text(setString)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.7))
                    }, alignment: .bottom
                )
                .ignoresSafeArea()
            Spacer()
            
            if sessionComplete {
                SessionCompleteView(
                    exercise: exercise,
                    statSaved: statSaved,
                    source: source,
                    isRestingWorkout: $isRestingWorkout
                )
            } else if isResting {
                IsRestingView(
                    currentSet: currentSet,
                    restTime: restTime,
                    onSkipRest: stopRest
                )
                .onAppear(perform: startRest)
            } else {
                SessionDoingView(
                    exercise: exercise,
                    currentSet: currentSet,
                    totalReps: totalReps,
                    onCompleteSet: completeSet
                )
            }
            Spacer()
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .onDisappear {
            timer?.invalidate()
        }
        .onChange(of: sessionComplete) {
            if sessionComplete && !statSaved {
                saveStat()
            }
        }
    }
    
    private var setString: String {
        Array(repeating: "\(exercise.reps)", count: exercise.sets).joined(separator: " - ")
    }
    
    private func saveStat() {
        let stat = ExerciseStat(
            exerciseName: exercise.name,
            date: Date(),
            sets: exercise.sets,
            reps: exercise.reps,
            totalReps: exercise.sets * exercise.reps
        )
        modelContext.insert(stat)
        statSaved = true
    }
    
    private func completeSet() {
        totalReps += exercise.reps
        if currentSet < exercise.sets {
            isResting = true
        } else {
            sessionComplete = true
            // Save stats here if needed
        }
    }
    
    private func startRest() {
        restTime = 30
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if restTime > 0 {
                restTime -= 1
            } else {
                stopRest()
            }
        }
    }
    
    private func stopRest() {
        timer?.invalidate()
        isResting = false
        currentSet += 1
    }
}

struct SessionCompleteView: View {
    var exercise: Exercise
    @State var statSaved: Bool
    @Environment(\.dismiss) var dismiss
    var source: ExerciseSource
    //var onContinueWorkout: (() -> Void)?
    @Binding var isRestingWorkout: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top: Completion message
            Text("Exercise Complete!")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            // Stats
            VStack(alignment: .leading, spacing: 20) {
                Text("Total Sets: \(exercise.sets)")
                    .font(.title)
                Text("Total Reps: \(exercise.sets * exercise.reps)")
                    .font(.title)
                if statSaved {
                    Text("Session saved!")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
            Spacer()
            // Bottom: Conditional button
            if source == .singleExercise {
                Button("Done") {
                    dismiss()
                }
                .frame(width: 200, height: 30, alignment: .center)
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.bottom, 32)
            } else if source == .workout {
                Button("Next Exercise") {
                    isRestingWorkout = true
                    dismiss()
                }
                .frame(width: 200, height: 30, alignment: .center)
                .font(.title)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SessionDoingView: View {
    var exercise: Exercise
    var currentSet: Int
    var totalReps: Int
    var onCompleteSet: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Set \(currentSet) of \(exercise.sets)")
                .font(.title)
                .foregroundColor(.secondary)
            Button(action: onCompleteSet) {
                ZStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 200)
                    Text("\(exercise.reps)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .background(Color(.darkGray))
                .clipShape(Circle())
                .shadow(radius: 8)
            }
            .padding(.bottom, 32)
        }
    }
}

struct IsRestingView: View {
    var currentSet: Int
    var restTime: Int
    var onSkipRest: () -> Void
    var body: some View {
        VStack(spacing: 24) {
            Text("Rest")
                .font(.title2)
                .bold()
            Text("\(restTime)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundColor(.gray)
            Button("Skip Rest") {
                onSkipRest()
            }
            .font(.headline)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.secondary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

/*
#Preview {
    // Provide a sample Exercise for preview
    let source = ExerciseSource.workout
    let sampleExercise = Exercise(name: "Push Ups", sets: 3, reps: 15)
    ExerciseSessionView(exercise: sampleExercise, source: source, isRestingWorkout: $false)
}
*/

