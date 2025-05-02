import AppKit
import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var breakWindowController: BreakWindowController
    
    @Binding var timeRemaining: Int
    @Binding var showTimer: Bool
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var isRunning = false
    
    @State private var focusTimeInMinutes = 25
    @State private var breakTimeInMinutes = 5
    @State private var isBreakTime = false
    @State private var breakType = BreakType.screenOverlay
    
    var body: some View {
        VStack {
            Text("\(timeString(time: timeRemaining))")
                .font(.system(size: 60, design: .monospaced))
                .foregroundStyle(.white)
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        switch breakType {
                        case .notification:
                            scheduleNotification()
                            if isBreakTime {
                                timeRemaining = focusTimeInMinutes * 60
                            } else {
                                timeRemaining = breakTimeInMinutes * 60
                            }
                            isBreakTime.toggle()
                        case .screenOverlay:
                            stopTimer()
                            breakWindowController.showBreakWindow()
                        }
                    }
                }
            
            Button {
                if isRunning {
                    stopTimer()
                } else {
                    if timeRemaining == 0 {
                        timeRemaining = focusTimeInMinutes * 60
                    }
                    startTimer()
                }
            } label: {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    .foregroundStyle(isBreakTime ? Color.breakpoint : Color.flow)
                    .padding()
            }
            .font(.system(size: 20))
            .background(.white)
            .clipShape(.circle)
            
            Button {
                timeRemaining = focusTimeInMinutes * 60
            } label: {
                // arrow.trianglehead.counterclockwise.rotate
                // arrow.trianglehead.counterclockwise
                Image(systemName: "arrow.counterclockwise")
                    .foregroundStyle(isBreakTime ? Color.breakpoint : Color.flow)
            }
            .background(.white)
            .clipShape(.buttonBorder)
        }
        .onChange(of: breakType) {
            if breakType == .notification {
                requestNotificationPermission()
            }
        }
        .onChange(of: breakWindowController.shouldRestartTimer) {
            if breakWindowController.shouldRestartTimer {
                timeRemaining = focusTimeInMinutes * 60
                breakWindowController.shouldRestartTimer = false
                startTimer()
            }
        }
        .navigationTitle("Breakpoint")
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background((isBreakTime ? Color.breakpoint : Color.flow).ignoresSafeArea())
        .overlay(alignment: .topLeading) {
            Button("Quit", systemImage: "xmark.circle.fill") {
                NSApp.terminate(nil)
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .padding(6)
        }
        .overlay(alignment: .topTrailing) {
            Menu {
                Picker("Focus Time", selection: $focusTimeInMinutes) {
                    Text("1 minute").tag(1)
                    Text("5 minutes").tag(5)
                    Text("10 minutes").tag(10)
                    Text("15 minutes").tag(15)
                    Text("20 minutes").tag(20)
                    Text("25 minutes").tag(25)
                    Text("30 minutes").tag(30)
                }
                
                Toggle("Show Timer", isOn: $showTimer)
                
                Picker("Break Type", selection: $breakType) {
                    Text("Notification").tag(BreakType.notification)
                    Text("Screen Overlay").tag(BreakType.screenOverlay)
                }
            } label: {
                Image(systemName: "gear")
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .padding(6)
            .onChange(of: focusTimeInMinutes) {
                timeRemaining = focusTimeInMinutes * 60
            }
        }
    }
    
    func startTimer() {
        if !isRunning {
            isRunning = true
            timer = Timer.publish(every: 1, on: .main, in: .common)
            _ = timer.connect()
        }
    }
    
    func stopTimer() {
        if isRunning {
            isRunning = false
            timer.connect().cancel()
        }
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        if isBreakTime {
            content.title = "Break time is over"
            content.subtitle = "Let's go at it again!"
            content.sound = UNNotificationSound.default
        } else {
            content.title = "Hit a breakpoint"
            content.subtitle = "Time to take a short break!"
            content.sound = UNNotificationSound.default
        }
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
}

enum BreakType {
    case notification
    case screenOverlay
}

#Preview {
    ContentView(timeRemaining: .constant(25 * 60), showTimer: .constant(true))
}
