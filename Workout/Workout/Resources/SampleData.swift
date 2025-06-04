import Foundation

struct SampleData {
    
    static let category: [Category] = {
        // Level 0 - Main Categories
        let upperBody = Category(name: "Upper Body", level: 0)
        let lowerBody = Category(name: "Lower Body", level: 0)
        let core = Category(name: "Core", level: 0)
        let cardio = Category(name: "Cardio", level: 0)
        let fullBody = Category(name: "Full Body", level: 0)
        let flexibility = Category(name: "Flexibility", level: 0)
        let balance = Category(name: "Balance & Stability", level: 0)
        
        // Level 1 - Subcategories
        // Upper Body Subcategories
        let arms = Category(name: "Arms", level: 1, parent: upperBody)
        let shoulders = Category(name: "Shoulders", level: 1, parent: upperBody)
        let chest = Category(name: "Chest", level: 1, parent: upperBody)
        let back = Category(name: "Back", level: 1, parent: upperBody)
        
        // Lower Body Subcategories
        let quads = Category(name: "Quadriceps", level: 1, parent: lowerBody)
        let hamstrings = Category(name: "Hamstrings", level: 1, parent: lowerBody)
        let calves = Category(name: "Calves", level: 1, parent: lowerBody)
        let glutes = Category(name: "Glutes", level: 1, parent: lowerBody)
        
        // Core Subcategories
        let abs = Category(name: "Abs", level: 1, parent: core)
        let obliques = Category(name: "Obliques", level: 1, parent: core)
        let lowerBack = Category(name: "Lower Back", level: 1, parent: core)
        
        // Cardio Subcategories
        let hiit = Category(name: "High Intensity", level: 1, parent: cardio)
        let lowIntensity = Category(name: "Low Intensity", level: 1, parent: cardio)
        let endurance = Category(name: "Endurance", level: 1, parent: cardio)
        
        // Full Body Subcategories
        let compound = Category(name: "Compound Movements", level: 1, parent: fullBody)
        let functional = Category(name: "Functional Training", level: 1, parent: fullBody)
        
        // Flexibility Subcategories
        let staticStretching = Category(name: "Static Stretching", level: 1, parent: flexibility)
        let dynamicStretching = Category(name: "Dynamic Stretching", level: 1, parent: flexibility)
        
        // Balance Subcategories
        let balanceTraining = Category(name: "Balance Training", level: 1, parent: balance)
        let proprioception = Category(name: "Proprioception", level: 1, parent: balance)
        
        // Level 2 - Sub-subcategories
        // Arms Sub-subcategories
        let biceps = Category(name: "Biceps", level: 2, parent: arms)
        let triceps = Category(name: "Triceps", level: 2, parent: arms)
        let forearms = Category(name: "Forearms", level: 2, parent: arms)
        
        // Shoulders Sub-subcategories
        let frontDelts = Category(name: "Front Deltoids", level: 2, parent: shoulders)
        let lateralDelts = Category(name: "Lateral Deltoids", level: 2, parent: shoulders)
        let rearDelts = Category(name: "Rear Deltoids", level: 2, parent: shoulders)
        
        // Chest Sub-subcategories
        let upperChest = Category(name: "Upper Chest", level: 2, parent: chest)
        let middleChest = Category(name: "Middle Chest", level: 2, parent: chest)
        let lowerChest = Category(name: "Lower Chest", level: 2, parent: chest)
        
        // Back Sub-subcategories
        let upperBack = Category(name: "Upper Back", level: 2, parent: back)
        let middleBack = Category(name: "Middle Back", level: 2, parent: back)
        let lowerBackMuscles = Category(name: "Lower Back", level: 2, parent: back)
        
        // Abs Sub-subcategories
        let upperAbs = Category(name: "Upper Abs", level: 2, parent: abs)
        let lowerAbs = Category(name: "Lower Abs", level: 2, parent: abs)
        let transverseAbs = Category(name: "Transverse Abdominis", level: 2, parent: abs)
        
        // Add children to parent categories
        upperBody.children = [arms, shoulders, chest, back]
        lowerBody.children = [quads, hamstrings, calves, glutes]
        core.children = [abs, obliques, lowerBack]
        cardio.children = [hiit, lowIntensity, endurance]
        fullBody.children = [compound, functional]
        flexibility.children = [staticStretching, dynamicStretching]
        balance.children = [balanceTraining, proprioception]
        
        arms.children = [biceps, triceps, forearms]
        shoulders.children = [frontDelts, lateralDelts, rearDelts]
        chest.children = [upperChest, middleChest, lowerChest]
        back.children = [upperBack, middleBack, lowerBackMuscles]
        abs.children = [upperAbs, lowerAbs, transverseAbs]
        
        return [
            upperBody, lowerBody, core, cardio, fullBody, flexibility, balance,
            arms, shoulders, chest, back,
            quads, hamstrings, calves, glutes,
            abs, obliques, lowerBack,
            hiit, lowIntensity, endurance,
            compound, functional,
            staticStretching, dynamicStretching,
            balanceTraining, proprioception,
            biceps, triceps, forearms,
            frontDelts, lateralDelts, rearDelts,
            upperChest, middleChest, lowerChest,
            upperBack, middleBack, lowerBackMuscles,
            upperAbs, lowerAbs, transverseAbs
        ]
    }()
    
