# Screen Adaptation Best Practices Guide

## Overview

This guide provides best practices for implementing responsive UI in the MVVM Demo application and other Jetpack Compose applications.

## Responsive Design Principles

### 1. Mobile-First Approach
Start with the smallest screen size and progressively enhance for larger screens.

```kotlin
// ❌ Bad: Start with large screens
@Composable
fun Form() {
    if (isTablet()) {
        LargeForm() // Complex logic
    } else {
        SmallForm()
    }
}

// ✅ Good: Start with small screens
@Composable
fun Form() {
    val screenSize = getScreenSize()
    when (screenSize) {
        ScreenSize.SMALL -> SmallForm()
        ScreenSize.MEDIUM -> MediumForm()
        ScreenSize.LARGE -> LargeForm()
        ScreenSize.EXTRA_LARGE -> ExtraLargeForm()
    }
}
```

### 2. Use Responsive Utilities

Always use the provided responsive utilities instead of hardcoding values.

```kotlin
// ❌ Bad: Hardcoded values
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(16.dp)
) {
    Text("Title", style = MaterialTheme.typography.headlineMedium)
    Spacer(modifier = Modifier.height(32.dp))
}

// ✅ Good: Responsive utilities
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(getResponsivePadding())
) {
    Text("Title", style = MaterialTheme.typography.headlineMedium)
    Spacer(modifier = Modifier.height(getResponsiveSpacing() * 3))
}
```

### 3. Constrain Content Width

For better readability on large screens, constrain the maximum width of content.

```kotlin
// ❌ Bad: Content stretches across entire screen
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(16.dp)
) {
    TextField(modifier = Modifier.fillMaxWidth())
}

// ✅ Good: Constrain maximum width
Box(
    modifier = Modifier
        .fillMaxSize()
        .padding(getResponsivePadding()),
    contentAlignment = Alignment.Center
) {
    Column(
        modifier = Modifier.widthIn(max = getMaxFormWidth())
    ) {
        TextField(modifier = Modifier.fillMaxWidth())
    }
}
```

### 4. Use Scalable Spacing

Define spacing as fractions of base spacing unit.

```kotlin
// ❌ Bad: Inconsistent spacing
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(16.dp)
) {
    Text("Title", modifier = Modifier.padding(bottom = 32.dp))
    TextField(modifier = Modifier.padding(bottom = 16.dp))
    Button(modifier = Modifier.padding(bottom = 8.dp))
}

// ✅ Good: Consistent spacing scale
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(getResponsivePadding())
) {
    val spacing = getResponsiveSpacing()
    Text("Title", modifier = Modifier.padding(bottom = spacing * 3))
    TextField(modifier = Modifier.padding(bottom = spacing * 2))
    Button(modifier = Modifier.padding(bottom = spacing))
}
```

### 5. Responsive Touch Targets

Ensure minimum touch target sizes across all screen sizes.

```kotlin
// ❌ Bad: Variable button sizes
Button(
    modifier = Modifier
        .fillMaxWidth()
        .height(40.dp)
)

// ✅ Good: Responsive touch target
Button(
    modifier = Modifier
        .fillMaxWidth()
        .height(getResponsiveButtonHeight())
        .minimumInteractiveComponentSize()
)
```

## Dimension Management

### 1. Use dimens.xml for All Values

Never hardcode dimension values in composable functions.

```kotlin
// ❌ Bad: Hardcoded values in code
Text(
    modifier = Modifier.padding(
        horizontal = 16.dp,
        vertical = 8.dp
    )
)

// ✅ Good: Use dimens.xml
// In res/values/dimens.xml:
// <dimen name="content_padding_horizontal">16dp</dimen>
// <dimen name="content_padding_vertical">8dp</dimen>

Text(
    modifier = Modifier.padding(
        horizontal = dimensionResource(R.dimen.content_padding_horizontal),
        vertical = dimensionResource(R.dimen.content_padding_vertical)
    )
)
```

### 2. Define All Screen Size Variants

Create dimens.xml files for all screen size qualifiers:
- `values/dimens.xml` - Default (small phones)
- `values-sw600dp/dimens.xml` - Tablets
- `values-sw720dp/dimens.xml` - Large tablets
- `values-land/dimens.xml` - Landscape orientation
- `values-port/dimens.xml` - Portrait orientation

### 3. Hierarchy of Dimension Categories

Organize dimensions by purpose:

```xml
<!-- Padding and Margins -->
<dimen name="padding_extra_small">4dp</dimen>
<dimen name="padding_small">8dp</dimen>
<dimen name="padding_medium">16dp</dimen>
<dimen name="padding_large">24dp</dimen>
<dimen name="padding_extra_large">32dp</dimen>

<!-- Spacing -->
<dimen name="spacing_extra_small">4dp</dimen>
<dimen name="spacing_small">8dp</dimen>
<dimen name="spacing_medium">12dp</dimen>
<dimen name="spacing_large">16dp</dimen>
<dimen name="spacing_extra_large">24dp</dimen>

<!-- Font Sizes -->
<dimen name="text_size_small">12sp</dimen>
<dimen name="text_size_body">14sp</dimen>
<dimen name="text_size_headline">22sp</dimen>

<!-- Component Sizes -->
<dimen name="button_height">48dp</dimen>
<dimen name="textfield_height">56dp</dimen>
<dimen name="touch_target_minimum">48dp</dimen>

<!-- Form Layout -->
<dimen name="form_max_width">320dp</dimen>
<dimen name="form_field_spacing">12dp</dimen>
```

