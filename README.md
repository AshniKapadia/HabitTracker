# habit tracker

This is a lil macOS menu bar app i made for tracking habits. 

## what it does

basically you can track your daily habits and see how you're doing over time. got some nice gradients and animations to make it feel good to use. lives in your menu bar so it's always there when you need it.

- heat maps that show your progress (green = you did the thing)
- tracks your streaks so you can feel good about consistency
- shows stats at the top
- all your data stays on your computer, nowhere else
- click "VIEW DETAILS" to see the full calendar
- smooth animations that are kinda satisfying 

## how to run it

### if you wanna  use it:

```bash
cd ~/Desktop/HabitTracker
./build-app.sh
cp -r ./build/Build/Products/Release/HabitTracker.app /Applications/
open /Applications/HabitTracker.app
```

check out [INSTALL.md](INSTALL.md) if you want it to start automatically when you login or if something breaks

### just testing it out:

```bash
cd ~/Desktop/HabitTracker
./run.sh
```

## using it

pretty straightforward:
1. click the checkmark in your menu bar to open it
2. hit the + button to add a habit
3. click the circle to mark a habit done for today
4. click VIEW DETAILS to see your full history
5. hit the X to delete habits (it'll ask you to confirm so you don't accidentally delete stuff)

the heat map shows green squares for days you did the habit, gray for days you didn't. the blue outline is today. hover over squares to see the exact date.

## where's my data?

everything's stored locally in `~/Library/Preferences/com.habittracker.app.plist`

it doesn't go anywhere else, promise
