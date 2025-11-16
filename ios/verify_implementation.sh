#!/bin/bash

# Verify MVVM Core implementation structure
echo "Verifying MVVM Core implementation..."
echo ""

# Check Models directory
echo "=== Models Directory ==="
echo "Swift files:"
find MVVMDemo/Models -name "*.swift" -exec echo "  ✓ {}" \;

echo ""
echo "Objective-C header files:"
find MVVMDemo/Models -name "*.h" -exec echo "  ✓ {}" \;

echo ""
echo "Objective-C implementation files:"
find MVVMDemo/Models -name "*.m" -exec echo "  ✓ {}" \;

# Check Services directory
echo ""
echo "=== Services Directory ==="
echo "Swift files:"
find MVVMDemo/Services -name "*.swift" -exec echo "  ✓ {}" \;

echo ""
echo "Objective-C header files:"
find MVVMDemo/Services -name "*.h" -exec echo "  ✓ {}" \;

echo ""
echo "Objective-C implementation files:"
find MVVMDemo/Services -name "*.m" -exec echo "  ✓ {}" \;

# Check ViewModels directory
echo ""
echo "=== ViewModels Directory ==="
echo "Swift files:"
find MVVMDemo/ViewModels -name "*.swift" -exec echo "  ✓ {}" \;

# Check Tests directory
echo ""
echo "=== Tests Directory ==="
echo "Test files:"
find MVVMDemoTests -name "*.swift" -exec echo "  ✓ {}" \;

echo ""
echo "Configuration files:"
find MVVMDemoTests -name "*.plist" -exec echo "  ✓ {}" \;

# Check file counts
echo ""
echo "=== File Count Summary ==="
swift_count=$(find MVVMDemo -name "*.swift" | wc -l)
objc_h_count=$(find MVVMDemo -name "*.h" | wc -l)
objc_m_count=$(find MVVMDemo -name "*.m" | wc -l)
test_count=$(find MVVMDemoTests -name "*.swift" | wc -l)

echo "Swift implementation files: $swift_count"
echo "Objective-C header files: $objc_h_count"
echo "Objective-C implementation files: $objc_m_count"
echo "Test files: $test_count"

total_files=$((swift_count + objc_h_count + objc_m_count + test_count))
echo "Total implementation files: $total_files"

# Check for syntax errors in Swift files (basic check)
echo ""
echo "=== Basic Syntax Verification ==="
echo "Checking Swift files for basic syntax..."
for file in $(find MVVMDemo -name "*.swift"); do
    if [ -f "$file" ]; then
        # Basic syntax check - look for unmatched braces
        open_braces=$(grep -o '{' "$file" | wc -l)
        close_braces=$(grep -o '}' "$file" | wc -l)
        if [ "$open_braces" -eq "$close_braces" ]; then
            echo "  ✓ $file (braces balanced)"
        else
            echo "  ✗ $file (braces unbalanced: $open_braces open, $close_braces close)"
        fi
    fi
done

echo ""
echo "=== Bridging Header ==="
if [ -f "MVVMDemo/Shared/MVVMDemo-Bridging-Header.h" ]; then
    echo "✓ Bridging header exists"
    echo "  Header imports:"
    grep "#import" "MVVMDemo/Shared/MVVMDemo-Bridging-Header.h" | sed 's/^/    /'
else
    echo "✗ Bridging header not found"
fi

echo ""
echo "Verification complete!"