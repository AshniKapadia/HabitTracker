import SwiftUI

struct HeatMapView: View {
    let completedDates: [String]
    private let columns = 7 // Days of week
    private let cellSize: CGFloat = 16
    private let cellSpacing: CGFloat = 5
    private let weeksToShow = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Week day labels
            HStack(spacing: cellSpacing) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 9, weight: .black, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.4))
                        .frame(width: cellSize, height: cellSize)
                }
            }

            // Heat map grid
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: columns), spacing: cellSpacing) {
                ForEach(dateRange(), id: \.self) { date in
                    let dateString = DateFormatter.yyyyMMdd.string(from: date)
                    let isCompleted = completedDates.contains(dateString)
                    let isToday = Calendar.current.isDateInToday(date)
                    let isFuture = date > Date()

                    ZStack {
                        if isCompleted {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.5, green: 0.9, blue: 0.3), Color(red: 0.3, green: 0.8, blue: 0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: cellSize, height: cellSize)
                                .shadow(color: Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.3), radius: 2, x: 0, y: 1)
                        } else if !isFuture {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.06))
                                .frame(width: cellSize, height: cellSize)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.02))
                                .frame(width: cellSize, height: cellSize)
                        }

                        if isToday {
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Color(red: 0.4, green: 0.9, blue: 1.0), lineWidth: 2)
                                .frame(width: cellSize + 2, height: cellSize + 2)
                        }
                    }
                    .help(tooltipText(date: date, isCompleted: isCompleted))
                }
            }

            // Legend
            HStack {
                HStack(spacing: 8) {
                    HStack(spacing: 3) {
                        ForEach(0..<4) { level in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(levelColor(level: level))
                                .frame(width: 10, height: 10)
                        }
                    }
                    Text("INTENSITY")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.3))
                        .tracking(0.6)
                }

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.5, green: 0.9, blue: 0.3))
                    Text("\(completedDates.count)")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("DAYS")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.4))
                        .tracking(0.6)
                }
            }
            .padding(.top, 8)
        }
        .padding(18)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.03))

                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
            }
        )
    }

    private func dateRange() -> [Date] {
        let calendar = Calendar.current
        let today = Date()

        // Start from the beginning of the week X weeks ago
        guard let startDate = calendar.date(byAdding: .weekOfYear, value: -weeksToShow + 1, to: today),
              let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate)) else {
            return []
        }

        let totalDays = weeksToShow * 7
        return (0..<totalDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: weekStart)
        }
    }

    private func cellColor(isCompleted: Bool, isFuture: Bool) -> Color {
        if isFuture {
            return Color.white.opacity(0.02)
        }
        if isCompleted {
            return Color(red: 0.5, green: 0.9, blue: 0.3)
        }
        return Color.white.opacity(0.06)
    }

    private func levelColor(level: Int) -> Color {
        switch level {
        case 0:
            return Color.white.opacity(0.06)
        case 1:
            return Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.4)
        case 2:
            return Color(red: 0.5, green: 0.9, blue: 0.3).opacity(0.7)
        case 3:
            return Color(red: 0.5, green: 0.9, blue: 0.3)
        default:
            return Color.white.opacity(0.06)
        }
    }

    private func tooltipText(date: Date, isCompleted: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateStr = formatter.string(from: date)

        if date > Date() {
            return "\(dateStr): Future"
        }
        return "\(dateStr): \(isCompleted ? "Completed ✓" : "Not completed")"
    }
}

// Month grid view (alternative visualization)
struct MonthGridView: View {
    let completedDates: [String]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(currentMonthName())
                .font(.subheadline)
                .fontWeight(.semibold)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daysInCurrentMonth(), id: \.self) { date in
                    if let date = date {
                        let dateString = DateFormatter.yyyyMMdd.string(from: date)
                        let isCompleted = completedDates.contains(dateString)
                        let isToday = Calendar.current.isDateInToday(date)

                        VStack(spacing: 2) {
                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.system(size: 10, weight: isToday ? .bold : .regular))
                                .foregroundColor(isCompleted ? .white : .primary)
                                .frame(width: 24, height: 24)
                                .background(
                                    Circle()
                                        .fill(isCompleted ? Color.green : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        }
                    } else {
                        Color.clear
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(10)
    }

    private func currentMonthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }

    private func daysInCurrentMonth() -> [Date?] {
        let calendar = Calendar.current
        let today = Date()

        guard let interval = calendar.dateInterval(of: .month, for: today),
              let firstWeekday = calendar.dateComponents([.weekday], from: interval.start).weekday else {
            return []
        }

        // Calculate offset for first day of month
        let offset = firstWeekday - calendar.firstWeekday
        var days: [Date?] = Array(repeating: nil, count: offset < 0 ? offset + 7 : offset)

        // Add all days in month
        var currentDate = interval.start
        while currentDate < interval.end {
            days.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }

        return days
    }
}
