import SwiftUI

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var completedDates: [String] // Dates in "yyyy-MM-dd" format
    var currentStreak: Int
    var longestStreak: Int

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.completedDates = []
        self.currentStreak = 0
        self.longestStreak = 0
    }

    var isCompletedToday: Bool {
        let today = DateFormatter.yyyyMMdd.string(from: Date())
        return completedDates.contains(today)
    }
}

class HabitManager: ObservableObject {
    @Published var habits: [Habit] = []

    private let saveKey = "SavedHabits"

    init() {
        loadHabits()
        checkAndResetDay()
    }

    func addHabit(name: String) {
        let habit = Habit(name: name)
        habits.append(habit)
        saveHabits()
    }

    func deleteHabit(id: UUID) {
        habits.removeAll { $0.id == id }
        saveHabits()
    }

    func toggleHabit(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }

        let today = DateFormatter.yyyyMMdd.string(from: Date())

        if habits[index].isCompletedToday {
            // Uncomplete
            habits[index].completedDates.removeAll { $0 == today }
        } else {
            // Complete
            habits[index].completedDates.append(today)
            habits[index].completedDates.sort()
        }

        updateStreaks(for: index)
        saveHabits()
    }

    private func updateStreaks(for index: Int) {
        let sortedDates = habits[index].completedDates.sorted(by: >)

        guard !sortedDates.isEmpty else {
            habits[index].currentStreak = 0
            return
        }

        let today = DateFormatter.yyyyMMdd.string(from: Date())
        let yesterday = DateFormatter.yyyyMMdd.string(from: Date().addingTimeInterval(-86400))

        var currentStreak = 0
        var longestStreak = 0
        var tempStreak = 0

        // Calculate current streak
        if sortedDates.first == today || sortedDates.first == yesterday {
            var checkDate = sortedDates.first == today ? Date() : Date().addingTimeInterval(-86400)

            for dateString in sortedDates {
                let expectedDate = DateFormatter.yyyyMMdd.string(from: checkDate)
                if dateString == expectedDate {
                    currentStreak += 1
                    checkDate = checkDate.addingTimeInterval(-86400)
                } else {
                    break
                }
            }
        }

        // Calculate longest streak
        var previousDate: Date?
        for dateString in sortedDates.reversed() {
            if let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                if let prev = previousDate {
                    let dayDifference = Calendar.current.dateComponents([.day], from: date, to: prev).day ?? 0
                    if dayDifference == 1 {
                        tempStreak += 1
                    } else {
                        longestStreak = max(longestStreak, tempStreak)
                        tempStreak = 1
                    }
                } else {
                    tempStreak = 1
                }
                previousDate = date
            }
        }
        longestStreak = max(longestStreak, tempStreak)

        habits[index].currentStreak = currentStreak
        habits[index].longestStreak = max(longestStreak, currentStreak)
    }

    private func checkAndResetDay() {
        // Recalculate all streaks in case day has changed
        for index in habits.indices {
            updateStreaks(for: index)
        }
    }

    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
