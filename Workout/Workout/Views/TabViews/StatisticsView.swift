import SwiftUI
import SwiftData
import Charts // Import Charts

// ViewModel to prepare data for the StatisticsView
class StatisticsViewModel: ObservableObject {
    @Published var totalWorkoutsCompleted: Int = 0
    @Published var totalExerciseReps: Int = 0
    @Published var workoutSessionsPerDay: [DailyStat] = []
    @Published var exerciseRepsPerDay: [DailyStat] = []

    // Sample data initialization - replace with actual data fetching
    init(mock: Bool = false) {
        if mock {
            // Sample data for workout sessions per day
            workoutSessionsPerDay = [
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 2),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 1),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 3),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 2),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 4),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 1),
                DailyStat(date: Date(), count: 3)
            ]
            totalWorkoutsCompleted = workoutSessionsPerDay.reduce(0) { $0 + $1.count }

            // Sample data for exercise reps per day
            exerciseRepsPerDay = [
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 150),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 120),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 200),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 180),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 220),
                DailyStat(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 100),
                DailyStat(date: Date(), count: 170)
            ]
            totalExerciseReps = exerciseRepsPerDay.reduce(0) { $0 + $1.count }
        }
    }

    // Function to load and process actual data from SwiftData
    func loadData(workoutStats: [WorkoutStat], exerciseStats: [ExerciseStat]) {
        // Process WorkoutStats
        totalWorkoutsCompleted = workoutStats.count
        let groupedWorkouts = Dictionary(grouping: workoutStats, by: { Calendar.current.startOfDay(for: $0.date) })
        workoutSessionsPerDay = groupedWorkouts.map { DailyStat(date: $0.key, count: $0.value.count) }.sorted(by: { $0.date < $1.date })

        // Process ExerciseStats
        totalExerciseReps = exerciseStats.reduce(0) { $0 + $1.totalReps }
        let groupedExercises = Dictionary(grouping: exerciseStats, by: { Calendar.current.startOfDay(for: $0.date) })
        exerciseRepsPerDay = groupedExercises.map { DailyStat(date: $0.key, count: $0.value.reduce(0) { $0 + $1.totalReps }) }.sorted(by: { $0.date < $1.date })
    }
}

// Data structure for chart data
struct DailyStat: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    
    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // "E" gives short day name e.g., "Mon"
        return formatter.string(from: date)
    }
}

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel(mock: true) // Use mock data for now

    @Query(sort: [SortDescriptor(\WorkoutStat.date, order: .forward)]) private var workoutStats: [WorkoutStat]
    @Query(sort: [SortDescriptor(\ExerciseStat.date, order: .forward)]) private var exerciseStats: [ExerciseStat]
    
    // Date formatter for the header
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d. MMMM" // Example: "Montag, 2. Juni"
        return formatter
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Text
                    Text(dateFormatter.string(from: Date()).uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    Text("Übersicht") // Overview
                        .font(.largeTitle).bold()
                        .padding(.horizontal)

                    // Exercise Reps Card
                    NavigationLink(destination: StatsDetailView(exercises: viewModel.exerciseRepsPerDay)) {
                        StatsCardView(
                            title: "Exercises",
                            value: "\(viewModel.totalExerciseReps)",
                            subtitle: "Insgesamt",
                            iconName: "flame.fill",
                            iconColor: .red,
                            chartData: viewModel.exerciseRepsPerDay
                        )
                    }
                    .padding(.horizontal)
                   
                    
                    // Workout Stats Card
                    NavigationLink(destination: StatsDetailView(workouts: viewModel.workoutSessionsPerDay)) {
                        StatsCardView(
                            title: "Workouts",
                            value: "\(viewModel.totalWorkoutsCompleted)",
                            subtitle: "Insgesamt abgeschlossen",
                            iconName: "figure.walk",
                            iconColor: .orange,
                            chartData: viewModel.workoutSessionsPerDay
                        )
                    }
                    .padding(.horizontal)
                    
                    // Challenge Reps Card
                    StatsCardView(
                        title: "Challenges", // Exercise Repetitions
                        value: "\(viewModel.totalExerciseReps)",
                        subtitle: "Insgesamt", // Total
                        iconName: "flame.fill",
                        iconColor: .red,
                        chartData: viewModel.exerciseRepsPerDay
                    )
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistiken") // Statistics
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea()) // Match system background
            .onAppear {
                 viewModel.loadData(workoutStats: workoutStats, exerciseStats: exerciseStats)
            }
        }
    }
}