## Layout Patterns

### 1. Single Column Layout (Phones)

Use for small screens with vertical scrolling.

```kotlin
@Composable
fun PhoneLayout() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(getResponsivePadding())
    ) {
        Section1()
        Section2()
        Section3()
    }
}
```

### 2. Two-Column Layout (Tablets)

Use for medium to large screens.

```kotlin
@Composable
fun TabletLayout() {
    Row(
        modifier = Modifier
            .fillMaxSize()
            .padding(getResponsivePadding()),
        horizontalArrangement = Arrangement.spacedBy(getResponsiveSpacing())
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Section1()
            Section2()
        }
        Column(modifier = Modifier.weight(1f)) {
            Section3()
            Section4()
        }
    }
}
```

### 3. Master-Detail Layout (Tablets)

Use for navigation on large screens.

```kotlin
@Composable
fun MasterDetailLayout() {
    val isTablet = isTablet()
    
    if (isTablet) {
        Row(modifier = Modifier.fillMaxSize()) {
            MasterList(modifier = Modifier.weight(1f))
            DetailView(modifier = Modifier.weight(1f))
        }
    } else {
        MasterList(modifier = Modifier.fillMaxSize())
    }
}
```

## Text and Typography

### 1. Use sp for Font Sizes

Always use `sp` (scale-independent pixels) for text sizes.

```kotlin
// ❌ Bad: Using dp for text
Text("Hello", fontSize = 16.dp.toSp())

// ✅ Good: Using sp
Text("Hello", fontSize = 16.sp)

// ✅ Better: Using theme typography
Text(
    "Hello",
    style = MaterialTheme.typography.bodyMedium
)
```

### 2. Respect User Text Size Preferences

Use Material 3 typography styles which respect system text size settings.

```kotlin
// ✅ Good: Material 3 typography styles
Text("Headline", style = MaterialTheme.typography.headlineMedium)
Text("Body", style = MaterialTheme.typography.bodyMedium)
Text("Label", style = MaterialTheme.typography.labelMedium)
```

### 3. Responsive Typography

Adjust typography style based on screen size.

```kotlin
@Composable
fun ResponsiveHeadline(text: String) {
    val screenSize = getScreenSize()
    val style = when (screenSize) {
        ScreenSize.SMALL -> MaterialTheme.typography.headlineSmall
        ScreenSize.MEDIUM -> MaterialTheme.typography.headlineSmall
        ScreenSize.LARGE -> MaterialTheme.typography.headlineMedium
        ScreenSize.EXTRA_LARGE -> MaterialTheme.typography.headlineLarge
    }
    
    Text(text = text, style = style)
}
```

## Images and Resources

### 1. Use Vector Drawables

Prefer VectorDrawable over raster images for scalability.

```kotlin
// ✅ Good: Vector drawable
Icon(
    painter = painterResource(id = R.drawable.ic_login),
    contentDescription = "Login",
    modifier = Modifier.size(24.dp)
)
```

### 2. Provide Multi-Density Images

For raster images, provide versions for multiple densities:
- `drawable-ldpi/` - Low density
- `drawable-mdpi/` - Medium density (1x)
- `drawable-hdpi/` - High density (1.5x)
- `drawable-xhdpi/` - Extra high density (2x)
- `drawable-xxhdpi/` - Extra extra high density (3x)
- `drawable-xxxhdpi/` - Extra extra extra high density (4x)

### 3. Scale Images Based on Screen Size

```kotlin
@Composable
fun ResponsiveImage() {
    val screenSize = getScreenSize()
    val imageSize = when (screenSize) {
        ScreenSize.SMALL -> 100.dp
        ScreenSize.MEDIUM -> 120.dp
        ScreenSize.LARGE -> 150.dp
        ScreenSize.EXTRA_LARGE -> 180.dp
    }
    
    Image(
        painter = painterResource(R.drawable.logo),
        contentDescription = "Logo",
        modifier = Modifier.size(imageSize)
    )
}
```

## Safe Areas and Notches

### 1. Always Account for Safe Areas

```kotlin
@Composable
fun Screen() {
    val safeAreaPadding = rememberSafeAreaPadding()
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .safeAreaPadding(safeAreaPadding)
    ) {
        // Content
    }
}
```

### 2. Avoid Placing Content in Unsafe Areas

```kotlin
// ❌ Bad: Content might be hidden by notch
Box(
    modifier = Modifier
        .fillMaxSize()
        .padding(8.dp)
) {
    CriticalContent()
}

// ✅ Good: Content is inset from notch
Box(
    modifier = Modifier
        .fillMaxSize()
        .safeArea()
) {
    CriticalContent()
}
```

## Testing and Validation

