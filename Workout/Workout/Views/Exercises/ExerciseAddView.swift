import SwiftUI
import SwiftData

struct ExerciseAddView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var sets = 3
    @State private var reps = 10
    @State private var selectedCategory: Category?
    
    // Remove @Query and only use sample categories
    private var categories: [Category] {
        SampleData.category
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Exercise Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select a category").tag(nil as Category?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }
                    
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    
                    Stepper("Reps: \(reps)", value: $reps, in: 1...100)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExercise()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveExercise() {
        let exercise = Exercise(name: name, sets: sets, reps: reps, category: selectedCategory, imageName: "fitness")
        modelContext.insert(exercise)
        dismiss()
    }
} 
