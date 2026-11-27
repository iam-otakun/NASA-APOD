//
//  AppDelegate.swift
//  NASA APOD
//
//  A menu-bar-only app (LSUIElement): AppDelegate wires the
//  service, the menu and the two programmatic windows together.
//  Launch behaviour follows the house rule from BingWallpaper
//  0.8.0: a login-item launch stays silent in the menu bar; only a
//  launch the user started shows the Settings window.
//

import Cocoa

/// Explicit entry point: create the delegate, hand it to the
/// shared application and run. (The `@main`-on-the-delegate
/// synthesis left the delegate unwired in this storyboard-less
/// setup — the app ran its event loop without ever hearing
/// applicationDidFinishLaunching.)
@main
struct AppMain {
    static func main() {
        let delegate = AppDelegate()
        let app = NSApplication.shared
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private let service = ApodService()
    private lazy var menuController = MenuController(service: service)
    private lazy var settingsWc = SettingsWindowController()
    private lazy var detailWc = DetailWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Single-instance guard first, before any menu or window
        // work: copies of this app kept at different paths over
        // time could each register a login item, so macOS can
        // launch several instances at login — every extra instance
        // used to open its own Settings window and fight over the
        // shared config. Only one instance ever runs: a duplicate
        // launch asks the running instance to show itself (exactly
        // like a manual launch, unless the duplicate came from a
        // login item, which stays silent) and then terminates.
        if otherRunningInstance() != nil {
            if launchedAsLoginItem == false {
                postShowExistingInstanceNotification()
            }
            NSApp.terminate(nil)
            return
        }
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(showExistingInstanceRequested),
            name: Self.showExistingInstanceNotification,
            object: nil
        )

        menuController.onShowSettings = { [weak self] in
            self?.showSettings()
        }
        menuController.onShowDetail = { [weak self] entry in
            guard let self else { return }
            self.detailWc.present(entry: entry, preloadedImage: self.service.displayImage)
        }
        menuController.setup()

        settingsWc.onArchiveSettingsChanged = { [weak self] in
            // Re-run the fetch so today lands in the new folder too;
            // existing files are skipped, so this stays cheap.
            self?.service.refresh()
        }

        service.start()

        if launchedAsLoginItem == false {
            showSettings()
        }

        Task {
            await AppUpdateManager.checkForUpdate()
        }
    }

    private func showSettings() {
        settingsWc.showWindow(nil)
    }

    /// Another already-running instance of this app (same bundle
    /// identifier, from any path on disk), if there is one.
    private func otherRunningInstance() -> NSRunningApplication? {
        guard let bundleID = Bundle.main.bundleIdentifier else { return nil }
        return NSRunningApplication
            .runningApplications(withBundleIdentifier: bundleID)
            .first { $0.processIdentifier != ProcessInfo.processInfo.processIdentifier }
    }

    /// Posted by a duplicate launch so the instance already
    /// running shows itself, the way a manual launch does.
    private static var showExistingInstanceNotification: Notification.Name {
        Notification.Name((Bundle.main.bundleIdentifier ?? "com.otakun.NASAApod") + ".showExistingInstance")
    }

    private func postShowExistingInstanceNotification() {
        DistributedNotificationCenter.default().postNotificationName(
            Self.showExistingInstanceNotification,
            object: nil,
            userInfo: nil,
            deliverImmediately: true
        )
    }

    @objc private func showExistingInstanceRequested() {
        showSettings()
    }

    /// `true` when macOS launched the app as a login item (the open
    /// application Apple event then carries the
    /// `keyAELaunchedAsLogInItem` parameter).
    private var launchedAsLoginItem: Bool {
        guard let event = NSAppleEventManager.shared().currentAppleEvent,
              event.eventID == AEEventID(kAEOpenApplication) else {
            return false
        }
        return event.paramDescriptor(forKeyword: keyAELaunchedAsLogInItem) != nil
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Activating the already running app (Dock or Finder icon
        // click) brings Settings up, like a manual launch. Becoming
        // active by itself (e.g. after a login-item launch) must not.
        if flag == false {
            showSettings()
        }
        return false
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