### 1. Test on Multiple Configurations

```kotlin
@Preview(
    name = "Phone Small",
    device = "spec:width=360dp,height=640dp",
    showSystemUi = true
)
@Preview(
    name = "Phone Large",
    device = "spec:width=412dp,height=915dp",
    showSystemUi = true
)
@Preview(
    name = "Tablet",
    device = "spec:width=600dp,height=1024dp",
    showSystemUi = true
)
@Composable
fun PreviewAllConfigurations() {
    LoginScreen(rememberNavController())
}
```

### 2. Test Orientation Changes

```kotlin
@Preview(device = "id:Nexus 5", showSystemUi = true)
@Composable
fun PortraitPreview() {
    LoginScreen(rememberNavController())
}

@Preview(
    device = "id:Nexus 5",
    widthDp = 800,
    heightDp = 480,
    showSystemUi = true
)
@Composable
fun LandscapePreview() {
    LoginScreen(rememberNavController())
}
```

### 3. Runtime Testing

Test on physical devices:
- Small phone (4.5")
- Medium phone (5.5")
- Large phone (6.5"+)
- Tablet (7-10")
- Large tablet (10"+)
- Devices with notches
- Devices with bottom navigation bar

## Common Mistakes to Avoid

### 1. Ignoring Smallest Screen Dimension

```kotlin
// ❌ Bad: Only considers screen width
val formWidth = if (screenWidthDp >= 600) 400.dp else 320.dp

// ✅ Good: Considers smallest dimension
val formWidth = if (minOf(screenWidthDp, screenHeightDp) >= 600) 400.dp else 320.dp
```

### 2. Hardcoded Aspect Ratios

```kotlin
// ❌ Bad: Assumes standard aspect ratio
Image(
    modifier = Modifier
        .width(200.dp)
        .height(100.dp)
)

// ✅ Good: Flexible aspect ratio
Image(
    modifier = Modifier
        .fillMaxWidth()
        .aspectRatio(2f)
)
```

### 3. Ignoring Keyboard Height

```kotlin
// ❌ Bad: Might be hidden by keyboard
Box(
    modifier = Modifier.fillMaxSize(),
    contentAlignment = Alignment.BottomCenter
) {
    Button()
}

// ✅ Good: Wrap in scrollable container
Column(
    modifier = Modifier
        .fillMaxSize()
        .verticalScroll(rememberScrollState())
) {
    TextField()
    Button()
}
```

### 4. Not Testing on Real Devices

Always test on actual devices, not just emulators, as:
- Different device manufacturers have different screen implementations
- Notch positions vary
- System UI sizes differ
- Performance characteristics vary

## Configuration Change Handling

### 1. Preserve State During Rotation

```kotlin
@Composable
fun Screen(viewModel: ViewModel = viewModel()) {
    // ViewModel data survives configuration changes
    val data by viewModel.data.observeAsState()
    
    // Local state might be lost, use rememberSaveable
    var isExpanded by rememberSaveable { mutableStateOf(false) }
    
    Column {
        // UI
    }
}
```

### 2. AndroidManifest Configuration

```xml
<activity
    android:name=".MainActivity"
    android:configChanges="orientation|screenSize|screenLayout"
    android:resizeableActivity="true"
/>
```

## Accessibility Considerations

### 1. Minimum Touch Target Sizes

```kotlin
// ✅ Good: 48dp minimum (according to Material Design)
Button(
    modifier = Modifier
        .height(48.dp)
        .minimumInteractiveComponentSize()
)
```

### 2. Readable Text

```kotlin
// ✅ Good: Large enough text with proper contrast
Text(
    text = "Content",
    fontSize = 16.sp,
    color = MaterialTheme.colorScheme.onBackground
)
```

### 3. Support for Text Scaling

```kotlin
// ✅ Good: Use sp for font sizes (respects user preferences)
Text(
    text = "Content",
    fontSize = 16.sp  // Will scale with user text size preference
)
```

## Performance Optimization

### 1. Avoid Recomposition

```kotlin
// ❌ Bad: Recomposes every time
val screenSize = getScreenSize()
val responsive = getResponsiveValue(...)

// ✅ Good: Memoize expensive computations
val screenSize = rememberUpdatedState(getScreenSize())
val responsive = rememberUpdatedState(getResponsiveValue(...))
```

### 2. Use LazyColumn for Long Lists

```kotlin
// ✅ Good: Efficient list rendering
LazyColumn(
    contentPadding = PaddingValues(
        horizontal = getResponsivePadding(),
        vertical = getResponsiveSpacing()
    ),
    verticalArrangement = Arrangement.spacedBy(getResponsiveSpacing())
) {
    items(items.size) { index ->
        ListItem(items[index])
    }
}
```

## Summary

Key principles for screen adaptation:
1. Start mobile-first, scale up
2. Use responsive utilities consistently
3. Constrain content on large screens
4. Use dp for dimensions, sp for text
5. Test on multiple real devices
6. Account for safe areas and notches
7. Handle orientation changes gracefully
8. Maintain accessibility standards
9. Optimize performance
10. Follow Material Design guidelines
