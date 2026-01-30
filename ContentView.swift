import SwiftUI

struct ContentView: View {
    @StateObject private var habitManager = HabitManager()
    @State private var showingAddHabit = false
    @State private var newHabitName = ""

    var body: some View {
        ZStack {
            // Gradient background with depth
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.12),
                    Color(red: 0.12, green: 0.10, blue: 0.18)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HABITS")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.4, green: 0.9, blue: 1.0), Color(red: 0.6, green: 0.5, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color(red: 0.4, green: 0.9, blue: 1.0).opacity(0.3), radius: 8, x: 0, y: 2)
                            Text(todayString())
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.5))
                                .textCase(.uppercase)
                                .tracking(1)
                        }

                        Spacer()

                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                                showingAddHabit.toggle()
                            }
                        }) {
                            ZStack {
                                // Glow effect
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.3, blue: 0.6), Color(red: 0.9, green: 0.5, blue: 0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 44, height: 44)
                                    .blur(radius: showingAddHabit ? 12 : 8)
                                    .opacity(0.6)

                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.3, blue: 0.6), Color(red: 0.9, green: 0.5, blue: 0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 40, height: 40)

                                Image(systemName: showingAddHabit ? "xmark" : "plus")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                        .rotationEffect(.degrees(showingAddHabit ? 135 : 0))
                        .scaleEffect(showingAddHabit ? 0.95 : 1.0)
                    }

                    if !habitManager.habits.isEmpty {
                        StatsBar(habits: habitManager.habits)
                    }
                }
                .padding(20)
                .background(
                    Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.4)
                )

                // Habits list
                if habitManager.habits.isEmpty {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.4, green: 0.9, blue: 1.0), Color(red: 0.6, green: 0.5, blue: 1.0)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 90, height: 90)
                                .blur(radius: 30)
                                .opacity(0.4)

                            Image(systemName: "sparkles")
                                .font(.system(size: 56, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.4, green: 0.9, blue: 1.0), Color(red: 1.0, green: 0.3, blue: 0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                        VStack(spacing: 8) {
                            Text("Start Building Habits")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Click the + button to add your first habit")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(habitManager.habits) { habit in
                                HabitCard(habit: habit, habitManager: habitManager)
                            }
                        }
                        .padding(16)
                    }
                }

                // Add habit field
                if showingAddHabit {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.4, green: 0.9, blue: 1.0).opacity(0.2), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 1)

                        HStack(spacing: 12) {
                            TextField("Habit name...", text: $newHabitName)
                                .textFieldStyle(.plain)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .padding(14)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.05))

                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                LinearGradient(
                                                    colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    }
                                )

                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    habitManager.addHabit(name: newHabitName)
                                    newHabitName = ""
                                    showingAddHabit = false
                                }
                            }) {
                                Text("ADD")
                                    .font(.system(size: 13, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .tracking(1)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 14)
                                    .background(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color(red: 0.5, green: 0.9, blue: 0.3), Color(red: 0.3, green: 0.8, blue: 0.5)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )

                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [Color(red: 0.5, green: 0.9, blue: 0.3), Color(red: 0.3, green: 0.8, blue: 0.5)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .blur(radius: 8)
                                                .opacity(0.6)
                                        }
                                    )
                            }
                            .buttonStyle(.plain)
                            .disabled(newHabitName.trimmingCharacters(in: .whitespaces).isEmpty)
                            .opacity(newHabitName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1.0)
                        }
                        .padding(20)
                    }
                    .background(Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.6))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .frame(width: 420, height: 580)
    }

    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

struct StatsBar: View {
    let habits: [Habit]

    var completionRate: Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompletedToday }.count
        return Double(completed) / Double(habits.count)
    }

    var totalStreak: Int {
        habits.reduce(0) { $0 + $1.currentStreak }
    }

    var body: some View {
        HStack(spacing: 1) {
            StatItem(
                icon: "checkmark.circle.fill",
                value: "\(habits.filter { $0.isCompletedToday }.count)/\(habits.count)",
                label: "DONE",
                accentColor: Color(red: 0.5, green: 0.9, blue: 0.3)
            )

            StatItem(
                icon: "flame.fill",
                value: "\(totalStreak)",
                label: "STREAK",
                accentColor: Color(red: 1.0, green: 0.5, blue: 0.2)
            )

            StatItem(
                icon: "chart.bar.fill",
                value: "\(Int(completionRate * 100))%",
                label: "RATE",
                accentColor: Color(red: 0.4, green: 0.9, blue: 1.0)
            )
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.05))

                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 1),
            alignment: .top
        )
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let accentColor: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(accentColor)
            }

            VStack(spacing: 3) {
                Text(value)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.4))
                    .tracking(0.8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}

