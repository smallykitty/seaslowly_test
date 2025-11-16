# iOS Project Setup Documentation

This document describes the iOS project structure, configuration, and mixed-language support setup.

## Project Overview

**Project Name**: MVVMDemo  
**Bundle Identifier**: com.example.mvvmdemo  
**Deployment Target**: iOS 15.0+  
**App Lifecycle**: SwiftUI App  
**Languages**: Swift 5.0 + Objective-C  

## Directory Structure

```
ios/
├── MVVMDemo.xcodeproj/
│   ├── project.pbxproj                    # Xcode project file
│   ├── project.xcworkspace/
│   │   └── contents.xcworkspacedata       # Workspace metadata
│   └── xcshareddata/
│       └── xcschemes/
│           └── MVVMDemo.xcscheme          # Build scheme configuration
│
└── MVVMDemo/
    ├── App/
    │   └── MVVMDemoApp.swift              # Main app entry point (@main)
    │
    ├── Views/
    │   └── ContentView.swift              # Main SwiftUI view
    │
    ├── ViewModels/
    │   └── ContentViewModel.swift         # ViewModel for ContentView
    │
    ├── Models/
    │   └── .gitkeep                       # Placeholder for future models
    │
    ├── Services/
    │   ├── ObjCHelper.h                   # Objective-C header
    │   └── ObjCHelper.m                   # Objective-C implementation
    │
    ├── Resources/
    │   ├── Assets.xcassets/               # Image and color assets
    │   │   ├── Contents.json
    │   │   ├── AppIcon.appiconset/
    │   │   │   └── Contents.json
    │   │   └── AccentColor.colorset/
    │   │       └── Contents.json
    │   └── Info.plist                     # App configuration
    │
    └── Shared/
        └── MVVMDemo-Bridging-Header.h     # Swift-ObjC bridging header
```

## Build Configuration

### Key Build Settings

| Setting | Value | Description |
|---------|-------|-------------|
| `SWIFT_OBJC_BRIDGING_HEADER` | `MVVMDemo/Shared/MVVMDemo-Bridging-Header.h` | Path to bridging header |
| `SWIFT_VERSION` | 5.0 | Swift language version |
| `IPHONEOS_DEPLOYMENT_TARGET` | 15.0 | Minimum iOS version |
| `PRODUCT_BUNDLE_IDENTIFIER` | com.example.mvvmdemo | App bundle ID |
| `INFOPLIST_FILE` | MVVMDemo/Resources/Info.plist | Info.plist location |
| `ENABLE_PREVIEWS` | YES | Enable SwiftUI previews |
| `TARGETED_DEVICE_FAMILY` | 1,2 | iPhone and iPad support |
| `CLANG_ENABLE_OBJC_ARC` | YES | Enable Automatic Reference Counting |
| `CLANG_ENABLE_MODULES` | YES | Enable module support |

### Build Phases

1. **Sources**: Compiles Swift and Objective-C source files
   - `MVVMDemoApp.swift`
   - `ContentView.swift`
   - `ContentViewModel.swift`
   - `ObjCHelper.m`

2. **Resources**: Bundles assets and resources
   - `Assets.xcassets`
   - `Info.plist` (referenced, not bundled)

3. **Frameworks**: Links system frameworks (automatic)

## Mixed-Language Support

### Bridging Header Configuration

The project uses a bridging header to expose Objective-C APIs to Swift:

**Location**: `MVVMDemo/Shared/MVVMDemo-Bridging-Header.h`

**Content**:
```objc
//
//  MVVMDemo-Bridging-Header.h
//  MVVMDemo
//
//  Use this file to import Objective-C headers that you want to expose to Swift.
//

#import "../Services/ObjCHelper.h"
```

**Build Setting**: 
```
SWIFT_OBJC_BRIDGING_HEADER = "MVVMDemo/Shared/MVVMDemo-Bridging-Header.h"
```

### Sample Objective-C Class

**ObjCHelper.h**:
```objc
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCHelper : NSObject

- (instancetype)init;
- (NSString *)getWelcomeMessage;
- (NSString *)processData:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
```

**ObjCHelper.m**:
```objc
#import "ObjCHelper.h"

@implementation ObjCHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"ObjCHelper initialized");
    }
    return self;
}

- (NSString *)getWelcomeMessage {
    return @"Hello from Objective-C! 🎉";
}

- (NSString *)processData:(NSString *)input {
    return [NSString stringWithFormat:@"Processed: %@", input];
}

@end
```

### Using Objective-C from Swift

Once imported via the bridging header, Objective-C classes can be used directly in Swift:

```swift
import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var objcHelper: ObjCHelper?
    
    init() {
        objcHelper = ObjCHelper()
    }
}
```

