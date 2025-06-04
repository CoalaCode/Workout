import SwiftUI
import SwiftData

/*
struct ChallengeEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var workouts: [Workout]
    @State private var name: String
    @State private var durationDays: Int
    @State private var selectedWorkouts: [Workout]
    @State private var searchText = ""
    
    private var challenge: Challenge?
    
    init(challenge: Challenge? = nil) {
        self.challenge = challenge
        _name = State(initialValue: challenge?.name ?? "")
        _durationDays = State(initialValue: challenge?.durationDays ?? 7)
        _selectedWorkouts = State(initialValue: challenge?.workouts ?? [])
    }
    
    var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return workouts
        }
        return workouts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Challenge Details") {
                    TextField("Name", text: $name)
                    Stepper("Duration: \(durationDays) days", value: $durationDays, in: 1...365)
                }
                
                Section("Workouts") {
                    ForEach(selectedWorkouts) { workout in
                        HStack {
                            Text(workout.name)
                            Spacer()
                            Button(role: .destructive) {
                                if let index = selectedWorkouts.firstIndex(where: { $0.uuid == workout.uuid }) {
                                    selectedWorkouts.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }
                        }
                    }
                    .onMove { from, to in
                        selectedWorkouts.move(fromOffsets: from, toOffset: to)
                    }
                }
                
                Section("Add Workouts") {
                    ForEach(filteredWorkouts) { workout in
                        if !selectedWorkouts.contains(where: { $0.uuid == workout.uuid }) {
                            Button {
                                selectedWorkouts.append(workout)
                            } label: {
                                HStack {
                                    Text(workout.name)
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(challenge == nil ? "New Challenge" : "Edit Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChallenge()
                        dismiss()
                    }
                    .disabled(name.isEmpty || selectedWorkouts.isEmpty)
                }
            }
            .searchable(text: $searchText, prompt: "Search workouts")
        }
    }
    
    private func saveChallenge() {
        if let challenge = challenge {
            // Update existing challenge
            challenge.name = name
            challenge.durationDays = durationDays
            challenge.challengeWorkouts.removeAll()
            for workout in selectedWorkouts {
                challenge.addWorkout(workout)
            }
        } else {
            // Create new challenge
            let newChallenge = Challenge(
                name: name,
                startDate: Date(),
                durationDays: durationDays
            )
            for workout in selectedWorkouts {
                newChallenge.addWorkout(workout)
            }
            modelContext.insert(newChallenge)
        }
        
        try? modelContext.save()
    }
} 
*/
