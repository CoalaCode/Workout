import SwiftUI
import SwiftData

struct WorkoutAllView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var workouts: [Workout]
    //@Query private var exercises: [WorkoutExercise]

    @State private var showingAddWorkout = false
    //@State private var selectedWorkouts: Set<Workout> = []
    //@State private var showingDeleteAlert = false
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    
    var filteredCategories: [Category] {
        let allCategories = SampleData.category
        if searchText.isEmpty {
            return allCategories
        }
        return allCategories.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
    }
    
    // Returns all exercises, including sample data, filtered by search text
    var filteredWorkouts: [Workout] {
        let allWorkouts = workouts + SampleData.workouts
        var filtered = allWorkouts
        
        // Apply category filter if a category is selected
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category?.name == selectedCategory.name }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    
    var body: some View {
        NavigationStack {
            //Header
            HStack {
                Text("Number of Workouts")
                    .font(.headline)
                Text("\(filteredWorkouts.count)")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Add "All" category option
                    Button(action: {
                        selectedCategory = nil
                    }) {
                        VStack {
                            Text("All")
                                .foregroundColor(.white)
                        }
                        .frame(width: 132, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selectedCategory == nil ? Color.blue : Color.gray.opacity(0.2))
                        )
                    }
                    
                    ForEach(filteredCategories) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            VStack {
                                Text("\(category.name)")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 132, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(selectedCategory?.name == category.name ? Color.blue : Color.gray.opacity(0.2))
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(filteredWorkouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutAllCardView(workout: workout)
                        }
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
            .searchable(text: $searchText, prompt: "Search Workouts")
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
            WorkoutAddView()
        }
    }
} 

