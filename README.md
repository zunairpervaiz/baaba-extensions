# baaba_extensions

A Flutter/Dart extension package that adds expressive, null-safe helpers to common types — strings, numbers, lists, widgets, dates, booleans, `BuildContext`, and beautiful customizable dialogs.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  baaba_extensions:
    path: ../baaba_extensions  # or your pub.dev version
```

Then import a single line in any file:

```dart
import 'package:baaba_extensions/baaba_extensions.dart';
```

---

## Extensions

### `StringExtension` — on `String?`

Null-safe string helpers. Call `.validate()` to get an empty string instead of null.

```dart
// Null safety
String? name;
name.validate();              // → ''
name.validate(value: 'N/A'); // → 'N/A'
name.isEmptyOrNull;          // → true
name.isNullOrBlank;          // → true
name.isNotBlank;             // → false

// Validation
'user@example.com'.validateEmail();    // → true
'03001234567'.validatePhone();         // → true
'https://flutter.dev'.validateURL();   // → true

// Formatting
'hello world'.capitalizeFirstLetter(); // → 'Hello world'
'hello world'.capitalizeEachWord();    // → 'Hello World'
'helloWorld'.toSnakeCase();            // → 'hello_world'
'hello_world'.toCamelCase();           // → 'helloWorld'
'hello world'.toPascalCase();          // → 'HelloWorld'
'hello-world'.toKebabCase();           // → 'hello-world'
'John Doe'.initials();                 // → 'JD'

// Truncation
'This is a long string'.ellipsize(10); // → 'This is...'

// Masking (for sensitive data display)
'user@example.com'.mask();                       // → 'u***@example.com'
'03001234567'.mask(maskType: MaskType.phone);    // → '03*******67'
'user@example.com'.mask(isMaskingEnabled: false);// → 'user@example.com'

// Conversion
'42'.toIntX();              // → 42
'3.14'.toDoubleX();         // → 3.14
'true'.toBool();            // → true
'hello'.toListX();          // → ['h','e','l','l','o']
'hello'.reverse;            // → 'olleh'

// Checks
'hello'.isAlpha();          // → true
'123'.isDigit();            // → true
'{"a":1}'.isJson();         // → true
'image.png'.isImage;        // → true
'file.pdf'.isPdf;           // → true
'hello'.equalsIgnoreCase('HELLO'); // → true

// Clipboard
await 'copy me'.copyToClipboard();

// Misc
'1234567890'.formatNumberWithComma(); // → '1,234,567,890'
'  hello  world  '.removeAllWhiteSpace(); // → 'helloworld'
'hello'.repeat(3, separator: '-');    // → 'hello-hello-hello'
'flutter widgets'.countWords();       // → 2
'flutter widgets'.toSlug();           // → 'flutter_widgets'

// Firebase search
'flutter'.setSearchParam(); // → ['f','fl','flu','flut','flutt','flutte','flutter']

// Pakistan mobile formatting
'03001234567'.formatPkMobile;         // → '0300-1234567'
'03001234567'.toDisplayFormattedPhone;// → '0300-1234567'

// Toast
'Saved successfully!'.toastString(); // shows a toast
```

---

### `NumX` / `NumPaddingX` — on `num`

Quick spacing and layout helpers.

```dart
// SizedBox shortcuts
16.heightBox   // SizedBox(height: 16)
16.widthBox    // SizedBox(width: 16)

// EdgeInsets shortcuts
16.allPadding        // EdgeInsets.all(16)
16.verticalPadding   // EdgeInsets.symmetric(vertical: 16)
16.horizontalPadding // EdgeInsets.symmetric(horizontal: 16)
16.leftPadding       // EdgeInsets.only(left: 16)
16.topPadding        // EdgeInsets.only(top: 16)
16.rightPadding      // EdgeInsets.only(right: 16)
16.bottomPadding     // EdgeInsets.only(bottom: 16)

// Formatting
3.ordinal      // → '3rd'
0.5.percentage // → 0.005

// Async delay
500.delay(() => print('done')); // runs after 500ms
```

### `NumDurationX` / `NumTimeX` — on `int`

Readable duration and relative time construction.

```dart
500.milliseconds  // Duration(milliseconds: 500)
5.seconds         // Duration(seconds: 5)
2.minutes         // Duration(minutes: 2)
1.hours           // Duration(hours: 1)
3.days            // Duration(days: 3)

