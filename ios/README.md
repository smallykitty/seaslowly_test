# MVVMDemo iOS

iOS implementation of the MVVMDemo application using SwiftUI and mixed-language support (Swift + Objective-C).

## Project Structure

```
ios/
├── MVVMDemo.xcodeproj/       # Xcode project file
└── MVVMDemo/
    ├── App/                  # Application entry point
    │   └── MVVMDemoApp.swift
    ├── Views/                # SwiftUI views
    │   └── ContentView.swift
    ├── ViewModels/           # View models for MVVM architecture
    │   └── ContentViewModel.swift
    ├── Models/               # Data models (add your models here)
    ├── Services/             # Services and utilities
    │   ├── ObjCHelper.h
    │   └── ObjCHelper.m      # Sample Objective-C class
    ├── Resources/            # Assets and resources
    │   ├── Assets.xcassets/
    │   └── Info.plist
    └── Shared/               # Shared code and bridging headers
        └── MVVMDemo-Bridging-Header.h
```

## Requirements

- **Xcode**: 14.0 or later
- **iOS**: 15.0 or later
- **Swift**: 5.0 or later

## Getting Started

### Opening the Project

1. Navigate to the `ios/` directory
2. Open `MVVMDemo.xcodeproj` in Xcode:
   ```bash
   open ios/MVVMDemo.xcodeproj
   ```
   
   Or simply double-click `MVVMDemo.xcodeproj` in Finder.

### Building and Running

1. Select a simulator or device from the scheme selector in Xcode
2. Press `⌘ + R` (or click the Run button) to build and run the app
3. The app should build successfully and display the welcome screen

### Project Configuration

The project is pre-configured with:

- **SwiftUI App Lifecycle**: Modern SwiftUI-based app structure
- **Mixed Language Support**: Swift and Objective-C interoperability
- **Bridging Header**: Located at `MVVMDemo/Shared/MVVMDemo-Bridging-Header.h`
- **Deployment Target**: iOS 15.0+
- **Bundle Identifier**: `com.example.mvvmdemo`

## Mixed-Language Support

### Swift to Objective-C Integration

The project includes a bridging header that allows Swift code to use Objective-C classes:

1. **Bridging Header**: `MVVMDemo-Bridging-Header.h`
   - Configured in build settings: `SWIFT_OBJC_BRIDGING_HEADER`
   - Import Objective-C headers here to expose them to Swift

2. **Sample Objective-C Class**: `ObjCHelper`
   - Located in `Services/ObjCHelper.h` and `Services/ObjCHelper.m`
   - Demonstrates how to create and use Objective-C classes from Swift
   - Example methods:
     - `getWelcomeMessage()`: Returns a welcome message
     - `processData:`: Processes input strings

### Adding New Objective-C Files

To add new Objective-C files to the project:

1. Create your `.h` and `.m` files
2. Add them to the Xcode project
3. Import the header in `MVVMDemo-Bridging-Header.h`:
   ```objc
   #import "YourNewClass.h"
   ```
4. Use the Objective-C class in Swift:
   ```swift
   let helper = YourNewClass()
   helper.someMethod()
   ```

## Architecture

This iOS project follows the MVVM (Model-View-ViewModel) pattern:

- **Views**: SwiftUI views (in `Views/`)
- **ViewModels**: ObservableObject classes that manage view state (in `ViewModels/`)
- **Models**: Data structures (in `Models/`)
- **Services**: Business logic and API clients (in `Services/`)

## Development Tips

### Building from Command Line

You can also build the project from the command line:

```bash
# Build
xcodebuild -project ios/MVVMDemo.xcodeproj -scheme MVVMDemo -sdk iphonesimulator

# Run tests (when tests are added)
xcodebuild test -project ios/MVVMDemo.xcodeproj -scheme MVVMDemo -destination 'platform=iOS Simulator,name=iPhone 15'
```

### SwiftUI Previews

SwiftUI views include preview providers for live previews in Xcode:
- Use `⌥ + ⌘ + Return` to show the preview canvas
- Click the play button in the preview to run it

### Code Signing

For development, the project is configured with:
- **Code Sign Style**: Automatic
- **Development Team**: (set this in Xcode)

To run on a physical device:
1. Open the project in Xcode
2. Select your target device
3. Go to Signing & Capabilities
4. Select your development team

## Troubleshooting

### Bridging Header Not Found

If you encounter bridging header errors:
1. Verify the bridging header path in Build Settings
2. Ensure the path is: `MVVMDemo/Shared/MVVMDemo-Bridging-Header.h`
3. Clean the build folder: `⇧ + ⌘ + K`

### Module Not Found

If Objective-C classes are not visible in Swift:
1. Check that headers are imported in the bridging header
2. Verify the `.m` file is included in the Compile Sources build phase
3. Clean and rebuild the project

### Simulator Issues

If the simulator doesn't launch:
1. Reset the simulator: Device > Erase All Content and Settings
2. Restart Xcode
3. Select a different simulator device

## Next Steps

1. Add your data models to `Models/`
2. Create view models in `ViewModels/`
3. Build your UI views in `Views/`
4. Implement services and API clients in `Services/`
5. Add unit tests (create a test target in Xcode)

## License

This project is part of the MVVMDemo repository.
