import SwiftUI

struct ExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "repeat")
                    Text("\(exercise.sets) sets")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "figure.walk")
                    Text("\(exercise.reps) reps")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 150, height: 120)
            .background(Color(.green))
            .cornerRadius(10)
        }
    }
} 
