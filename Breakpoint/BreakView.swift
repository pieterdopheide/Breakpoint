import SwiftUI

struct BreakView: View {
    @EnvironmentObject var breakWindowController: BreakWindowController
    
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
}

#Preview {
    BreakView()
}
