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

// Word capitalisation
'hello world'.capitalizeAllWords(); // → 'Hello World'

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

// New in 0.5.0
'<b>Hello</b> world'.stripHtml();                     // → 'Hello world'
'hello world'.containsAny(['hi', 'hello']);           // → true
'hello world'.containsAll(['hello', 'world']);        // → true
'hello world foo bar'.wrapAt(10);                     // wraps at word boundary
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

// Range & rounding
5.isBetween(1, 10)   // → true
3.14159.roundTo(2)   // → 3.14
```

### `NumDurationX` / `NumTimeX` — on `int`

Readable duration and relative time construction.

```dart
500.milliseconds  // Duration(milliseconds: 500)
5.seconds         // Duration(seconds: 5)
2.minutes         // Duration(minutes: 2)
1.hours           // Duration(hours: 1)
3.days            // Duration(days: 3)

7.daysAgo          // DateTime 7 days before now
2.hoursAgo         // DateTime 2 hours before now
30.minutesAgo
10.secondsAgo

3.daysFromNow
6.hoursFromNow
15.minutesFromNow
30.secondsFromNow
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

// Dedup & sort
[1, 2, 2, 3].distinct();                         // → [1, 2, 3]
users.sortedBy((u) => u.name);                   // sorted copy

// Indexed map
items.mapIndexed((i, e) => '$i: $e');

// Aggregates
items.countWhere((e) => e.isActive);
users.maxBy((u) => u.age);
users.minBy((u) => u.age);
items.none((e) => e.isDeleted);                  // true if all are not deleted

// Flatten nested iterables
[[1, 2], [3, 4]].flatten(); // → [1, 2, 3, 4]
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

### `ListxWidgetExtensions` — on `List<Widget>`

Convert a plain list of widgets directly into a layout widget using method chaining.

```dart
[Text('A'), Text('B'), Text('C')].toRow();
[Text('A'), Text('B'), Text('C')].toColumn(mainAxisAlignment: MainAxisAlignment.center);
[Text('A'), Text('B'), Text('C')].toStack(alignment: Alignment.center);

// ListView (children mode)
[Text('A'), Text('B'), Text('C')].toList(shrinkWrap: true);

// ListView.builder
[Text('A'), Text('B'), Text('C')].toListView(
  itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
  physics: const NeverScrollableScrollPhysics(),
);
```

All methods accept the same named parameters as their Flutter counterparts (`mainAxisAlignment`, `crossAxisAlignment`, `scrollDirection`, `physics`, `padding`, etc.).

---

### `ScrollxExtensions` — on `ScrollController`

Fluent helpers for common scroll operations.

```dart
final controller = ScrollController();

// Animate to any offset
await controller.animateToPosition(300);

// Jump to edges
await controller.animateToBottom();
await controller.animateToTop();

// Custom duration / curve
await controller.animateToBottom(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOut,
);

// Guards
if (controller.isNearBottom(threshold: 80)) loadMoreItems();
if (controller.canScroll) showScrollIndicator();
```

| Member | Returns | Description |
|---|---|---|
| `animateToPosition(offset)` | `Future<void>` | Animated scroll to a specific offset |
| `animateToBottom()` | `Future<void>` | Animated scroll to `maxScrollExtent` |
| `animateToTop()` | `Future<void>` | Animated scroll to `minScrollExtent` |
| `isNearBottom({threshold})` | `bool` | `true` when within `threshold` (default 50) px of bottom |
| `canScroll` | `bool` | `true` if controller has clients and content overflows |
| `jumpToBottom()` | `void` | Instant (non-animated) scroll to bottom |
| `jumpToTop()` | `void` | Instant (non-animated) scroll to top |
| `isAtTop` | `bool` | `true` when exactly at the top |
| `isAtBottom` | `bool` | `true` when exactly at the bottom |
| `isNearTop({threshold})` | `bool` | `true` within `threshold` px of top |
| `scrollPercentage` | `double` | 0.0–1.0 scroll progress |

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

// Theme brightness
context.isDark           // true if dark theme is active
context.isLight

