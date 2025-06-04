import SwiftUI

struct ExerciseActiveView: View {
    // Input data
    let exercise: Exercise?
    let workoutExercise: WorkoutExercise?
    
    // Configuration
    let isPartOfWorkout: Bool
    
    // Callbacks
    var onExerciseComplete: (() -> Void)?
    
    // View state
    @State private var currentSet = 1
    @State private var currentRep = 1
    @State private var isFinished = false
    @State private var showSummary = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Computed properties
    private var effectiveSets: Int {
        return workoutExercise?.sets ?? exercise?.sets ?? 0
    }
    
    private var effectiveReps: Int {
        return workoutExercise?.reps ?? exercise?.reps ?? 0
    }
    
    private var exerciseName: String {
        return workoutExercise?.name ?? exercise?.name ?? "Unknown Exercise"
    }
    
    // Standalone exercise initializer
    init(exercise: Exercise) {
        self.exercise = exercise
        self.workoutExercise = nil
        self.isPartOfWorkout = false
    }
    
    // Workout exercise initializer
    init(workoutExercise: WorkoutExercise) {
        self.workoutExercise = workoutExercise
        self.exercise = nil
        self.isPartOfWorkout = true
        self.onExerciseComplete = nil
    }
    
    // Workout exercise initializer
    init(workoutExercise: WorkoutExercise, onExerciseComplete: @escaping () -> Void) {
        self.workoutExercise = workoutExercise
        self.exercise = nil
        self.isPartOfWorkout = true
        self.onExerciseComplete = onExerciseComplete
    }
    
    var body: some View {
        if showSummary && !isPartOfWorkout {
            if let exercise = exercise {
                ExerciseSummaryView(exercise: exercise)
            }
        } else {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    // Exercise Image
                    Image("yoga")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                        .clipped()
                        .overlay(
                            VStack {
                                Spacer()
                                Text(exerciseName)
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
                        .ignoresSafeArea(edges: .top)
                
                    Spacer()
                    
                    VStack(spacing: 40) {
                        ZStack {
                            Circle()
                                .opacity(0.3)
                                .foregroundColor(.gray)
                                
                            Circle()
                                .trim(from: 0.0, to: CGFloat(currentRep) / CGFloat(effectiveReps))
                                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                .foregroundColor(.blue)
                                .rotationEffect(Angle(degrees: 270.0))
                                
                            Text("\(currentRep)")
                                .font(.system(size: 70))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 200)
                        .onTapGesture {
                            advanceExercise()
                        }
                        .padding(.top, 40)
                        
                        Button("End Exercise") {
                            saveStat()
                            finishExercise()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    private var setString: String {
        Array(repeating: "\(effectiveReps)", count: effectiveSets).joined(separator: " - ")
    }
    
    private func saveStat() {
        // Only save stats for standalone exercises
        if let exercise = exercise {
            let stat = ExerciseStat(
                exercise: exercise
            )
            modelContext.insert(stat)
        }
    }
    
    private func advanceExercise() {
        currentRep += 1
        
        if currentRep > effectiveReps {
            currentRep = 1
            currentSet += 1
            
            if currentSet > effectiveSets {
                finishExercise()
            }
        }
    }
    
    private func finishExercise() {
        isFinished = true
        
        if isPartOfWorkout {
            // In workout mode, notify the parent view and don't save stats
            saveStat()
            onExerciseComplete?()
        } else {
            // In standalone mode, save stats and show summary
            saveStat()
            showSummary = true
        }
    }
}

/* in line 148 in saveStat()
 else if let workoutExercise = workoutExercise {
     let stat = ExerciseStat(
         workoutExercise: workoutExercise
     )
     modelContext.insert(stat)
 }
 */
