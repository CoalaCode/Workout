//
//  AllChallengesView.swift
//  Workout
//
//  Created by Max Schneider on 15.05.25.
//

import SwiftUI
import SwiftData

struct ChallengeAllView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var challenges: [Challenge]
    
    
    @State private var showingAddChallenge = false
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
    var filteredChallenges: [Challenge] {
        let allWorkouts = challenges + SampleData.challenges
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
                Text("Number of Challenges")
                    .font(.headline)
                Text("\(filteredChallenges.count)")
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
                    ForEach(filteredChallenges) { challenge in
                        NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                            ChallengeAllCardView(challenge: challenge)
                        }
                        .contextMenu {
                            if !SampleData.challenges.contains(where: { $0.id == challenge.id }) {
                                Button(role: .destructive) {
                                    modelContext.delete(challenge)
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
                    showingAddChallenge = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddChallenge) {
            ChallengeAddView()
        }
         
    }
}

/*
#Preview {
    AllChallengesView()
        .modelContainer(for: [Challenge.self, UserChallenge.self], inMemory: true)
}
*/


/*
// Creates a new UserChallenge from a template Challenge and saves it to the database
// - Parameter template: The template Challenge to create from
private func startNewUserChallenge(from template: Challenge) {
let newUserChallenge = UserChallenge(from: template)
print("Creating new user challenge: \(newUserChallenge.name)")
modelContext.insert(newUserChallenge)
do {
    try modelContext.save()
    print("Successfully saved new user challenge")
    createdUserChallenge = newUserChallenge
    navigateToUserChallenge = true
} catch {
    print("Error saving new user challenge: \(error)")
}
}
 */


/*
 .alert("Start this Challenge?", isPresented: $showStartChallengeAlert, presenting: challengeToStart) { challenge in
 Button("Start") {
 startNewUserChallenge(from: challenge)
 }
 Button("Cancel", role: .cancel) {}
 } message: { challenge in
 Text("Do you want to start the challenge '") + Text(challenge.name).bold() + Text("'?")
 }
 .navigationDestination(isPresented: $navigateToUserChallenge) {
 if let userChallenge = createdUserChallenge {
 UserChallengeDetailView(challenge: userChallenge)
 }
 
 }
 */
