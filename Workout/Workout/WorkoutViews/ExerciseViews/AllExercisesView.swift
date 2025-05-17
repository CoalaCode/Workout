import SwiftUI
import SwiftData

struct AllExercisesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    @State private var showingAddExercise = false
    @State private var selectedExercises: Set<Exercise> = []
    @State private var showingDeleteAlert = false
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var allExercises: [Exercise] {
        exercises + SampleData.exercises
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(allExercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        ExerciseCardView(exercise: exercise)
                            .contextMenu {
                                if !SampleData.exercises.contains(where: { $0.id == exercise.id }) {
                                    Button(role: .destructive) {
                                        modelContext.delete(exercise)
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
        .navigationTitle("All Exercises")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddExercise = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView()
        }
    }
} 