7.daysAgo         // DateTime 7 days before now
2.hoursAgo        // DateTime 2 hours before now
```

### `NumCoerceInExtension` — on `T extends num`

```dart
5.coerceIn(1, 10);   // → 5  (within range)
0.coerceIn(1, 10);   // → 1  (below min → clamps to min)
15.coerceIn(1, 10);  // → 10 (above max → clamps to max)
```

---

### `ListX` — on `Iterable<T>?`

Null-safe iterable utilities.

```dart
List<int>? nums;
nums.validate(); // → []

[1, 2, 3].forEachIndexed((i, e) => print('$i: $e'));

[1, 3, 7].sumBy((n) => n);                    // → 11
['hi', 'world'].sumByDouble((s) => s.length); // → 7.0
[1, 2, 3].averageBy((n) => n);                // → 2.0

// Group by key
users.groupBy((u) => u.role); // Map<Role, List<User>>

// Safe firstWhere
[1, 2, 3].firstWhereOrNull((n) => n > 5); // → null (no exception)
```

### `ListSplit` — on `List<T>`

```dart
[1, 2, 3, 4, 5].splitAt(2);
// → (before: [1, 2], after: [3, 4, 5])

[1, 2, 3, 4, 5].chunked(2);
// → [[1, 2], [3, 4], [5]]

[1, 2, 3, 4].partition((n) => n.isEven);
// → (matching: [2, 4], remaining: [1, 3])
```

### `ListSwapExtension` — on `List<E>`

```dart
final list = [1, 2, 3];
list.swap(0, 2); // → [3, 2, 1]
```

---

### `ContextX` — on `BuildContext`

Access theme, media query, and screen info from any widget.

```dart
context.theme            // ThemeData
context.textTheme        // TextTheme
context.colorScheme      // ColorScheme
context.screenSize       // Size
context.screenWidth      // double
context.screenHeight     // double
context.isMobile         // true if width < 600
context.isTablet         // true if 600 ≤ width < 1024
context.isDesktop        // true if width ≥ 1024
context.hideKeyboard()   // unfocus / dismiss keyboard
context.isKeyboardVisible// true if keyboard is open
```

---

### `DialogX` — on `BuildContext`

Beautiful, fully customizable confirmation and information dialogs.

#### Confirmation dialog

Returns `true` if confirmed, `false` if cancelled, `null` if dismissed by tapping outside.

```dart
final confirmed = await context.showConfirmDialog(
  title: 'Delete Account',
  message: 'All your data will be permanently removed.',
  confirmText: 'Delete',
  cancelText: 'Keep it',
  confirmColor: Colors.red,
  icon: Icons.delete_outline_rounded,
);

if (confirmed == true) deleteAccount();
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | Dialog title |
| `message` | `String` | required | Body text |
| `confirmText` | `String` | `'Confirm'` | Confirm button label |
| `cancelText` | `String` | `'Cancel'` | Cancel button label |
| `onConfirm` | `VoidCallback?` | — | Called after confirm tap |
| `onCancel` | `VoidCallback?` | — | Called after cancel tap |
| `confirmColor` | `Color?` | global | Confirm button + icon color |
| `cancelColor` | `Color?` | global | Cancel button color |
| `icon` | `IconData` | `Icons.help_outline_rounded` | Icon shown at the top |
| `backgroundColor` | `Color?` | theme surface | Dialog background |
| `titleStyle` | `TextStyle?` | theme | Title text style |
| `messageStyle` | `TextStyle?` | theme | Message text style |
| `borderRadius` | `BorderRadius?` | global `circular(24)` | Dialog corner radius |
| `barrierDismissible` | `bool` | `true` | Tap-outside to dismiss |

#### Information dialog