```swift
if let helper = viewModel.objcHelper {
    Text(helper.getWelcomeMessage())
}
```

## SwiftUI App Structure

### App Entry Point

**MVVMDemoApp.swift**:
```swift
import SwiftUI

@main
struct MVVMDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

- Uses `@main` attribute (SwiftUI App lifecycle)
- No `AppDelegate` or `SceneDelegate` required
- Defines app scenes using `WindowGroup`

### Main View

**ContentView.swift**:
- SwiftUI view with navigation
- Uses `@StateObject` for view model
- Displays welcome message from Objective-C helper
- Includes preview provider for Xcode canvas

## Info.plist Configuration

Key configurations in `Info.plist`:

- **UIApplicationSceneManifest**: Enables multiple scene support
- **UILaunchScreen**: Empty dict for default launch screen
- **UISupportedInterfaceOrientations**: Portrait and landscape support
- **LSRequiresIPhoneOS**: Marks as iOS app

## Assets

### App Icon
Located at: `Resources/Assets.xcassets/AppIcon.appiconset/`
- Supports all required icon sizes for iOS
- Currently uses placeholder icons (no images included)

### Accent Color
Located at: `Resources/Assets.xcassets/AccentColor.colorset/`
- Default system accent color
- Can be customized by editing `Contents.json`

## Building the Project

### From Xcode
1. Open `MVVMDemo.xcodeproj`
2. Select a simulator or device
3. Build: `⌘ + B`
4. Run: `⌘ + R`

### From Command Line
```bash
# Build for simulator
xcodebuild -project MVVMDemo.xcodeproj \
  -scheme MVVMDemo \
  -sdk iphonesimulator \
  -configuration Debug

# Build for device
xcodebuild -project MVVMDemo.xcodeproj \
  -scheme MVVMDemo \
  -sdk iphoneos \
  -configuration Release
```

## Adding New Files

### Adding Swift Files
1. Create new `.swift` file in appropriate directory
2. Add to Xcode project (will be automatically added to compile sources)
3. No additional configuration needed

### Adding Objective-C Files
1. Create `.h` and `.m` files in appropriate directory
2. Add to Xcode project
3. Add header import to `MVVMDemo-Bridging-Header.h`:
   ```objc
   #import "../Path/To/YourClass.h"
   ```
4. Use in Swift code directly by class name

### Adding Resources
1. Add files to `Resources/` directory
2. Drag into Xcode project
3. Ensure "Copy items if needed" is checked
4. Select appropriate target membership

## Xcode Project File Format

The `project.pbxproj` file uses Apple's property list format with unique identifiers for:
- File references
- Groups (folders)
- Build phases
- Targets
- Build configurations

Each entry has a unique 24-character hexadecimal ID (e.g., `7050B52029C1F7D5006F0FAD`).

## Version Control

Files tracked in git:
- All source files (`.swift`, `.h`, `.m`)
- Project file (`project.pbxproj`)
- Schemes (`xcshareddata/xcschemes/`)
- Workspace data (`project.xcworkspace/contents.xcworkspacedata`)
- Assets (`Assets.xcassets/`)
- Configuration files (`Info.plist`)
- Documentation (`README.md`, `SETUP.md`)

Files ignored (see `.gitignore`):
- User-specific data (`xcuserdata/`)
- Build artifacts (`DerivedData/`, `build/`)
- System files (`.DS_Store`)

## Future Enhancements

Consider adding:
1. **Unit Tests**: Create a test target
2. **UI Tests**: Add UI testing target
3. **Core Data**: For local persistence
4. **Networking**: API client services
5. **Dependency Injection**: Container pattern
6. **SwiftUI Themes**: Custom styling
7. **Localization**: Multi-language support
8. **App Clips**: Lightweight app experiences
9. **Widgets**: Home screen widgets
10. **Watch App**: watchOS companion app

## Troubleshooting

### Common Issues

**Build Fails with "Bridging header not found"**
- Verify path in Build Settings
- Clean build folder: `⇧ + ⌘ + K`
- Check file exists at specified path

**Objective-C class not visible in Swift**
- Ensure header is imported in bridging header
- Verify `.m` file is in compile sources
- Clean and rebuild

**SwiftUI preview crashes**
- Ensure all dependencies are available
- Check for runtime errors in preview code
- Restart Xcode

**Code signing errors**
- Set development team in Signing & Capabilities
- Verify bundle ID is unique
- Check provisioning profiles

## References

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Mixing Swift and Objective-C](https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_objective-c_into_swift)
- [Xcode Project Format](https://developer.apple.com/library/archive/featuredarticles/XcodeConcepts/Concept-Projects.html)