// Orientation
context.orientation      // Orientation.portrait / .landscape
context.isPortrait
context.isLandscape

// Safe-area & device
context.topPadding       // status bar height
context.bottomPadding    // home indicator height
context.viewPadding      // MediaQueryData.viewPadding
context.viewInsets       // keyboard insets
context.pixelRatio
context.locale

// Navigation
context.push(const HomePage())
context.pop()
context.pushNamed('/home', arguments: {'id': 1})
context.pushReplacement(const LoginPage())
context.pushAndRemoveAll(const DashboardPage())

// Scaffold
context.showSnackBar(const SnackBar(content: Text('Saved')))
context.showModalSheet(builder: (ctx) => const MySheet())
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

// Day-of-week
date.isWeekend            // Sat or Sun
date.isWeekday

// Period boundaries
date.startOfWeek          // Monday 00:00:00
date.endOfWeek            // Sunday 23:59:59.999
date.startOfMonth
date.endOfMonth
date.startOfYear
date.endOfYear

// Comparisons
date.isSameMonth(other)
date.isSameYear(other)
date.quarterOf            // → 1, 2, 3, or 4

// Age & arithmetic
birthDate.age             // full years from birth date to today
date.addDays(7)
date.subtractDays(3)
date.addHours(2)
date.subtractMinutes(30)
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

// Padding
Text('Hello').paddingAll(16)
Text('Hello').paddingSymmetric(horizontal: 16, vertical: 8)
Text('Hello').paddingOnly(left: 8, top: 4)
Text('Hello').padding(const EdgeInsets.all(12))

// Transforms & opacity
Text('Hello').opacity(0.5)
Text('Hello').rotate(0.3)          // radians
Text('Hello').scale(1.2)
Text('Hello').translate(dx: 10, dy: 0)

// Layout helpers
Text('Hello').flexible(flex: 2)
Text('Hello').card(elevation: 4, borderRadius: 12)
Text('Hello').tooltip('Tap to edit')
Text('Hello').hero('profile-avatar')
Text('Hello').safeArea()
Text('Hello').sliverBox             // SliverToBoxAdapter
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

### `VxTextBuilder`

A fluent, chainable text-styling builder backed by `AutoSizeText`. Chain as many modifiers as needed, then call `.make()` to produce a `Widget`.

```dart
// Basic usage
VxTextBuilder('Hello World')
  .bold
  .center
  .blue500
  .xl2
  .make();

// Via extension on an existing Text widget
Text('Hello').text
  .semiBold
  .ellipsis
  .red600
  .make();
```

**Font weights**

```dart
'text'.text.hairLine.make()  // w100
'text'.text.thin.make()      // w200
'text'.text.light.make()     // w300
'text'.text.normal.make()    // w400
'text'.text.medium.make()    // w500
'text'.text.semiBold.make()  // w600
'text'.text.bold.make()      // w700
'text'.text.extraBold.make() // w800
'text'.text.extraBlack.make()// w900
```

**Scale / size**

```dart
'text'.text.xs.make()    // 0.75×
'text'.text.sm.make()    // 0.875×
'text'.text.base.make()  // 1× (default)
'text'.text.lg.make()    // 1.125×
'text'.text.xl.make()    // 1.25×
'text'.text.xl2.make()   // 1.5×
'text'.text.xl3.make()   // 1.875×
'text'.text.xl4.make()   // 2.25×
'text'.text.xl5.make()   // 3×
'text'.text.xl6.make()   // 4×
VxTextBuilder('text').size(20).make() // exact px
```

**Alignment**

```dart
.center  .start  .end  .justify
// or custom:
.align(TextAlign.left)
```

**Text transforms**

```dart
.uppercase   // → 'HELLO WORLD'
.lowercase   // → 'hello world'
.capitalize  // → 'Hello World'
```

**Overflow**

```dart
.ellipsis  .fade  .visible
// or: .overflow(TextOverflow.clip)
```

**Decoration**

```dart
.underline  .lineThrough  .overline
```

**Letter spacing**