    static let exercises: [Exercise] = {
        // Upper Body Exercises
        let pushUps = Exercise(name: "Push-ups", sets: 3, reps: 12, category: category[7], imageName: "pushUp", isSample: true) // Chest
        let pullUps = Exercise(name: "Pull-ups", sets: 3, reps: 8, category: category[10], imageName: "pullUps", isSample: true) // Back
        let bicepCurls = Exercise(name: "Bicep Curls", sets: 3, reps: 12, category: category[28], imageName: "pushUp", isSample: true) // Biceps
        let tricepDips = Exercise(name: "Tricep Dips", sets: 3, reps: 12, category: category[29], imageName: "pushUp", isSample: true) // Triceps
        let shoulderPress = Exercise(name: "Shoulder Press", sets: 3, reps: 10, category: category[31], imageName: "pushUp", isSample: true) // Front Deltoids
        
        // Lower Body Exercises
        let squats = Exercise(name: "Squats", sets: 4, reps: 15, category: category[12], imageName: "squats", isSample: true) // Quadriceps
        let lunges = Exercise(name: "Lunges", sets: 3, reps: 12, category: category[13], imageName: "fitness", isSample: true) // Hamstrings
        let calfRaises = Exercise(name: "Calf Raises", sets: 3, reps: 20, category: category[14], imageName: "fitness", isSample: true) // Calves
        let gluteBridges = Exercise(name: "Glute Bridges", sets: 3, reps: 15, category: category[15], imageName: "fitness", isSample: true) // Glutes
        
        // Core Exercises
        let crunches = Exercise(name: "Crunches", sets: 3, reps: 15, category: category[39], imageName: "fitness", isSample: true) // Upper Abs
        let legRaises = Exercise(name: "Leg Raises", sets: 3, reps: 12, category: category[40], imageName: "fitness", isSample: true) // Lower Abs
        let planks = Exercise(name: "Plank", sets: 3, reps: 1, category: category[41], imageName: "fitness", isSample: true) // Transverse Abs
        let russianTwists = Exercise(name: "Russian Twists", sets: 3, reps: 20, category: category[17], imageName: "fitness", isSample: true) // Obliques
        
        // Cardio Exercises
        let burpees = Exercise(name: "Burpees", sets: 3, reps: 10, category: category[19], imageName: "fitness", isSample: true) // High Intensity
        let jumpingJacks = Exercise(name: "Jumping Jacks", sets: 3, reps: 30, category: category[20], imageName: "fitness", isSample: true) // Low Intensity
        let mountainClimbers = Exercise(name: "Mountain Climbers", sets: 3, reps: 20, category: category[21], imageName: "mountainClimbers", isSample: true) // Endurance
        
        // Full Body Exercises
        let deadlifts = Exercise(name: "Deadlifts", sets: 3, reps: 8, category: category[22], imageName: "fitness", isSample: true) // Compound Movements
        let kettlebellSwings = Exercise(name: "Kettlebell Swings", sets: 3, reps: 15, category: category[23], imageName: "fitness", isSample: true) // Functional Training
        
        return [
            pushUps, pullUps, bicepCurls, tricepDips, shoulderPress,
            squats, lunges, calfRaises, gluteBridges,
            crunches, legRaises, planks, russianTwists,
            burpees, jumpingJacks, mountainClimbers,
            deadlifts, kettlebellSwings
        ]
    }()
    