```dart
await context.showInfoDialog(
  title: 'Profile Updated',
  message: 'Your changes have been saved successfully.',
  closeText: 'Great!',
  icon: Icons.check_circle_outline_rounded,
  accentColor: Colors.green,
);
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | Dialog title |
| `message` | `String` | required | Body text |
| `closeText` | `String` | `'Got it'` | Close button label |
| `onClose` | `VoidCallback?` | — | Called after close tap |
| `accentColor` | `Color?` | global | Close button + icon color |
| `icon` | `IconData` | `Icons.info_outline_rounded` | Icon shown at the top |
| `backgroundColor` | `Color?` | theme surface | Dialog background |
| `titleStyle` | `TextStyle?` | theme | Title text style |
| `messageStyle` | `TextStyle?` | theme | Message text style |
| `borderRadius` | `BorderRadius?` | global `circular(24)` | Dialog corner radius |
| `barrierDismissible` | `bool` | `true` | Tap-outside to dismiss |

---

### `DateTimeExt` — on `DateTime`

```dart
DateTime.now().timeAgo    // → 'Just now' / '5 minutes ago' / etc.
DateTime.now().isToday    // → true
DateTime.now().isYesterday
DateTime.now().isTomorrow
DateTime.now().isFuture
DateTime.now().isPast
DateTime.now().startOfDay // → DateTime(year, month, day, 0, 0, 0)
DateTime.now().endOfDay   // → DateTime(year, month, day, 23, 59, 59, 999)
date1.isSameDay(date2)    // → true / false
```

**Top-level helpers:**

```dart
currentMillisecondsTimeStamp() // → current epoch ms
currentTimeStamp()             // → current epoch seconds
leapYear(2024)                 // → true
daysInMonth(2, 2024)           // → 29
```

---

### `WidgetX` — on `Widget`

Wrap widgets with common layout wrappers using method chaining.

```dart
Text('Hello').center()
Text('Hello').expanded()
Text('Hello').expanded(flex: 2)
Text('Hello').withWidth(100)
Text('Hello').withHeight(50)
Text('Hello').withSize(width: 100, height: 50)
Text('Hello').visible(isLoggedIn)
Text('Hello').cornerRadiusWithClipRRect(12.0)
Text('Hello').cornerRadiusWithClipRRectOnly(topLeft: 12, topRight: 12)
Text('Hello').onTap(() => doSomething())
```

---

### `BoolxExtensions` — on `bool`

```dart
true.isTrue   // → true
true.isFalse  // → false
true.toggle   // → false
```

---

## Widgets

Ready-made Flutter widgets exported from the package.

### `SwiperWidgetx`

A fully-featured carousel/page-swiper widget.

```dart
// From a list
SwiperWidgetx(
  items: [
    Image.asset('a.png'),
    Image.asset('b.png'),
  ],
  autoPlay: true,
  autoPlayInterval: const Duration(seconds: 4),
  enlargeCenterPage: true,
  onPageChanged: (i) => print('page $i'),
);

// From a builder (efficient for large/dynamic lists)
SwiperWidgetx.builder(
  itemCount: 20,
  itemBuilder: (context, i) => Card(child: Text('$i')),
  viewportFraction: 0.9,
  scrollDirection: Axis.vertical,
);
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` / `itemBuilder` | `List<Widget>` / `IndexedWidgetBuilder` | required | Content source |
| `itemCount` | `int` | — | Required for `.builder` constructor |
| `height` | `double?` | — | Fixed height; if null uses `aspectRatio` |
| `aspectRatio` | `double` | `16/9` | Aspect ratio when height is null |
| `viewportFraction` | `num` | `0.8` | Fraction of viewport each page occupies |
| `enableInfiniteScroll` | `bool` | `true` | Loop pages infinitely |
| `autoPlay` | `bool` | `false` | Auto-advance pages |
| `autoPlayInterval` | `Duration` | `5s` | Interval between auto advances |
| `autoPlayAnimationDuration` | `Duration` | `800ms` | Animation duration for auto-play |
| `autoPlayCurve` | `Curve` | `fastOutSlowIn` | Animation curve for auto-play |
| `enlargeCenterPage` | `bool?` | `false` | Scale the center page up |
| `scrollDirection` | `Axis` | `horizontal` | Scroll axis |
| `isFastScrollingEnabled` | `bool` | `false` | Allow flinging multiple pages |
| `onPageChanged` | `Function(int)?` | — | Called on page change |
| `reverse` | `bool` | `false` | Reverse scroll direction |

**Programmatic control** — get a reference via a `GlobalKey<SwiperWidgetxState>`:

```dart
final key = GlobalKey<SwiperWidgetxState>();
SwiperWidgetx(key: key, items: [...]);