```dart
.tightest  .tighter  .tight   // -3, -2, -1
.wide      .wider     .widest  // 1, 2, 3
// or custom: .letterSpacing(0.5)
```

**Line height**

```dart
.heightTight    // 0.75
.heightSnug     // 0.875
.heightRelaxed  // 1.25
.heightLoose    // 1.5
// or custom: .lineHeight(1.4)
```

**Shadow**

```dart
VxTextBuilder('text')
  .shadow(2, 2, 4, Colors.black38)
  .make();
// individual:
.shadowBlur(4).shadowColor(Colors.black38).shadowOffset(2, 2)
```

**Colors** — full Tailwind-scale palette:

```dart
.white  .black  .transparent
.gray50 … .gray900
.red50  … .red900
.blue50 … .blue900
// and: slate, zinc, neutral, stone, orange, amber, yellow, lime,
//      green, emerald, teal, cyan, sky, indigo, violet, purple,
//      fuchsia, pink, rose — each with 50–900 shades
// or explicit: .color(Colors.deepOrange)
```

**TextTheme integration**

```dart
VxTextBuilder('Heading').displayLarge(context).make()
VxTextBuilder('Body').bodyMedium(context).make()
// all M3 roles: displayLarge/Medium/Small, headlineLarge/Medium/Small,
//   titleLarge/Medium/Small, bodyLarge/Medium/Small, labelLarge/Medium/Small
```

**Auto-size controls**

```dart
VxTextBuilder('text')
  .minFontSize(10)
  .maxFontSize(30)
  .stepGranularity(0.5)
  .maxLines(2)
  .overflowReplacement(Text('…'))
  .make();
```

**Conditional rendering**

```dart
VxTextBuilder('Admin only').when(user.isAdmin).make();
// renders SizedBox.shrink() when false
```

**Intrinsic mode** — disables `AutoSizeText` for widgets that don't work with `LayoutBuilder`:

```dart
VxTextBuilder('text').isIntrinsic.make();
```

**`VxTextExtensions` — on `Text`**

Convert any `Text` widget into a `VxTextBuilder` for further styling:

```dart
Text('Hello').text.bold.blue600.xl.make()
```

---

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

### `SkeletonLoaderWidgetx`

A shimmer loading placeholder that adapts its colors to light/dark theme.