    static let workouts: [Workout] = {
        // Upper Body Workout
        let upperBodyWorkout = Workout(name: "Upper Body Power", restTimeBetweenExercises: 120, category: category[0], imageName: "pullUps", isSample: true)
        let upperBodyExercise1 = WorkoutExercise(name: exercises[0].name, workout: upperBodyWorkout, sets: 3, reps: 12, category: category[7], imageName: "pushUp", isSample: true) // Push-ups
        let upperBodyExercise2 = WorkoutExercise(name: exercises[1].name, workout: upperBodyWorkout, sets: 3, reps: 8, category: category[10], imageName: "pullUps", isSample: true) // Pull-ups
        let upperBodyExercise3 = WorkoutExercise(name: exercises[2].name, workout: upperBodyWorkout, sets: 3, reps: 12, category: category[28], imageName: "pushUp", isSample: true) // Bicep Curls
        let upperBodyExercise4 = WorkoutExercise(name: exercises[3].name, workout: upperBodyWorkout, sets: 3, reps: 12, category: category[29], imageName: "pushUp", isSample: true) // Tricep Dips
        
        // Lower Body Workout
        let lowerBodyWorkout = Workout(name: "Lower Body Strength", restTimeBetweenExercises: 120, category: category[1], imageName: "pullUps", isSample: true)
        let lowerBodyExercise1 = WorkoutExercise(name: exercises[5].name, workout: lowerBodyWorkout, sets: 4, reps: 15, category: category[12], imageName: "fitness", isSample: true) // Squats
        let lowerBodyExercise2 = WorkoutExercise(name: exercises[6].name, workout: lowerBodyWorkout, sets: 3, reps: 12, category: category[13], imageName: "fitness", isSample: true) // Lunges
        let lowerBodyExercise3 = WorkoutExercise(name: exercises[7].name, workout: lowerBodyWorkout, sets: 3, reps: 20, category: category[14], imageName: "fitness", isSample: true) // Calf Raises
        let lowerBodyExercise4 = WorkoutExercise(name: exercises[8].name, workout: lowerBodyWorkout, sets: 3, reps: 15, category: category[15], imageName: "fitness", isSample: true) // Glute Bridges
        
        // Core Workout
        let coreWorkout = Workout(name: "Core Crusher", restTimeBetweenExercises: 90, category: category[2], imageName: "squats", isSample: true)
        let coreExercise1 = WorkoutExercise(name: exercises[9].name, workout: coreWorkout, sets: 3, reps: 15, category: category[39], imageName: "fitness", isSample: true) // Crunches
        let coreExercise2 = WorkoutExercise(name: exercises[10].name, workout: coreWorkout, sets: 3, reps: 12, category: category[40], imageName: "fitness", isSample: true) // Leg Raises
        let coreExercise3 = WorkoutExercise(name: exercises[11].name, workout: coreWorkout, sets: 3, reps: 1, category: category[41], imageName: "fitness", isSample: true) // Planks
        let coreExercise4 = WorkoutExercise(name: exercises[12].name, workout: coreWorkout, sets: 3, reps: 20, category: category[17], imageName: "fitness", isSample: true) // Russian Twists
        
        // Cardio Workout
        let cardioWorkout = Workout(name: "HIIT Blast", restTimeBetweenExercises: 60, category: category[3], imageName: "mountainClimbers", isSample: true)
        let cardioExercise1 = WorkoutExercise(name: exercises[13].name, workout: cardioWorkout, sets: 3, reps: 10, category: category[19], imageName: "fitness", isSample: true) // Burpees
        let cardioExercise2 = WorkoutExercise(name: exercises[14].name, workout: cardioWorkout, sets: 3, reps: 30, category: category[20], imageName: "fitness", isSample: true) // Jumping Jacks
        let cardioExercise3 = WorkoutExercise(name: exercises[15].name, workout: cardioWorkout, sets: 3, reps: 20, category: category[21], imageName: "fitness", isSample: true) // Mountain Climbers
        
        // Full Body Workout
        let fullBodyWorkout = Workout(name: "Total Body Power", restTimeBetweenExercises: 120, category: category[4], imageName: "fitness", isSample: true)
        let fullBodyExercise1 = WorkoutExercise(name: exercises[16].name, workout: fullBodyWorkout, sets: 3, reps: 8, category: category[22], imageName: "fitness", isSample: true) // Deadlifts
        let fullBodyExercise2 = WorkoutExercise(name: exercises[17].name, workout: fullBodyWorkout, sets: 3, reps: 15, category: category[23], imageName: "fitness", isSample: true) // Kettlebell Swings
        let fullBodyExercise3 = WorkoutExercise(name: exercises[0].name, workout: fullBodyWorkout, sets: 3, reps: 12, category: category[7], imageName: "fitness", isSample: true) // Push-ups
        let fullBodyExercise4 = WorkoutExercise(name: exercises[5].name, workout: fullBodyWorkout, sets: 4, reps: 15, category: category[12], imageName: "fitness", isSample: true) // Squats
        
        // Add exercises to workouts
        upperBodyWorkout.addWorkoutExercise(upperBodyExercise1)
        upperBodyWorkout.addWorkoutExercise(upperBodyExercise2)
        upperBodyWorkout.addWorkoutExercise(upperBodyExercise3)
        upperBodyWorkout.addWorkoutExercise(upperBodyExercise4)
        
        lowerBodyWorkout.addWorkoutExercise(lowerBodyExercise1)
        lowerBodyWorkout.addWorkoutExercise(lowerBodyExercise2)
        lowerBodyWorkout.addWorkoutExercise(lowerBodyExercise3)
        lowerBodyWorkout.addWorkoutExercise(lowerBodyExercise4)
        
        coreWorkout.addWorkoutExercise(coreExercise1)
        coreWorkout.addWorkoutExercise(coreExercise2)
        coreWorkout.addWorkoutExercise(coreExercise3)
        coreWorkout.addWorkoutExercise(coreExercise4)
        
        cardioWorkout.addWorkoutExercise(cardioExercise1)
        cardioWorkout.addWorkoutExercise(cardioExercise2)
        cardioWorkout.addWorkoutExercise(cardioExercise3)
        
        fullBodyWorkout.addWorkoutExercise(fullBodyExercise1)
        fullBodyWorkout.addWorkoutExercise(fullBodyExercise2)
        fullBodyWorkout.addWorkoutExercise(fullBodyExercise3)
        fullBodyWorkout.addWorkoutExercise(fullBodyExercise4)
        
        return [upperBodyWorkout, lowerBodyWorkout, coreWorkout, cardioWorkout, fullBodyWorkout]
    }()
    