key.currentState?.nextPage(duration: 300.milliseconds, curve: Curves.ease);
key.currentState?.previousPage(duration: 300.milliseconds, curve: Curves.ease);
key.currentState?.jumpToPage(2);
key.currentState?.animateToPage(2, duration: 300.milliseconds, curve: Curves.ease);
```

---

### `HorizontalListWithoutHeight`

A horizontally-scrolling `Wrap`-based list that sizes itself to its content — no fixed height required.

```dart
HorizontalListWithoutHeight(
  itemCount: tags.length,
  itemBuilder: (context, i) => Chip(label: Text(tags[i])),
  spacing: 8,
  runSpacing: 4,
  paddings: const EdgeInsets.symmetric(horizontal: 16),
);
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `itemCount` | `int` | required | Number of items |
| `itemBuilder` | `IndexedWidgetBuilder` | required | Item builder |
| `spacing` | `double?` | — | Horizontal gap between items |
| `runSpacing` | `double?` | — | Vertical gap between runs |
| `paddings` | `EdgeInsets?` | — | Outer padding |
| `physics` | `ScrollPhysics?` | — | Scroll physics override |
| `controller` | `ScrollController?` | — | External scroll controller |
| `reverse` | `bool` | `false` | Reverse scroll direction |
| `wrapAlignment` | `WrapAlignment?` | — | Main-axis alignment |
| `crossAxisAlignment` | `WrapCrossAlignment?` | — | Cross-axis alignment |

---

### `ReadMoreWidgetx`

A text widget that collapses long content with a "Show more" / "Show less" toggle.

```dart
ReadMoreWidgetx(
  data: longText,
  trimLines: 3,
  trimMode: TrimMode.Line,
  trimCollapsedText: 'Read more',
  trimExpandedText: 'Read less',
  colorClickableText: Colors.blue,
  style: const TextStyle(fontSize: 14),
);
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `data` | `String` | required | Text content |
| `trimMode` | `TrimMode` | `TrimMode.Length` | Trim by character count or line count |
| `trimLength` | `int` | `200` | Max characters (for `TrimMode.Length`) |
| `trimLines` | `int` | `2` | Max lines (for `TrimMode.Line`) |
| `trimCollapsedText` | `String` | `'Show more'` | Label when collapsed |
| `trimExpandedText` | `String` | `'Show less'` | Label when expanded |
| `colorClickableText` | `Color?` | — | Color of the toggle link |
| `style` | `TextStyle?` | — | Text style |

**`TrimMode` enum:**

```dart
TrimMode.Length  // trim by character count
TrimMode.Line    // trim by line count
```

---

### `RestartAppWidgetx`

Wraps your app root to allow programmatic hot-restart from anywhere in the tree.

```dart
// In main.dart
runApp(RestartAppWidgetx(child: MyApp()));

// Anywhere in the tree
RestartAppWidgetx.init(context); // restarts the app
```

---

## Utils

### `Patterns`

Static regex strings for common validation:

```dart
Patterns.email
Patterns.emailEnhanced
Patterns.pkMobileLocal   // 03xxxxxxxxx
Patterns.pkMobileGlobal  // +92 / 0092 / 0 prefix
Patterns.url
Patterns.image  // jpeg, jpg, gif, png, bmp
Patterns.audio  // mp3, wav, ogg, etc.
Patterns.video  // mp4, avi, mkv, etc.
Patterns.pdf
Patterns.doc
Patterns.excel
Patterns.ppt
Patterns.apk
Patterns.txt
Patterns.html
```

### `MaskType` enum

```dart
MaskType.auto   // auto-detect email or phone
MaskType.email
MaskType.phone
```

### `TrimMode` enum

Used by `ReadMoreWidgetx` to choose how text is trimmed.

```dart
TrimMode.Length  // trim after N characters (default)
TrimMode.Line    // trim after N lines
```

### Global Toast Config

Override these before showing any toasts:

```dart
defaultToastBackgroundColor = Colors.black87;
defaultToastTextColor       = Colors.white;
defaultToastGravityGlobal   = ToastGravity.BOTTOM;
```

### Global Dialog Config

Override these once (e.g. in `main()`) to restyle all dialogs app-wide:

```dart
defaultDialogConfirmColorGlobal  = Colors.deepPurple;
defaultDialogCancelColorGlobal   = Colors.grey.shade700;
defaultDialogInfoColorGlobal     = Colors.green;
defaultDialogBorderRadiusGlobal  = BorderRadius.circular(16);
```

---

## Requirements

- Dart SDK `^3.11.3`
- Flutter `>=1.17.0`
- [`fluttertoast`](https://pub.dev/packages/fluttertoast) `^9.0.0` — used by `StringExtension.toastString()`
