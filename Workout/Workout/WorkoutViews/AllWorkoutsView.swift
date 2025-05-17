import SwiftUI
import SwiftData

struct AllWorkoutsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    @Query private var exercises: [Exercise]
    @State private var showingAddWorkout = false
    @State private var selectedWorkouts: Set<Workout> = []
    @State private var showingDeleteAlert = false
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var allWorkouts: [Workout] {
        workouts + SampleData.workouts
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(allWorkouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutCardView(workout: workout)
                            .contextMenu {
                                if !SampleData.workouts.contains(where: { $0.id == workout.id }) {
                                    Button(role: .destructive) {
                                        modelContext.delete(workout)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("All Workouts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddWorkout = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutView(exercises: exercises + SampleData.exercises)
        }
    }
} 