struct HabitCard: View {
    let habit: Habit
    @ObservedObject var habitManager: HabitManager
    @State private var isExpanded = false
    @State private var showDeleteConfirm = false
    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 18) {
                // Top row: checkbox, name, delete
                HStack(spacing: 16) {
                    // Checkmark button
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                            habitManager.toggleHabit(id: habit.id)
                        }
                    }) {
                        ZStack {
                            if habit.isCompletedToday {
                                // Completed state with glow
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 0.5, green: 0.9, blue: 0.3), Color(red: 0.3, green: 0.8, blue: 0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 56, height: 56)
                                    .shadow(color: Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.5), radius: 12, x: 0, y: 4)

                                Image(systemName: "checkmark")
                                    .font(.system(size: 26, weight: .black))
                                    .foregroundColor(.white)
                            } else {
                                // Uncompleted state
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.05))
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .strokeBorder(Color.white.opacity(0.2), lineWidth: 2)
                                    )

                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(habit.isCompletedToday ? 0.95 : 1.0)

                    // Habit name and mini heatmap
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(habit.name)
                                .font(.system(size: 19, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Spacer()

                            Button(action: {
                                showDeleteConfirm = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(isHovering ? 0.1 : 0.05))
                                        .frame(width: 28, height: 28)

                                    Image(systemName: "xmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color.white.opacity(isHovering ? 0.8 : 0.4))
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        // Mini heat map (last 14 days)
                        MiniHeatMap(completedDates: habit.completedDates)
                    }
                }

                // Stats row
                HStack(spacing: 0) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.2))
                                .frame(width: 32, height: 32)

                            Image(systemName: "flame.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(habit.currentStreak)")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text("STREAK")
                                .font(.system(size: 8, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.4))
                                .tracking(0.6)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if habit.longestStreak > 0 {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 1.0, green: 0.8, blue: 0.2).opacity(0.2))
                                    .frame(width: 32, height: 32)

                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(habit.longestStreak)")
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                Text("BEST")
                                    .font(.system(size: 8, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.white.opacity(0.4))
                                    .tracking(0.6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.4, green: 0.9, blue: 1.0).opacity(0.2))
                                .frame(width: 32, height: 32)

                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.4, green: 0.9, blue: 1.0))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(habit.completedDates.count)")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text("TOTAL")
                                .font(.system(size: 8, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.4))
                                .tracking(0.6)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Expand button
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(isExpanded ? "HIDE DETAILS" : "VIEW DETAILS")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .tracking(0.8)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .foregroundColor(Color(red: 0.4, green: 0.9, blue: 1.0))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.4, green: 0.9, blue: 1.0).opacity(0.1))
                    )
                }
                .buttonStyle(.plain)

                // Full heat map (expanded)
                if isExpanded {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.1), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 1)
                        .padding(.horizontal, -22)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("ACTIVITY HISTORY")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .foregroundColor(Color.white.opacity(0.5))
                            .tracking(1)

                        HeatMapView(completedDates: habit.completedDates)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                }
            }
            .padding(22)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(
                                LinearGradient(
                                    colors: habit.isCompletedToday ?
                                        [Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.5), Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.1)] :
                                        [Color.white.opacity(0.15), Color.white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
            )
            .shadow(color: habit.isCompletedToday ? Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.2) : Color.black.opacity(0.3), radius: 16, x: 0, y: 8)
        .onHover { hovering in
            isHovering = hovering
        }
        .alert("Delete Habit", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation {
                    habitManager.deleteHabit(id: habit.id)
                }
            }
        } message: {
            Text("Are you sure you want to delete '\(habit.name)'? This action cannot be undone.")
        }
    }
}

struct MiniHeatMap: View {
    let completedDates: [String]
    private let daysToShow = 14
    private let cellSize: CGFloat = 10
    private let cellSpacing: CGFloat = 4

    var body: some View {
        HStack(spacing: cellSpacing) {
            ForEach(getLastDays(), id: \.self) { date in
                let dateString = DateFormatter.yyyyMMdd.string(from: date)
                let isCompleted = completedDates.contains(dateString)
                let isToday = Calendar.current.isDateInToday(date)

                ZStack {
                    if isCompleted {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.5, green: 0.9, blue: 0.3), Color(red: 0.3, green: 0.8, blue: 0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: cellSize, height: cellSize)
                    } else {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.08))
                            .frame(width: cellSize, height: cellSize)
                            .overlay(
                                RoundedRectangle(cornerRadius: 3)
                                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    }

                    if isToday {
                        RoundedRectangle(cornerRadius: 3)
                            .strokeBorder(Color(red: 0.4, green: 0.9, blue: 1.0), lineWidth: 2)
                            .frame(width: cellSize + 2, height: cellSize + 2)
                    }
                }
            }
        }
    }

    private func getLastDays() -> [Date] {
        let calendar = Calendar.current
        return (0..<daysToShow).reversed().compactMap { daysAgo in
            calendar.date(byAdding: .day, value: -daysAgo, to: Date())
        }
    }
}
