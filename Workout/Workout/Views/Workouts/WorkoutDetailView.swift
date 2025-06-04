import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    // Input data
    let workout: Workout?
    let challengeWorkout: ChallengeWorkout?
    
    @State private var isActiveWorkout = false
    @State private var showingEditSheet = false
    @State private var startSession = false
    
    // Computed properties to handle optional values
    private var workoutName: String {
        return challengeWorkout?.name ?? workout?.name ?? "Unknown Workout"
    }
    
    private var exercises: [WorkoutExercise] {
        return challengeWorkout?.workoutExercises ?? workout?.workoutExercises ?? []
    }
    
    private var sortedExercises: [WorkoutExercise] {
        return exercises.sorted(by: { $0.order < $1.order })
    }
    
    private var restTimeBetweenExercises: Int {
        return challengeWorkout?.restTimeBetweenExercises ?? workout?.restTimeBetweenExercises ?? 120
    }
    
    // Initializer for Workout
    init(workout: Workout) {
        self.workout = workout
        self.challengeWorkout = nil
    }
    
    // Initializer for ChallengeWorkout
    init(challengeWorkout: ChallengeWorkout) {
        self.challengeWorkout = challengeWorkout
        self.workout = nil
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
                        Text(workoutName)
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
                        HStack {
                            Text("Rest between exercises:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(restTimeBetweenExercises)")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    
                    // Exercises
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Exercises")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(sortedExercises) { workoutExercise in
                                    ExerciseCardView(workoutExercise: workoutExercise)
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
                .padding(.horizontal)
                .padding(.bottom, 8)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let workout = workout, !SampleData.workouts.contains(where: { $0.id == workout.id }) {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
        
        .sheet(isPresented: $showingEditSheet) {
            if let workout = workout {
                WorkoutEditView(workout: workout)
            }
        }
        .navigationDestination(isPresented: $isActiveWorkout) {
            if let workout = workout {
                WorkoutActiveView(workout: workout)
            } else if let challengeWorkout = challengeWorkout {
                WorkoutActiveView(challengeWorkout: challengeWorkout)
            }
        }
    }
}

/*
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)
    
    let exercise1 = Exercise(name: "Push Ups", sets: 3, reps: 15)
    let exercise2 = Exercise(name: "Squats", sets: 3, reps: 15)
    let workout = Workout(name: "Upper Body Blast")
    workout.addExercise(exercise1)
    workout.addExercise(exercise2)
    
    return NavigationStack {
        WorkoutDetailView(workout: workout)
    }
    .modelContainer(container)
}
*/

 