/*
    @Query(sort: [SortDescriptor(\ExerciseStat.date, order: .reverse)]) private var exerciseStat: [ExerciseStat]
    
    @Query(sort: [SortDescriptor(\WorkoutStat.date, order: .reverse)]) private var workoutStat: [WorkoutStat]
    
    //@Query(sort: [SortDescriptor(\ChallengeStat.startDate, order: .reverse)]) private var challengeStat: [ChallengeStat]
    
    @State private var searchText = ""
    
    // Group stats by exercise name and sum total reps
    var groupedExerciseStats: [(exercise: String, totalReps: Int, sessions: Int)] {
        let grouped = Dictionary(grouping: exerciseStat, by: { $0.exercise?.name ?? "Unknown Exercise" })
        return grouped.map { (name, stats) in
            (exercise: name ?? "Unknown Exercise", totalReps: stats.reduce(0) { $0 + $1.totalReps }, sessions: stats.count)
        }.sorted { $0.exercise < $1.exercise }
    }
    
    // Group stats by workout name and sum total duration
    var groupedWorkoutStats: [(workout: String, restTimeBetweenExercises: Int, sessions: Int)] {
        let grouped = Dictionary(grouping: workoutStat, by: { $0.name })
        return grouped.map { (name, stats) in
            (workout: name,
             restTimeBetweenExercises: 120,
             sessions: stats.count)
        }.sorted { $0.workout < $1.workout }
    }
    /*
    // Group stats by challenge name
    var groupedChallengeStats: [(challenge: String, completedWorkouts: Int, totalWorkouts: Int, durationDays: Int)] {
        let grouped = Dictionary(grouping: challengeStat, by: { $0.name })
        return grouped.map { (name, stats) in
            let totalWorkouts = stats.first?.workouts.count ?? 0
            let completedWorkouts = stats.first?.completedWorkoutIDs.count ?? 0
            let durationDays = stats.first?.durationDays ?? 0
            return (challenge: name, completedWorkouts: completedWorkouts, totalWorkouts: totalWorkouts, durationDays: durationDays)
        }.sorted { $0.challenge < $1.challenge }
    }
    */
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                // All Exercise Section
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Exercise Statistics")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(groupedExerciseStats, id: \.exercise) { groupedStat in
                                let representativeStat = exerciseStat.first(where: { $0.exercise?.name == groupedStat.exercise })!
                                
                                // Use a modified version of StatsCardView
                                GroupedStatsCardView(
                                    exerciseName: groupedStat.exercise,
                                    totalReps: groupedStat.totalReps,
                                    sessions: groupedStat.sessions,
                                    representativeStat: representativeStat
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // All Workouts Section
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Workout Statistics")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(groupedWorkoutStats, id: \.workout) { groupedWorkoutStat in
                                let representativeWorkoutStat = workoutStat.first(where: { $0.name == groupedWorkoutStat.workout })!
                                
                                // Use a modified version of StatsCardView
                                GroupedWorkoutStatsCardView(
                                    workoutName: groupedWorkoutStat.workout,
                                    sessions: groupedWorkoutStat.sessions,
                                    representativeStat: representativeWorkoutStat
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                /*
                // All challenges Section
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Challenge Statistics")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if groupedChallengeStats.isEmpty {
                        Text("No completed challenges yet")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(groupedChallengeStats, id: \.challenge) { groupedChallengeStat in
                                    let representativeChallengeStat = challengeStat.first(where: { $0.name == groupedChallengeStat.challenge })!
                                    
                                    GroupedChallengeStatsCardView(
                                        challengeName: groupedChallengeStat.challenge,
                                        completedWorkouts: groupedChallengeStat.completedWorkouts,
                                        totalWorkouts: groupedChallengeStat.totalWorkouts,
                                        durationDays: groupedChallengeStat.durationDays,
                                        representativeStat: representativeChallengeStat
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                 */
            }
            .navigationTitle("Statistics")
            .searchable(text: $searchText, prompt: "Search workouts")
        }
    }
     */

/*
// New view for displaying grouped stats
struct GroupedStatsCardView: View {
    let exerciseName: String
    let totalReps: Int
    let sessions: Int
    let representativeStat: ExerciseStat
    
    var body: some View {
        NavigationLink(destination: StatsDetailView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text(exerciseName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "person.2")
                    Text("\(sessions) sessions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Image(systemName: "figure.walk")
                    Text("\(totalReps) total reps")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 180, height: 120)
            .background(LinearGradient(gradient: Gradient(colors: [.cyan, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
        }
    }
}

// New view for displaying grouped wokrout stats
struct GroupedWorkoutStatsCardView: View {
    let workoutName: String
    let sessions: Int
    let representativeStat: WorkoutStat
    
    var body: some View {
        NavigationLink(destination: StatsDetailView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text(workoutName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "person.2")
                    Text("\(sessions) sessions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 180, height: 120)
            .background(Color(.green))
            .cornerRadius(10)
        }
    }
}

// New view for displaying grouped challenge stats
struct GroupedChallengeStatsCardView: View {
    let challengeName: String
    let completedWorkouts: Int
    let totalWorkouts: Int
    let durationDays: Int
    let representativeStat: ChallengeStat
    
    var body: some View {
        NavigationLink(destination: StatsDetailView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text(challengeName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("\(completedWorkouts)/\(totalWorkouts) workouts")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "calendar")
                    Text("\(durationDays) days")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 180, height: 120)
            .background(Color(.green))
            .cornerRadius(10)
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: ExerciseStat.self, inMemory: true)
} 
*/