```dart
SkeletonLoaderWidgetx(width: 200, height: 16)  // text line
SkeletonLoaderWidgetx(
  width: 48, height: 48,
  borderRadius: BorderRadius.circular(24),      // circle
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `width` | `double` | required | Width of the placeholder |
| `height` | `double` | required | Height of the placeholder |
| `borderRadius` | `BorderRadius` | `circular(8)` | Corner radius |
| `baseColor` | `Color?` | grey.300 / grey.700 | Base shimmer color |
| `highlightColor` | `Color?` | grey.100 / grey.600 | Highlight shimmer color |

---

### `EmptyStateWidgetx`

Centered empty state with icon, title, optional subtitle, and action button.

```dart
EmptyStateWidgetx(
  icon: Icons.search_off_rounded,
  title: 'No Results',
  subtitle: 'Try a different search term.',
  actionText: 'Clear Search',
  onAction: () => searchController.clear(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | Main title |
| `icon` | `IconData` | `Icons.inbox_outlined` | Icon shown above title |
| `subtitle` | `String?` | — | Optional description |
| `actionText` | `String?` | — | Label for the action button |
| `onAction` | `VoidCallback?` | — | Action button callback |
| `iconSize` | `double` | `64` | Icon size |
| `padding` | `EdgeInsets` | `all(32)` | Outer padding |

---

### `AvatarWidgetx`

Circular avatar with network image, initials fallback, online indicator, and badge.

```dart
AvatarWidgetx(
  name: 'John Doe',
  imageUrl: user.photoUrl,
  radius: 28,
  showOnlineIndicator: true,
  badgeCount: 3,
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `imageUrl` | `String?` | — | Network image URL |
| `name` | `String?` | — | Used to generate initials when no image |
| `radius` | `double` | `24` | Avatar radius |
| `showOnlineIndicator` | `bool` | `false` | Green dot at bottom-right |
| `onlineColor` | `Color` | green | Colour of the online dot |
| `badgeCount` | `int?` | — | Number shown in top-right badge |
| `badgeColor` | `Color?` | error | Badge background color |

---

### `PinInputWidgetx`

A PIN / OTP input as a row of individual boxes with automatic focus movement.

```dart
PinInputWidgetx(
  length: 6,
  obscureText: true,
  onCompleted: (pin) => verifyOtp(pin),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `length` | `int` | `4` | Number of PIN boxes |
| `onCompleted` | `Function(String)?` | — | Fires when all boxes are filled |
| `onChanged` | `Function(String)?` | — | Fires on every keystroke |
| `obscureText` | `bool` | `false` | Hides characters with `obscuringCharacter` |
| `boxSize` | `double` | `48` | Width and height of each box |
| `boxSpacing` | `double` | `8` | Gap between boxes |
| `borderRadius` | `double` | `8` | Box corner radius |

---

### `ExpandableWidgetx`

Animated expand / collapse container with a chevron indicator.

```dart
ExpandableWidgetx(
  header: const Text('Section title', style: TextStyle(fontWeight: FontWeight.bold)),
  body: const Text('Hidden content revealed on tap.'),
  initiallyExpanded: true,
  headerPadding: const EdgeInsets.all(12),
  bodyPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `header` | `Widget` | required | Always-visible header row |
| `body` | `Widget` | required | Content shown when expanded |
| `initiallyExpanded` | `bool` | `false` | Start expanded |
| `animationDuration` | `Duration` | `300ms` | Expand / collapse speed |
| `onToggle` | `Function(bool)?` | — | Called with new expanded state |

---

### `GradientButtonWidgetx`

An ink-ripple button with a `LinearGradient` fill.

```dart
GradientButtonWidgetx(
  text: 'Get Started',
  gradientColors: [Colors.purple, Colors.indigo],
  onPressed: () => navigateToHome(),
  leading: const Icon(Icons.arrow_forward, color: Colors.white),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | required | Button label |
| `onPressed` | `VoidCallback?` | — | Tap handler; `null` disables the button |
| `gradientColors` | `List<Color>` | purple → blue | Gradient stops |
| `height` | `double` | `52` | Button height |
| `width` | `double?` | — | Fixed width; null = shrink-wrap |
| `borderRadius` | `double` | `12` | Corner radius |
| `leading` / `trailing` | `Widget?` | — | Optional icon slots |

---

### `SearchBarWidgetx`

Styled search field with a clear button and built-in debounce.

```dart
SearchBarWidgetx(
  hintText: 'Search users…',
  debounceDuration: const Duration(milliseconds: 400),
  onSearch: (q) => bloc.search(q),
  onClear: () => bloc.reset(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onSearch` | `Function(String)?` | — | Fires after debounce period |
| `onChanged` | `Function(String)?` | — | Fires on every keystroke |
| `onClear` | `VoidCallback?` | — | Fires when the × button is tapped |
| `hintText` | `String` | `'Search...'` | Placeholder text |
| `debounceDuration` | `Duration` | `500ms` | Debounce delay |
| `borderRadius` | `double` | `12` | Input corner radius |

---

### `StepperIndicatorWidgetx`

Horizontal step progress indicator with optional step labels.

```dart
StepperIndicatorWidgetx(
  totalSteps: 4,
  currentStep: 2,
  labels: const ['Info', 'Address', 'Payment', 'Done'],
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `totalSteps` | `int` | required | Total number of steps |
| `currentStep` | `int` | required | 1-based active step index |
| `activeColor` | `Color?` | primary | Active and completed step color |
| `inactiveColor` | `Color?` | outlineVariant | Inactive step color |
| `stepSize` | `double` | `32` | Diameter of each circle |
| `connectorHeight` | `double` | `3` | Height of connecting line |
| `labels` | `List<String>?` | — | Optional labels below each step |

---

### `RatingWidgetx`

Star rating widget for input and read-only display with optional half-star support.

```dart
RatingWidgetx(
  initialRating: 3.5,
  allowHalfRating: true,
  starCount: 5,
  onRatingChanged: (r) => setState(() => rating = r),
)

// Read-only display
RatingWidgetx(initialRating: product.rating, readOnly: true)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `initialRating` | `double` | `0` | Starting rating value |
| `starCount` | `int` | `5` | Number of stars |
| `size` | `double` | `28` | Star icon size |
| `allowHalfRating` | `bool` | `false` | Enable half-star taps |
| `readOnly` | `bool` | `false` | Disables tap interaction |
| `filledColor` | `Color` | amber | Filled star color |
| `onRatingChanged` | `Function(double)?` | — | Called on tap |

---

### `CountdownTimerWidgetx`

Auto-ticking countdown timer with programmatic start/pause/reset control.

```dart
final key = GlobalKey<CountdownTimerWidgetxState>();

CountdownTimerWidgetx(
  key: key,
  duration: const Duration(minutes: 5),
  textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  onFinished: () => showTimeUpDialog(context),
)

// Programmatic control
key.currentState?.pause();
key.currentState?.reset();
key.currentState?.start();
```

Use the `builder` parameter for a fully custom display:

```dart
CountdownTimerWidgetx(
  duration: const Duration(seconds: 30),
  builder: (context, remaining, isFinished) => isFinished
      ? const Text('Time up!')
      : Text('${remaining.inSeconds}s remaining'),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `duration` | `Duration` | required | Starting countdown duration |
| `onFinished` | `VoidCallback?` | — | Fires when countdown reaches zero |
| `onTick` | `Function(Duration)?` | — | Fires every second with remaining time |
| `builder` | `Widget Function(ctx, remaining, isFinished)?` | — | Custom display builder |
| `autoStart` | `bool` | `true` | Start ticking immediately |

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
Patterns.cnic        // Pakistani CNIC: 00000-0000000-0
Patterns.ntn         // Pakistani NTN: 0000000-0
Patterns.ipv4
Patterns.creditCard  // Visa, Mastercard, Amex, Discover, JCB
Patterns.hexColor    // #fff or #ffffff
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

### `ColorX` — on `Color`

HSL-based color utilities.

```dart
Colors.blue.lighten(0.2)               // lighter
Colors.blue.darken(0.2)                // darker
Colors.blue.toHex()                    // → '#2196F3'
Colors.blue.toHex(includeAlpha: true)  // → '#FF2196F3'
Colors.blue.isLight                    // false
Colors.blue.isDark                     // true
Colors.blue.complementary              // hue + 180°
Colors.red.mix(Colors.blue, weight: 0.5)
Colors.blue.withSaturationLevel(0.3)
Colors.blue.withLightnessLevel(0.8)
```

---

### `MapX` — on `Map<K, V>`

```dart
map.getOrDefault('key', 'fallback')
{'a': 1, 'b': 2}.mapValues((v) => v * 2)   // → {'a': 2, 'b': 4}
map.filterKeys((k) => k.startsWith('x'))
map.filterValues((v) => v > 0)
map.toListX((k, v) => '$k=$v')             // → ['a=1', 'b=2']
map.mergeWith(other, resolve: (a, b) => a) // existing wins on conflict
map.inverse                                // swap keys ↔ values
```

---

### `DurationX` — on `Duration`

```dart
const Duration(hours: 2, minutes: 30).format()  // → '2h 30m'
const Duration(seconds: 45).format()            // → '45s'
const Duration(days: 1).fromNow                 // DateTime tomorrow
const Duration(hours: 3).ago                    // DateTime 3 hours ago
const Duration(milliseconds: 500).delay(() => reload())
const Duration(seconds: 10).isZero             // false
const Duration(seconds: 10) * 2.5              // Duration(seconds: 25)
```

---

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
- [`flutter_auto_size_text`](https://pub.dev/packages/flutter_auto_size_text) `^5.0.0` — used by `VxTextBuilder`
