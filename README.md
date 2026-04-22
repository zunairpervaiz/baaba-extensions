# baaba_extensions

A Flutter/Dart extension package that adds expressive, null-safe helpers to common types — strings, numbers, lists, widgets, dates, booleans, and `BuildContext`.

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

### Global Toast Config

Override these before showing any toasts:

```dart
defaultToastBackgroundColor = Colors.black87;
defaultToastTextColor       = Colors.white;
defaultToastGravityGlobal   = ToastGravity.BOTTOM;
```

---

## Requirements

- Dart SDK `^3.11.3`
- Flutter `>=1.17.0`
- [`fluttertoast`](https://pub.dev/packages/fluttertoast) `^9.0.0`