    static let challenges: [Challenge] = {
        // 30-Day Upper Body Challenge
        let upperBodyChallenge = Challenge(
            name: "30-Day Upper Body Challenge",
            startDate: Date(),
            category: category[0],
            imageName: "fitness",
            isSample: true
        )
        
        // Create challenge workouts using regular Workout instances
        let upperBodyChallengeWorkout1 = Workout(name: "Push & Pull", restTimeBetweenExercises: 120, category: category[0], imageName: "fitness", isSample: true)
        let upperBodyChallengeWorkout2 = Workout(name: "Arms & Shoulders", restTimeBetweenExercises: 120, category: category[0], imageName: "fitness", isSample: true)
        
        // Add exercises to challenge workouts
        let challengeExercise1 = WorkoutExercise(name: exercises[0].name, workout: upperBodyChallengeWorkout1, sets: 3, reps: 12, category: category[7], imageName: "pushUp", isSample: true)
        let challengeExercise2 = WorkoutExercise(name: exercises[1].name, workout: upperBodyChallengeWorkout1, sets: 3, reps: 8, category: category[10], imageName: "pullUps", isSample: true)
        let challengeExercise3 = WorkoutExercise(name: exercises[2].name, workout: upperBodyChallengeWorkout2, sets: 3, reps: 12, category: category[28], imageName: "pushUp", isSample: true)
        let challengeExercise4 = WorkoutExercise(name: exercises[3].name, workout: upperBodyChallengeWorkout2, sets: 3, reps: 12, category: category[29], imageName: "pushUp", isSample: true)
        
        upperBodyChallengeWorkout1.addWorkoutExercise(challengeExercise1)
        upperBodyChallengeWorkout1.addWorkoutExercise(challengeExercise2)
        upperBodyChallengeWorkout2.addWorkoutExercise(challengeExercise3)
        upperBodyChallengeWorkout2.addWorkoutExercise(challengeExercise4)
        
        // 21-Day Core Challenge
        let coreChallenge = Challenge(
            name: "21-Day Core Challenge",
            startDate: Date(),
            category: category[2],
            imageName: "fitness",
            isSample: true
        )
        
        let coreChallengeWorkout1 = Workout(name: "Core Strength", restTimeBetweenExercises: 90, category: category[2], imageName: "fitness", isSample: true)
        let coreChallengeWorkout2 = Workout(name: "Core Endurance", restTimeBetweenExercises: 90, category: category[2], imageName: "fitness", isSample: true)
        
        let coreChallengeExercise1 = WorkoutExercise(name: exercises[9].name, workout: coreChallengeWorkout1, sets: 3, reps: 15, category: category[39], imageName: "fitness", isSample: true)
        let coreChallengeExercise2 = WorkoutExercise(name: exercises[10].name, workout: coreChallengeWorkout1, sets: 3, reps: 12, category: category[40], imageName: "fitness", isSample: true)
        let coreChallengeExercise3 = WorkoutExercise(name: exercises[11].name, workout: coreChallengeWorkout2, sets: 3, reps: 1, category: category[41], imageName: "fitness", isSample: true)
        let coreChallengeExercise4 = WorkoutExercise(name: exercises[12].name, workout: coreChallengeWorkout2, sets: 3, reps: 20, category: category[17], imageName: "fitness", isSample: true)
        
        coreChallengeWorkout1.addWorkoutExercise(coreChallengeExercise1)
        coreChallengeWorkout1.addWorkoutExercise(coreChallengeExercise2)
        coreChallengeWorkout2.addWorkoutExercise(coreChallengeExercise3)
        coreChallengeWorkout2.addWorkoutExercise(coreChallengeExercise4)
        
        // Add workouts to challenges
        upperBodyChallenge.addChallengeWorkout(upperBodyChallengeWorkout1)
        upperBodyChallenge.addChallengeWorkout(upperBodyChallengeWorkout2)
        
        coreChallenge.addChallengeWorkout(coreChallengeWorkout1)
        coreChallenge.addChallengeWorkout(coreChallengeWorkout2)
        
        return [upperBodyChallenge, coreChallenge]
    }()
}
