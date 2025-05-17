import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @State private var showingEditSheet = false
    @State private var startSession = false
    @State private var isRestingWorkout = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exercise.name)
                            .font(.title)
                            .bold()
                        
                        HStack(spacing: 16) {
                            Label("\(exercise.sets) sets", systemImage: "number.circle")
                            Label("\(exercise.reps) reps", systemImage: "repeat")
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Start Exercise Button
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
                        ExerciseSessionView(exercise: exercise, source: .singleExercise, isRestingWorkout: $isRestingWorkout)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(getExerciseDescription(for: exercise.name))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to Perform")
                            .font(.headline)
                        
                        Text(getExerciseInstructions(for: exercise.name))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !SampleData.exercises.contains(where: { $0.id == exercise.id }) {
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
                EditExerciseView(exercise: exercise)
            }
        }
    }
    
    private func getExerciseDescription(for name: String) -> String {
        switch name.lowercased() {
        case "push-ups":
            return "Push-ups are a classic bodyweight exercise that targets the chest, shoulders, and triceps. They also engage your core and help build upper body strength."
        case "squats":
            return "Squats are a fundamental lower body exercise that targets the quadriceps, hamstrings, and glutes. They also engage your core and help improve overall leg strength."
        case "pull-ups":
            return "Pull-ups are an excellent upper body exercise that primarily targets the back and biceps. They help build upper body strength and improve posture."
        case "lunges":
            return "Lunges are a unilateral exercise that targets the quadriceps, hamstrings, and glutes. They help improve balance and leg strength."
        case "plank":
            return "The plank is an isometric core exercise that strengthens your abdominal muscles, lower back, and shoulders. It helps improve posture and core stability."
        case "burpees":
            return "Burpees are a full-body exercise that combines a squat, push-up, and jump. They provide an excellent cardiovascular workout while building strength."
        case "mountain climbers":
            return "Mountain climbers are a dynamic exercise that targets the core while providing a cardiovascular workout. They help improve coordination and endurance."
        case "jumping jacks":
            return "Jumping jacks are a classic cardio exercise that works the entire body. They help improve cardiovascular fitness and coordination."
        default:
            return "A great exercise for building strength and improving fitness."
        }
    }
    
    private func getExerciseInstructions(for name: String) -> String {
        switch name.lowercased() {
        case "push-ups":
            return "1. Start in a plank position with hands slightly wider than shoulders\n2. Lower your body until your chest nearly touches the floor\n3. Push your body back up to the starting position\n4. Keep your core tight and body straight throughout the movement"
        case "squats":
            return "1. Stand with feet shoulder-width apart\n2. Lower your body by bending your knees and pushing your hips back\n3. Keep your chest up and back straight\n4. Lower until thighs are parallel to the ground\n5. Push through your heels to return to standing"
        case "pull-ups":
            return "1. Hang from a bar with hands slightly wider than shoulders\n2. Pull your body up until your chin is over the bar\n3. Lower your body back down with control\n4. Keep your core engaged throughout the movement"
        case "lunges":
            return "1. Stand with feet together\n2. Step forward with one leg and lower your body\n3. Keep your front knee above your ankle\n4. Push back to starting position\n5. Repeat with the other leg"
        case "plank":
            return "1. Start in a push-up position\n2. Bend your elbows and rest on your forearms\n3. Keep your body straight from head to heels\n4. Hold the position while engaging your core"
        case "burpees":
            return "1. Start standing\n2. Drop into a squat position\n3. Kick your feet back into a push-up position\n4. Do a push-up\n5. Jump your feet back to squat position\n6. Jump up with arms overhead"
        case "mountain climbers":
            return "1. Start in a push-up position\n2. Bring one knee toward your chest\n3. Return to starting position\n4. Repeat with the other leg\n5. Continue alternating legs at a quick pace"
        case "jumping jacks":
            return "1. Start standing with feet together\n2. Jump feet apart while raising arms overhead\n3. Jump back to starting position\n4. Keep a steady rhythm"
        default:
            return "Perform the exercise with proper form and control."
        }
    }
} 
