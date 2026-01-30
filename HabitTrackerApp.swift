import SwiftUI
import ServiceManagement

@main
struct HabitTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock (menu bar only app)
        NSApp.setActivationPolicy(.accessory)

        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "checkmark.circle", accessibilityDescription: "Habit Tracker")
            button.action = #selector(togglePopover)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 420, height: 580)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: ContentView())
    }

    @objc func togglePopover(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        // Right-click shows menu
        if event.type == .rightMouseUp {
            showMenu()
            return
        }

        // Left-click toggles popover
        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }

    func showMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Open Habit Tracker", action: #selector(openPopover), keyEquivalent: "o"))
        menu.addItem(NSMenuItem.separator())

        let launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.state = isLaunchAtLoginEnabled() ? .on : .off
        menu.addItem(launchAtLoginItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Habit Tracker", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)

        // Remove menu after it's shown so clicks work normally again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.statusItem?.menu = nil
        }
    }

    @objc func openPopover() {
        if let button = statusItem?.button {
            popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    @objc func toggleLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            let isEnabled = isLaunchAtLoginEnabled()

            do {
                if isEnabled {
                    try SMAppService.mainApp.unregister()
                } else {
                    try SMAppService.mainApp.register()
                }
            } catch {
                print("Failed to toggle launch at login: \(error)")
            }
        }
    }

    func isLaunchAtLoginEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
