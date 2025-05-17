import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query(sort: [SortDescriptor(\ExerciseStat.date, order: .reverse)]) private var stats: [ExerciseStat]
    
    // Group stats by exercise name and sum total reps
    var groupedStats: [(exercise: String, totalReps: Int, sessions: Int)] {
        let grouped = Dictionary(grouping: stats, by: { $0.exerciseName })
        return grouped.map { (name, stats) in
            (exercise: name, totalReps: stats.reduce(0) { $0 + $1.totalReps }, sessions: stats.count)
        }.sorted { $0.exercise < $1.exercise }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if groupedStats.isEmpty {
                    Text("No exercise stats yet. Start a workout to see your progress!")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(groupedStats, id: \.exercise) { stat in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stat.exercise)
                                .font(.headline)
                            HStack {
                                Text("Total reps: \(stat.totalReps)")
                                Spacer()
                                Text("Sessions: \(stat.sessions)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Exercise Statistics")
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: ExerciseStat.self, inMemory: true)
} 
