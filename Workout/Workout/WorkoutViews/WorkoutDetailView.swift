import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @State private var showingEditSheet = false
    @State private var startSession = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.name)
                        .font(.title)
                        .bold()
                    HStack(spacing: 16) {
                        Label("\(Int(workout.duration)) min", systemImage: "clock")
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Start Workout Button
                Button(action: { startSession = true }) {
                    Text("Start Exercise")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $startSession) {
                    WorkoutSessionView(workout: workout)
                }
                
                // Exercises
                VStack(alignment: .leading, spacing: 12) {
                    Text("Exercises")
                        .font(.headline)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(workout.exercises) { exercise in
                            ExerciseCardView(exercise: exercise)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !SampleData.workouts.contains(where: { $0.id == workout.id }) {
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
            EditWorkoutView(workout: workout)
        }
    }
}


 
