//
//  WorkoutSessionView.swift
//  Workout
//
//  Created by Max Schneider on 16.05.25.
//

import SwiftUI

enum ExerciseSource {
    case workout
    case singleExercise
}

struct WorkoutSessionView: View {
    var workout: Workout
    @State private var currentExerciseIndex = 0
    @State private var isResting = false
    @State private var restTime = 120
    @State private var timer: Timer? = nil
    @State private var workoutComplete = false
    @State private var getReady = true
    @State private var getReadyTime = 15
    
    var body: some View {
        VStack {
            if workoutComplete {
                WorkoutSummaryView(workout: workout)
            } else if getReady {
                GetReadyView(getReadyTime: getReadyTime, onReady: startFirstExercise)
                    .onAppear(perform: startGetReadyTimer)
            } else if isResting {
                RestView(restTime: restTime, onSkipRest: startNextExercise)
                    .onAppear(perform: startRest)
            } else {
                ExerciseSessionView(exercise: workout.exercises[currentExerciseIndex],
                                    source: .workout,
                                    isRestingWorkout: $isResting
                )
                .onDisappear(perform: completeExercise)
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startGetReadyTimer() {
        getReadyTime = 15
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if getReadyTime > 0 {
                getReadyTime -= 1
            } else {
                startFirstExercise()
            }
        }
    }
    
    private func startFirstExercise() {
        timer?.invalidate()
        getReady = false
    }
    
    private func completeExercise() {
        if currentExerciseIndex < workout.exercises.count - 1 {
            isResting = true
        } else {
            workoutComplete = true
        }
    }
    
    private func startRest() {
        restTime = 120
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if restTime > 0 {
                restTime -= 1
            } else {
                startNextExercise()
            }
        }
    }
    
    private func startNextExercise() {
        timer?.invalidate()
        isResting = false
        currentExerciseIndex += 1
    }
}

struct GetReadyView: View {
    var getReadyTime: Int
    var onReady: () -> Void
    var body: some View {
        VStack(spacing: 24) {
            Text("Get Ready")
                .font(.title2)
                .bold()
            ZStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
                Text("\(getReadyTime)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
            .onTapGesture {
                onReady()
            }
            if getReadyTime == 0 {
                Button("Start") {
                    onReady()
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
}

struct RestView: View {
    var restTime: Int
    var onSkipRest: () -> Void
    var body: some View {
        VStack(spacing: 24) {
            Text("Rest")
                .font(.title2)
                .bold()
            Text("")
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

struct WorkoutSummaryView: View {
    var workout: Workout
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Complete!")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(workout.exercises, id: \ .id) { exercise in
                Text("")
                    .font(.title)
            }
            Spacer()
            Button("Done") {
                dismiss()
                // Dismiss or navigate back
                
            }
            .frame(width: 200, height: 30, alignment: .center)
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


