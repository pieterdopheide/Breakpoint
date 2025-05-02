import SwiftUI

struct BreakView: View {
    @EnvironmentObject var breakWindowController: BreakWindowController
    
    @State private var timeRemaining = 5 * 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.breakpoint
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Time to take a break!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Step away from the screen for a moment.")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("\(timeString(time: timeRemaining))")
                    .font(.system(size: 60, design: .monospaced))
                    .foregroundStyle(.white)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
                
                Button(action: {
                    closeBreakWindow()
                }) {
                    Text("I'm ready to go back!")
                        .font(.headline)
                        .padding()
                        .background(.white)
                        .foregroundColor(Color.breakpoint)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
    }
    
    func closeBreakWindow() {
        breakWindowController.closeBreakWindow()
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

#Preview {
    BreakView()
}
