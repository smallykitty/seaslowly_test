import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .font(.system(size: 80))
                
                Text("Welcome to MVVMDemo")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("iOS Edition")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let helper = viewModel.objcHelper {
                    Text(helper.getWelcomeMessage())
                        .font(.body)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    
                    Text(helper.processData("SwiftUI + Objective-C"))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .navigationTitle("MVVMDemo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
