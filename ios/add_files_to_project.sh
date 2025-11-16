#!/bin/bash

# Add MVVM Core files to Xcode project
# This script helps add the new files to the Xcode project

echo "Adding MVVM Core files to Xcode project..."

# Navigate to iOS directory
cd "$(dirname "$0")"

# Create a list of all new files to add
FILES_TO_ADD=(
    "MVVMDemo/Models/UserCredentials.swift"
    "MVVMDemo/Models/UserCredentials.h"
    "MVVMDemo/Models/UserCredentials.m"
    "MVVMDemo/Models/AuthenticationResponse.swift"
    "MVVMDemo/Models/AuthenticationResponse.h"
    "MVVMDemo/Models/AuthenticationResponse.m"
    "MVVMDemo/Models/ValidationError.swift"
    "MVVMDemo/Models/ValidationError.h"
    "MVVMDemo/Models/ValidationError.m"
    "MVVMDemo/Models/ValidationHelpers.swift"
    "MVVMDemo/Models/ValidationHelpers.h"
    "MVVMDemo/Models/ValidationHelpers.m"
    "MVVMDemo/Services/ServiceProtocols.swift"
    "MVVMDemo/Services/ValidationService.swift"
    "MVVMDemo/Services/ValidationService.h"
    "MVVMDemo/Services/ValidationService.m"
    "MVVMDemo/ViewModels/ViewModelProtocols.swift"
)

echo "Files to add to project:"
for file in "${FILES_TO_ADD[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (not found)"
    fi
done

echo ""
echo "To add these files to your Xcode project:"
echo "1. Open MVVMDemo.xcodeproj in Xcode"
echo "2. Right-click on the appropriate group (Models, Services, ViewModels)"
echo "3. Select 'Add Files to MVVMDemo...'"
echo "4. Navigate to the file and add it"
echo "5. Make sure 'Copy items if needed' is checked"
echo "6. Select the appropriate target"
echo ""
echo "For test files:"
echo "1. Create a new test target if needed"
echo "2. Add test files to the test target"
echo ""
echo "Alternatively, you can drag and drop the files into the correct groups in Xcode."
echo ""
echo "After adding files, update the bridging header settings in Build Settings:"
echo "- SWIFT_OBJC_BRIDGING_HEADER: MVVMDemo/Shared/MVVMDemo-Bridging-Header.h"
echo ""
echo "Done!"