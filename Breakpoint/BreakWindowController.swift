import AppKit
import Foundation
import SwiftUI

class BreakWindowController: ObservableObject {
    private var breakWindow: NSWindow?
    
    @Published var shouldRestartTimer = false
    
    func showBreakWindow() {
        // Create a full-screen NSWindow
        let window = NSWindow(
            contentRect: NSScreen.main?.frame ?? NSRect.zero,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = true
        window.backgroundColor = NSColor.clear
        window.level = .screenSaver // Ensures it covers the dock and menu bar
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // Makes it full-screen across all spaces
        
        // Embed the SwiftUI view with the environment object
        let hostingView = NSHostingView(rootView: BreakView().environmentObject(self)) // Pass the BreakWindowController
        window.contentView = hostingView
        
        // Show the window
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false
        
        // Keep a reference to the window
        self.breakWindow = window
    }
    
    func closeBreakWindow() {
        breakWindow?.close()
        breakWindow = nil
        
        shouldRestartTimer = true
    }
}
