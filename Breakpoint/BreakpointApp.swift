import SwiftUI

@main
struct BreakpointApp: App {
    @State var breakWindowController = BreakWindowController()
    
    @State private var timeRemaining = 25 * 60
    @State private var showTimer = true
    @State private var isBreakTime = false
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(timeRemaining: $timeRemaining, showTimer: $showTimer, isBreakTime: $isBreakTime)
                .environment(breakWindowController)
        } label: {
            HStack {
                if isBreakTime {
                    Image(systemName: "cup.and.heat.waves")
                } else if timeRemaining == 0 {
                    Image(systemName: "alarm.waves.left.and.right")
                } else {
                    Image(systemName: "timer")
                }
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
