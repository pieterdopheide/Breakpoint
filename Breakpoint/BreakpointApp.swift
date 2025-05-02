import SwiftUI

@main
struct BreakpointApp: App {
    @State var breakWindowController = BreakWindowController()
    
    @State private var timeRemaining = 25 * 60
    @State private var showTimer = true
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(timeRemaining: $timeRemaining, showTimer: $showTimer)
                .environment(breakWindowController)
        } label: {
            HStack {
                Image(systemName: timeRemaining > 0 ? "timer" : "alarm.waves.left.and.right")
                if showTimer {
                    Text("\(timeString(time: timeRemaining))")
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
