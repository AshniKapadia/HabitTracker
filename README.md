# Habit Tracker - macOS Menu Bar App

A beautiful native macOS menu bar application for tracking daily habits with visual progress heat maps.

## Features

- 🎨 **Modern UI** - Beautiful gradient design with smooth animations
- 📊 **Heat Map Visualization** - GitHub-style activity calendar for each habit
- 🔥 **Streak Tracking** - Current and longest streak monitoring
- 📈 **Statistics Dashboard** - Real-time completion rates and total streaks
- ⚡ **Quick Access** - Lives in your menu bar for instant access
- 💾 **Local Storage** - All data stored securely on your Mac
- 🎯 **Expandable Cards** - Click the chart icon to view detailed progress
- ✨ **Smooth Animations** - Satisfying visual feedback for every action

## How to Install & Run

### 🎯 Permanent Installation (Recommended)

Build and install as a standalone app:

```bash
cd ~/Desktop/HabitTracker
./build-app.sh
cp -r ./build/Build/Products/Release/HabitTracker.app /Applications/
open /Applications/HabitTracker.app
```

See [INSTALL.md](INSTALL.md) for detailed installation instructions, including:
- Auto-start at login setup
- Troubleshooting
- Uninstalling

### 🚀 Quick Test Run

For testing during development:

```bash
cd ~/Desktop/HabitTracker
./run.sh
```

This runs the app from Terminal without installing it.

## How to Use

### Basic Usage
1. **Open the app** - Click the checkmark icon in your menu bar
2. **Add a habit** - Click the "+" button and enter your habit name
3. **Complete habits** - Click the circle next to a habit to mark it complete for today
4. **View progress** - Click the chart icon on any habit to see your heat map
5. **Delete habits** - Click the trash icon to remove a habit (with confirmation)

### Understanding the Heat Map
- **Green squares** = Days you completed the habit
- **Gray squares** = Days you didn't complete it
- **Blue outline** = Today
- **Light gray** = Future days
- **12 weeks** of history are shown in a calendar grid
- Hover over any day to see the date and status

### Stats Dashboard
The top bar shows:
- **Today**: Completed habits out of total
- **Total Streak**: Sum of all current streaks
- **Rate**: Overall completion percentage for today

## Data Storage

All habit data is stored locally using UserDefaults in:
```
~/Library/Preferences/com.habittracker.app.plist
```

Your data never leaves your computer.

## Customization

Feel free to modify:
- Window size: Change `contentSize` in HabitTrackerApp.swift:38
- Colors: Adjust colors in ContentView.swift
- Menu bar icon: Change the symbol name in HabitTrackerApp.swift:29

## Building for Distribution

To create a standalone .app:

1. In Xcode, select Product → Archive
2. Click "Distribute App"
3. Choose "Copy App"
4. The .app file can be moved to /Applications

Enjoy tracking your habits! 🎯
