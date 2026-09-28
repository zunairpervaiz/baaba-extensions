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

### `ListX` — additional members

Beyond the aggregation helpers above, `ListX` also covers emptiness, lookups, keying, sorting, set maths, and client-side paging — all null-safe on the receiver.

**Emptiness** — mirrors `StringExtension`:

```dart
List<int>? items;
items.isEmptyOrNull;      // true
items.isNotEmptyOrNull;   // false
items.lengthOrZero;       // 0
items.firstOrNull;        // null — no `?.` needed, unlike Iterable.firstOrNull
items.lastOrNull;         // null
```

**Keying and grouping:**

```dart
users.associateBy((u) => u.id);                   // Map<String, User> — last duplicate wins
users.associateWith((u) => u.id, (u) => u.name);  // Map<String, String>
orders.groupCountBy((o) => o.status);             // {pending: 4, paid: 12}
users.distinctBy((u) => u.id);                    // distinct() needs value equality; this doesn't
```

**Lookups that never throw:**

| Method | Returns |
|---|---|
| `firstWhereOrNull` / `lastWhereOrNull` | The match, or `null` |
| `singleWhereOrNull(predicate)` | The only match; `null` for none **or** many |
| `indexWhereOrNull(predicate)` | The index, or `null` — not `-1`, so it composes with `??` |

**Sorting** — all return a copy, leaving the source untouched:

```dart
posts.sortedByDescending((p) => p.createdAt);
items.sortedWith((a, b) => a.length.compareTo(b.length));
users.sortedByMany([(u) => u.lastName, (u) => u.firstName]);  // ties fall through
rows.isSortedBy((r) => r.position);
```

**Mapping and filtering:**

```dart
rows.mapNotNull((r) => int.tryParse(r.id));   // map + drop nulls in one pass
users.whereNotNullBy((u) => u.email);         // keep elements whose field is set
users.joinToString((u) => u.name, separator: ' & ', prefix: '[', suffix: ']');
```

**Set maths and paging:**

```dart
roles.containsAny([Role.admin, Role.owner]);
roles.containsAll([Role.admin]);
allTags.except(usedTags);        // order preserved
allTags.intersect(userTags);     // order preserved, duplicates dropped

products.pageAt(2, size: 20);    // items 21-40; 1-based to match PaginatorX.firstPage
```

**Randomness** — pass a seeded `Random` to make tests reproducible:

```dart
deck.shuffled();                 // a copy; List.shuffle() mutates in place
banners.randomOrNull();          // null when empty
```

---

### `IterableNullableX` — on `Iterable<T?>?`

```dart
[1, null, 3].whereNotNull();   // [1, 3]
[null, null, 7].firstNotNull;  // 7
```

---

### `IterableAsyncX` — on `Iterable<T>?`

Async iteration without hand-rolling loops or `Future.wait`.

```dart
// Sequential — for writes that must not overlap, or a rate-limited API.
final saved = await drafts.mapAsync((d) => api.save(d));
await files.forEachAsync((f) => uploader.send(f));

// Concurrent, results in the original order.
final users = await ids.mapParallel((id) => api.getUser(id), concurrency: 4);

// Stops at the first match; later elements are never tested.
final first = await servers.firstWhereAsync((s) => s.ping());
```

> `concurrency` caps how many run at once. Leave it null to start them all together — but firing an unbounded number of requests at a server is a common cause of timeouts, so prefer a cap for network work.

---

### `ListAccessX` — on `List<T>`

Indexing that cannot throw.

```dart
['a', 'b'].getOrNull(5);          // null
['a'].getOrElse(9, 'fallback');   // 'fallback'
[1, 2, 3].safeSublist(1, 99);     // [2, 3] — both bounds clamped
```

---

### `ListMutationX` — on `List<T>`

In-place edits.

```dart
selectedIds.toggle(id);          // add if absent, remove if present
items.moveItem(0, 2);            // what ReorderableListView.onReorder hands you
actions.addIf(user.isAdmin, deleteAction);
actions.addAllIf(isOwner, ownerActions);
final gone = items.removeWhereCounted((t) => t.isDone);   // how many went
```

---

### `ListTransformX` — on `List<T>`

Copy-on-write edits for immutable state. The source list is never modified.

```dart
todos.replaceWhere((t) => t.id == id, updated);
state.orders.upsert(order, by: (o) => o.id);   // update the match, or append
[1, 2, 3, 4].rotate(1);                        // [2, 3, 4, 1]; negative rotates right
oldTags.diff(newTags);                         // (added: [...], removed: [...])
['a', 'b'].intersperse('-');                   // ['a', '-', 'b']
```

> The generic separator helper is called `intersperse`, not `separatedBy`, so that it cannot shadow `ListxWidgetExtensions.separatedBy` on a homogeneous widget list such as `List<Text>`, where both extensions would otherwise apply.

---

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

Convert a plain list of widgets directly into a layout widget using method chaining. Every builder returns its **concrete** type (`Row`, `Column`, `Wrap`, `GridView`…), not a widened `Widget`.

```dart
[Text('A'), Text('B'), Text('C')].toRow();
[Text('A'), Text('B'), Text('C')].toColumn(mainAxisAlignment: MainAxisAlignment.center);
[Text('A'), Text('B'), Text('C')].toStack(alignment: Alignment.center);

// ListView — children mode by default, builder mode when itemBuilder is passed.
tiles.toListView(shrinkWrap: true);
tiles.toListView(
  itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
  physics: const NeverScrollableScrollPhysics(),
);
```

> There is deliberately no `toList()`. `Iterable.toList` is an instance method and instance members always beat extensions, so such a member could never be reached — use `toListView()` instead.

**Layout builders**

| Method | Returns |
|---|---|
| `toRow(...)` / `toColumn(...)` / `toStack(...)` | `Row` / `Column` / `Stack` |
| `toWrap({spacing, runSpacing, alignment, ...})` | `Wrap` — flows onto as many lines as needed |
| `toGrid({crossAxisCount, spacing, childAspectRatio, ...})` | `GridView` |
| `toListView({itemBuilder, ...})` | `ListView`, children or builder mode |
| `toPageView({controller, onPageChanged, ...})` | `PageView` |
| `toIndexedStack({index, ...})` | `IndexedStack` — every child keeps its state |
| `toSliverList()` / `toSliverGrid({crossAxisCount, ...})` | For a `CustomScrollView` |
| `toScrollableRow(...)` / `toScrollableColumn(...)` | A `Row`/`Column` that scrolls instead of overflowing |

**List-to-list helpers** — these return a new `List<Widget>`, so they chain into any of the builders above:

```dart
// Separators go between children, never before the first or after the last.
tiles.separatedBy(const Divider(height: 1)).toColumn()
fields.withSpacing(12).toColumn()               // SizedBox gaps
rows.withDividers(indent: 16).toColumn()        // Divider between each

// Wrap every child.
[left, right].expanded().toRow()                // each in an Expanded
items.flexible(fit: FlexFit.tight).toRow()
cards.paddedAll(8).toColumn()
cards.paddedSymmetric(horizontal: 16).toColumn()
```

| Method | Description |
|---|---|
| `separatedBy(Widget)` | Insert a separator between every pair of children |
| `withSpacing(double, {Axis})` | Insert a `SizedBox` gap between children |
| `withDividers({height, thickness, indent, endIndent, color})` | Insert a `Divider` between children |
| `expanded({flex})` / `flexible({flex, fit})` | Wrap **each** child |
| `paddedAll(double)` / `paddedSymmetric({horizontal, vertical})` | Pad each child |

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

### `SheetX` — on `BuildContext`

The bottom-sheet counterpart to `DialogX`. Drag handle, rounded top corners, safe-area padding, keyboard avoidance, and a height cap are all handled — so a sheet works for a form as readily as for a menu.

| Method | Returns |
|---|---|
| `showSheet<T>({required Widget child, ...})` | The value the sheet was popped with |
| `showScrollableSheet<T>({required builder, ...})` | Draggable sheet between `minSize` and `maxSize` |
| `showActionSheet<T>({required List<SheetActionX<T>> actions, ...})` | The value of the tapped row, or `null` |

```dart
// A sheet containing a form. It lifts above the keyboard automatically.
final note = await context.showSheet<String>(
  title: 'Add a note',
  child: NoteForm(),
);

// A draggable, scrolling sheet. Attach the controller to the scrollable.
context.showScrollableSheet(
  title: 'Select a city',
  initialSize: 0.6,
  maxSize: 0.95,
  builder: (context, scrollController) => ListView.builder(
    controller: scrollController,
    itemCount: cities.length,
    itemBuilder: (_, i) => ListTile(title: Text(cities[i])),
  ),
);

// The mobile-native alternative to a dialog full of buttons.
final choice = await context.showActionSheet<String>(
  title: 'Manage post',
  message: 'This cannot be undone.',
  actions: const [
    SheetActionX(label: 'Edit',   icon: Icons.edit_outlined,  value: 'edit'),
    SheetActionX(label: 'Share',  icon: Icons.share_outlined, value: 'share'),
    SheetActionX(label: 'Delete', icon: Icons.delete_outline, value: 'delete', isDestructive: true),
  ],
);
```

`SheetActionX<T>` carries `label`, `subtitle`, `icon` or `leading`, `value`, `onTap`, `isDestructive`, `isEnabled`, and `color`. Rows pop the sheet **before** firing `onTap`, so the callback is free to push a route or open another sheet.

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

// Via extension on a String — the most concise form
'Hello'.text
  .bold
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

**`VxStringTextExtensions` — on `String`**

The quickest way to build styled text — call `.text` directly on any string literal:

```dart
'Hello World'.text.bold.blue600.xl.make()
```

**`VxTextExtensions` — on `Text`**

Convert any existing `Text` widget into a `VxTextBuilder` for further styling:

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

### `LoadingOverlayWidgetx`

A blocking overlay that sits on top of any widget, preventing user interaction while an async operation is in progress. The overlay fades in and out smoothly using `AnimatedOpacity`.

```dart
// Full-screen translucent barrier (default):
LoadingOverlayWidgetx(
  isLoading: _isBusy,
  child: MyScreen(),
)

// Centred spinner only — no background tint:
LoadingOverlayWidgetx(
  isLoading: _isBusy,
  mode: LoadingOverlayMode.centered,
  child: MyScreen(),
)

// Custom indicator and barrier colour:
LoadingOverlayWidgetx(
  isLoading: _isBusy,
  barrierColor: Colors.white70,
  indicator: const MyBrandedSpinner(),
  child: MyScreen(),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Widget rendered beneath the overlay |
| `isLoading` | `bool` | required | When `true`, overlay is visible and child is non-interactive |
| `mode` | `LoadingOverlayMode` | `fullScreen` | Visual style — translucent barrier or spinner-only |
| `barrierColor` | `Color` | `Colors.black54` | Background colour used in `fullScreen` mode |
| `indicator` | `Widget?` | `CircularProgressIndicator` | Custom loading indicator |
| `animationDuration` | `Duration` | `200ms` | Duration of the fade-in / fade-out animation |

**`LoadingOverlayMode` enum:**

```dart
LoadingOverlayMode.fullScreen  // translucent barrier fills the widget area (default)
LoadingOverlayMode.centered    // spinner only, no background tint
```

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

### `PaginatedListWidgetx<T>`

Infinite-scrolling list or grid. It fetches the next page *before* the user hits the bottom, and ships with the loading, empty, and error states already wired — plus pull-to-refresh and an optional Retry / Cancel dialog.

**Simplest form** — a fetcher that returns a list:

```dart
PaginatedListWidgetx<User>(
  fetchItems: (page) => api.getUsers(page: page, limit: 20),
  itemBuilder: (context, user, index) => UserTile(user),
)
```

That single call already gives you a skeleton placeholder on first load, an empty state when there are no results, an inline retry when a page fails, a spinner footer while the next page loads, pull-to-refresh, and prefetching 200px before the end.

**Cursor / `hasMore` aware APIs** — return a `PageX` instead:

```dart
PaginatedListWidgetx<Post>(
  fetchPage: (page, cursor) async {
    final res = await api.feed(cursor: cursor);
    return PageX(items: res.posts, nextCursor: res.next, hasMore: res.hasMore);
  },
  itemBuilder: (context, post, index) => PostCard(post),
  separator: const Divider(height: 1),
  itemId: (post) => post.id,        // drops duplicates across pages
  errorMode: PaginationErrorMode.dialogOnFirstPage,
)
```

**Own the controller** when the screen needs to mutate the list or refresh it from elsewhere — a delete button, a pull-to-refresh in an app bar, a search field:

```dart
late final paginator = PaginatorX<User>(
  fetchPage: (page, _) async => PageX(items: await api.users(page)),
  itemId: (u) => u.id,
);

PaginatedListWidgetx<User>(
  controller: paginator,
  itemBuilder: (context, user, index) => UserTile(
    user,
    onDelete: () async {
      await api.delete(user.id);
      paginator.removeWhere((u) => u.id == user.id);  // no refetch
    },
  ),
)

@override
void dispose() {
  paginator.dispose();   // you own it, so you dispose it
  super.dispose();
}
```

**As a grid** — pass a `gridDelegate`:

```dart
PaginatedListWidgetx<Photo>(
  fetchItems: (page) => api.photos(page),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8,
  ),
  itemBuilder: (context, photo, index) => PhotoTile(photo),
)
```

**Search-driven list** — swap the fetcher, don't rebuild the widget:

```dart
onSearchChanged: (query) => paginator.updateFetcher(
  (page, _) async => PageX(items: await api.search(query, page: page)),
);
```

#### Error handling

An inline retry is **always** available: a retry state in the body when the first page fails, a retry row in the footer when a later page fails. `errorMode` only decides whether a blocking dialog appears on top of it:

```dart
PaginationErrorMode.inline             // default — inline retry only
PaginationErrorMode.dialog             // dialog on every failure
PaginationErrorMode.dialogOnFirstPage  // dialog only when the list is empty
```

`inline` is the default on purpose: page loads fail in bursts on a flaky mobile connection, and a dialog thrown over content the user is reading — repeatedly — is worse than a quiet retry row. `dialogOnFirstPage` is the recommended setting for most screens; a blank screen does deserve an explanation. Cancelling the dialog pauses auto-loading so scrolling doesn't immediately re-fire the request that just failed — the inline Retry brings it back.

```dart
PaginatedListWidgetx<Order>(
  fetchItems: (page) => api.orders(page),
  itemBuilder: (context, order, index) => OrderTile(order),
  errorMode: PaginationErrorMode.dialogOnFirstPage,
  timeout: const Duration(seconds: 15),
  errorMessageBuilder: (error) => error is TimeoutException
      ? 'The server is slow right now.'
      : 'Could not load your orders.',
  onError: (error, stack) => crashlytics.recordError(error, stack),
)
```

#### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `itemBuilder` | `Widget Function(ctx, T item, int index)` | required | Builds one row |
| `controller` | `PaginatorX<T>?` | — | Drive an existing controller (you dispose it) |
| `fetchPage` | `Future<PageX<T>> Function(int page, String? cursor)?` | — | Page fetcher with `hasMore` / cursor |
| `fetchItems` | `Future<List<T>> Function(int page)?` | — | Simple page fetcher |
| `pageSize` | `int?` | global `20` | Items per page, used to infer `hasMore` |
| `firstPage` | `int` | `1` | Page index of the first request |
| `timeout` | `Duration?` | — | Per-request timeout |
| `itemId` | `Object Function(T)?` | — | Stable identity; drops cross-page duplicates |
| `autoLoad` | `bool` | `true` | Load the first page on mount |
| `prefetchThreshold` | `double?` | global `200` | Pixels from the end that trigger the next page |
| `prefetchItemCount` | `int` | `3` | Also trigger when one of the last N items builds |
| `maxAutoFillPages` | `int` | `10` | Cap on pages loaded without any user scroll |
| `errorMode` | `PaginationErrorMode` | `inline` | Whether failures also raise a dialog |
| `enableRefresh` | `bool` | `true` | Wrap in a `RefreshIndicator` |
| `onRefresh` | `Future<void> Function()?` | — | Extra work after a pull-to-refresh |
| `onError` | `Function(Object, StackTrace?)?` | — | Called once per failure |
| `onErrorCancelled` | `VoidCallback?` | — | User dismissed the dialog with Cancel |
| `errorMessageBuilder` | `String Function(Object?)?` | — | Error → message shown to the user |
| `loadingBuilder` | `WidgetBuilder?` | `SkeletonListWidgetx` | First-page loading state |
| `emptyBuilder` | `WidgetBuilder?` | `EmptyStateWidgetx` | No-results state |
| `errorBuilder` | `Widget Function(ctx, error, retry)?` | `EmptyStateWidgetx` | First-page error state |
| `loadMoreBuilder` | `WidgetBuilder?` | spinner | Footer while a later page loads |
| `loadMoreErrorBuilder` | `Widget Function(ctx, error, retry)?` | retry row | Footer when a later page fails |
| `endBuilder` | `WidgetBuilder?` | — | Footer once every page is loaded |
| `header` / `footer` | `Widget?` | — | Pinned inside the scroll view |
| `gridDelegate` | `SliverGridDelegate?` | — | Render a grid instead of a list |
| `separator` / `separatorBuilder` | `Widget?` / `IndexedWidgetBuilder?` | — | Gap between rows |
| `padding` | `EdgeInsets` | `EdgeInsets.all(16)` | Padding around the items |
| `scrollController` | `ScrollController?` | — | Controller for this list's own scroll view |
| `parentScrollController` | `ScrollController?` | — | Outer controller to observe when nested |
| `emptyTitle` / `emptySubtitle` / `emptyIcon` | `String?` / `String?` / `IconData` | globals | Default empty state copy |
| `errorTitle` / `retryText` / `cancelText` | `String?` | globals | Error and dialog copy |
| `physics`, `shrinkWrap`, `scrollDirection`, `reverse`, `primary`, `cacheExtent`, `keyboardDismissBehavior`, `clipBehavior`, `restorationId` | — | — | Forwarded to the scroll view |

> **Nested in another scrollable?** With `shrinkWrap: true` and `NeverScrollableScrollPhysics`, this widget cannot see the outer scroll view. Pass the outer controller as `parentScrollController` so prefetching keeps working.

---

### `SkeletonListWidgetx`

Shimmering list placeholder — the default first-page loading state of `PaginatedListWidgetx`, usable anywhere on its own.

```dart
const SkeletonListWidgetx(rows: 8)
const SkeletonListWidgetx(rows: 6, showAvatar: false, rowHeight: 44)

// Custom row shape:
SkeletonListWidgetx(
  rows: 5,
  rowBuilder: (context, index) =>
      const SkeletonLoaderWidgetx(width: double.infinity, height: 120),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `rows` | `int` | `6` | Number of placeholder rows |
| `rowHeight` | `double` | `56` | Row height; drives the line heights |
| `spacing` | `double` | `12` | Vertical gap between rows |
| `padding` | `EdgeInsets` | `EdgeInsets.all(16)` | Padding around the list |
| `showAvatar` | `bool` | `true` | Leading circular placeholder |
| `avatarSize` | `double` | `44` | Avatar diameter |
| `rowBuilder` | `IndexedWidgetBuilder?` | — | Fully custom row |
| `baseColor` / `highlightColor` | `Color?` | theme grey | Shimmer colours |

---

### `ButtonWidgetx`

A button that understands asynchronous work. When `onPressed` returns a `Future`, the button disables itself, swaps its label for a spinner, and restores itself once the future settles — so the usual `bool _isLoading` + `setState` boilerplate disappears, and a second tap cannot fire while the first is still running.

```dart
ButtonWidgetx(
  text: 'Save',
  icon: Icons.check_rounded,
  onPressed: () async => await api.saveProfile(form.values),
)

// Destructive, full width.
ButtonWidgetx.danger(
  text: 'Delete account',
  expand: true,
  onPressed: () => api.deleteAccount(),
)

// Loading state owned by your state management instead.
ButtonWidgetx(
  text: 'Submit',
  isLoading: state.isSubmitting,
  onPressed: () => bloc.add(Submitted()),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | required | Button label |
| `onPressed` | `FutureOr<void> Function()?` | `null` | Sync or async; `null` disables the button |
| `variant` | `ButtonVariantX` | `filled` | `filled`, `tonal`, `outlined`, `text`, `danger` |
| `size` | `ButtonSizeX` | `medium` | `small`, `medium`, `large` |
| `isLoading` | `bool` | `false` | Forces the loading state on |
| `isEnabled` | `bool` | `true` | Dims and blocks taps |
| `expand` | `bool` | `false` | Stretch to full width |
| `icon` / `trailingIcon` | `IconData?` | `null` | Leading / trailing icon |
| `child` | `Widget?` | `null` | Replaces the label entirely |
| `onError` | `void Function(Object, StackTrace)?` | `null` | Receives a failure; rethrows when null |
| `loadingIndicator` | `Widget?` | `null` | Custom spinner |

Named constructors: `.filled`, `.tonal`, `.outlined`, `.text`, `.danger`.

---

### `TextFieldWidgetx<K>`

The form field that pairs with [`FormX`](#formxk--generic-form-controller). Pass `form:` and `fieldKey:` and the controller, focus node, and next-field traversal are wired for you. Pass a `type:` and the keyboard, autofill hints, icon, obscuring, and validation pattern are chosen to match.

```dart
enum LoginField { email, password }
final form = FormX(LoginField.values);

TextFieldWidgetx(
  form: form,
  fieldKey: LoginField.email,
  label: 'Email',
  type: FieldTypeX.email,   // email keyboard + Patterns.email validation
  isRequired: true,
  nextField: LoginField.password,
)

TextFieldWidgetx(
  form: form,
  fieldKey: LoginField.password,
  label: 'Password',
  type: FieldTypeX.password, // obscured, with a visibility toggle
  isRequired: true,
  minLength: 8,
)

// Standalone, no FormX.
TextFieldWidgetx(
  controller: searchController,
  hint: 'Search products',
  type: FieldTypeX.search,
)
```

`FieldTypeX` presets: `text`, `email`, `password`, `phone`, `number`, `multiline`, `search`, `url`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `form` / `fieldKey` | `FormX<K>?` / `K?` | `null` | Source of the controller and focus node |
| `nextField` | `K?` | `null` | Field focused on submit |
| `type` | `FieldTypeX` | `text` | Keyboard, autofill, icon, pattern preset |
| `isRequired` | `bool` | `false` | Empty fails validation; appends `*` to the label |
| `minLength` | `int?` | `null` | Minimum character count |
| `validationPattern` | `String?` | from `type` | Regex the trimmed value must match |
| `validator` | `String? Function(String)?` | `null` | Extra check after the built-ins pass |
| `errorText` | `String?` | `null` | External error — server-side validation |
| `readOnly` + `onTap` | `bool` + `VoidCallback?` | — | Open a picker instead of the keyboard |

Only what the widget created itself is disposed — a `FormX` or a caller-supplied controller outlives the field.

---

### `AsyncBuilderWidgetx<T>`

`FutureBuilder` with the loading, empty, and error states already wired. What `PaginatedListWidgetx` does for paginated lists, this does for every single-shot fetch.

`future` is a **factory**, not a future, so a rebuild never refires the request and retry can re-run it.

```dart
AsyncBuilderWidgetx<Profile>(
  future: () => api.getProfile(userId),
  builder: (context, profile) => ProfileView(profile),
)

// A list — the empty state is detected for you.
AsyncBuilderWidgetx<List<Order>>(
  future: () => api.getOrders(),
  emptyTitle: 'No orders yet',
  enableRefresh: true,
  builder: (context, orders) => Column(children: orders.map(OrderTile.new).toList()),
)

// Refetch whenever the id changes.
AsyncBuilderWidgetx<Product>(
  future: () => api.getProduct(id),
  reloadOn: id,
  builder: (context, product) => ProductView(product),
)

// Live data.
AsyncBuilderWidgetx<int>.stream(
  stream: counter.stream,
  builder: (context, value) => Text('$value'),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `future` | `Future<T> Function()?` | required | Factory called on mount and on retry |
| `builder` | `Widget Function(BuildContext, T)` | required | The data state |
| `reloadOn` | `Object?` | `null` | Refetches when this value changes |
| `isEmpty` | `bool Function(T)?` | smart default | `null`, empty `Iterable`/`Map`, blank `String` |
| `keepPreviousData` | `bool` | `false` | Hold the last result through a reload |
| `enableRefresh` | `bool` | `false` | Wraps the data state in pull-to-refresh |
| `loadingBuilder` / `emptyBuilder` / `errorBuilder` | builders | package defaults | Override any state |
| `onError` / `onData` | callbacks | `null` | Fire once per distinct event, after the frame |

The state class `AsyncBuilderWidgetxState<T>` is public, so a `GlobalKey` can call `retry()`.

---

### `QuantityStepperWidgetx`

The `− n +` control used in carts and order screens. Controlled by the parent: `onChanged` fires with the new quantity, always clamped between `min` and `max`.

```dart
QuantityStepperWidgetx(
  value: item.quantity,
  min: 1,
  max: item.stock,
  onChanged: (qty) => cart.setQuantity(item, qty),
  onRemove: () => cart.remove(item), // minus becomes a delete icon at min
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` / `onChanged` | `int` / `ValueChanged<int>` | required | Controlled quantity |
| `min` / `max` / `step` | `int` | `1` / `99` / `1` | Range and increment |
| `onRemove` | `VoidCallback?` | `null` | Minus turns into a delete icon at `min` |
| `allowManualInput` | `bool` | `false` | Tap the number and type |
| `enableLongPressRepeat` | `bool` | `true` | Hold to repeat (never on the remove action) |
| `isLoading` | `bool` | `false` | Swaps the number for a spinner |

---

### `BadgeWidgetx`

A count or dot badge anchored to the corner of any widget. Hides at zero and caps at `maxCount`, so it never grows unbounded over a tab icon.

```dart
BadgeWidgetx(count: unreadCount, child: const Icon(Icons.notifications_outlined))

BadgeWidgetx.dot(isVisible: hasUpdates, color: Colors.green, child: const Icon(Icons.person_outline))

BadgeWidgetx(label: 'NEW', child: ProductCard(product))
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `count` | `int?` | `null` | Hidden at `0` unless `showZero` |
| `label` | `String?` | `null` | Text instead of a count |
| `maxCount` | `int` | `99` | Above this renders `99+` |
| `isVisible` | `bool` | `true` | Hides the badge entirely |
| `alignment` / `offset` | — | top-right | Anchor position |
| `animate` | `bool` | `true` | Scale transition on appear and on change |

---

### `AlertBannerWidgetx`

An inline success / error / warning / info banner, for the cases a snackbar is wrong: a validation summary above a form, an account-status notice, a warning that must stay on screen until it is resolved.

```dart
AlertBannerWidgetx.error(
  title: 'Payment failed',
  message: 'Your card was declined. Try a different payment method.',
  onClose: () => setState(() => showError = false),
)

AlertBannerWidgetx.success(message: 'Profile updated.')

AlertBannerWidgetx.warning(
  message: 'Your session expires in 2 minutes.',
  actionText: 'Extend',
  onAction: extendSession,
)
```

Named constructors `.success`, `.error`, `.warning`, `.info` select the colour and icon. `isFilled: true` swaps the tinted-with-accent-bar style for a solid one. Marked as a `liveRegion` for screen readers.

---

### `TimelineWidgetx`

A vertical timeline for order tracking, activity feeds, and audit trails — the vertical counterpart to `StepperIndicatorWidgetx`.

```dart
TimelineWidgetx(
  items: [
    TimelineItemX(title: 'Order placed',      timestamp: '09:02 AM', state: TimelineItemStateX.completed),
    TimelineItemX(title: 'Packed',            timestamp: '09:40 AM', state: TimelineItemStateX.completed),
    TimelineItemX(title: 'Out for delivery',  timestamp: '10:24 AM', state: TimelineItemStateX.active,
                  subtitle: 'Courier: Ali Raza'),
    TimelineItemX(title: 'Delivered'),
  ],
)
```

`TimelineItemX` carries `title`, `subtitle`, `timestamp`, `state`, `icon`, `color`, a `content` widget, and `onTap`. `TimelineItemStateX` (`completed`, `active`, `pending`) drives the node and connector styling: completed nodes show a check, the active node is ringed and shadowed, pending steps are muted. Set `timestampWidth` for a leading timestamp column, or `dashPendingConnector` for dashed future connectors.

---

### `ChipsFilterWidgetx<T>`

A row or wrap of selectable filter chips, in single- or multi-select mode.

```dart
// Multi-select, wrapping onto several lines.
ChipsFilterWidgetx<String>(
  items: const ['Pizza', 'Burgers', 'Biryani', 'Desserts'],
  selected: activeFilters,
  onChanged: (values) => setState(() => activeFilters = values),
)

// Single-select, scrolling horizontally on one line.
ChipsFilterWidgetx<Category>(
  items: categories,
  labelBuilder: (c) => c.name,
  countBuilder: (c) => c.productCount,
  selected: selectedCategory == null ? [] : [selectedCategory!],
  mode: ChipsSelectionModeX.single,
  isScrollable: true,
  onChanged: (values) => setState(() => selectedCategory = values.firstOrNull),
)
```

`onChanged` always emits a **new** list rather than mutating the one it was given, so immutable state stays safe. In single mode, `allowEmpty` decides whether re-tapping the selected chip clears it.

---

### `SegmentedControlWidgetx<T>`

A two- or three-way toggle with an animated sliding indicator — cleaner than a `TabBar` for a small, fixed set of mutually exclusive choices.

```dart
SegmentedControlWidgetx<OrderFilter>(
  items: OrderFilter.values,
  value: filter,
  labelBuilder: (f) => f.name.capitalizeFirstLetter(),
  onChanged: (f) => setState(() => filter = f),
)

// Icon-only layout switcher.
SegmentedControlWidgetx<bool>(
  items: const [false, true],
  value: isGrid,
  labelBuilder: (v) => v ? 'Grid' : 'List',
  iconBuilder: (v) => v ? Icons.grid_view_rounded : Icons.view_list_rounded,
  showLabels: false,
  onChanged: (v) => setState(() => isGrid = v),
)
```

Tapping the already-selected segment does not fire `onChanged`. A `value` not present in `items` simply highlights nothing rather than throwing.

---

### `NetworkImageWidgetx`

`Image.network` with the four things it leaves to you: a shimmering placeholder, an error fallback, rounded corners, and a fade-in. A null or blank `url` goes straight to the error state, so a missing avatar or product photo needs no null check at the call site.

```dart
NetworkImageWidgetx(
  url: product.imageUrl,
  width: double.infinity,
  height: 180,
  borderRadius: 12,
)

// Circular avatar with initials as the fallback.
NetworkImageWidgetx.circle(
  url: user.avatarUrl,
  size: 48,
  errorWidget: Text(user.initials),
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `url` | `String?` | required | Null or blank renders `errorWidget` |
| `placeholder` | `Widget?` | `SkeletonLoaderWidgetx` | Shown while downloading |
| `errorWidget` | `Widget?` | broken-image icon | Shown on failure |
| `showProgress` | `bool` | `false` | Determinate spinner when the server reports a size |
| `borderRadius` / `isCircle` | — | `0` / `false` | Clipping |
| `heroTag` | `Object?` | `null` | Wraps in a `Hero` |
| `headers` | `Map<String, String>?` | `null` | Auth tokens |

---

### `ScrollToTopWidgetx`

Wraps a scrollable and floats a "back to top" button over it once the user passes `threshold`. The same controller must be attached to both.

```dart
final controller = ScrollController();

ScrollToTopWidgetx(
  controller: controller,
  threshold: 300,
  child: ListView.builder(
    controller: controller,
    itemCount: posts.length,
    itemBuilder: (_, i) => PostCard(posts[i]),
  ),
)
```

Rebuilds only when the button crosses the threshold, not on every scroll notification. Set `label` for an extended FAB, or `button` to replace the button entirely while keeping the show/hide behaviour. The controller belongs to the caller — only the listener is removed on dispose.

---

### `AnimatedCounterWidgetx`

A number that animates from its previous value to its new one — stat tiles, cart totals, live scores, price changes.

```dart
AnimatedCounterWidgetx(value: order.total, prefix: 'Rs. ', decimals: 2)

AnimatedCounterWidgetx(
  value: followers,
  useThousandsSeparator: true,
  textStyle: context.textTheme.headlineMedium,
)

// Plug in intl, or any formatting you like.
AnimatedCounterWidgetx(
  value: revenue,
  formatter: (v) => NumberFormat.compactCurrency(symbol: 'Rs. ').format(v),
)
```

`useThousandsSeparator` is sign- and fraction-aware — `-12345.5` with `decimals: 2` becomes `-12,345.50`. `initialValue` controls whether the first build counts up from zero or renders the final number immediately. `format()` is public, so the formatting can be unit-tested without pumping a widget.

---

### `CircularProgressWidgetx`

A circular progress ring with a label in the middle. Unlike `CircularProgressIndicator` it animates between values, supports a gradient sweep, and renders its own percentage label.

```dart
CircularProgressWidgetx(value: 0.72, size: 120)

CircularProgressWidgetx(
  value: uploaded / total,
  size: 90,
  strokeWidth: 8,
  gradientColors: const [Colors.orange, Colors.pink],
  center: Text('${uploaded}MB'),
)

// Indeterminate, while the total is still unknown.
CircularProgressWidgetx(value: null, size: 60)
```

`startAngle` is measured in degrees clockwise from twelve o'clock. `caption` adds a line under the percentage; `center` replaces the label entirely. A null `value` falls back to an indeterminate spinner.

---

### `ConnectivityBannerWidgetx`

Slides an offline banner over the app when connectivity drops, and a brief "Back online" confirmation when it returns. Wrap it once around the app rather than per screen:

```dart
MaterialApp(
  builder: (context, child) => ConnectivityBannerWidgetx(child: child!),
  home: const HomePage(),
)
```

`connectivity_plus` reports whether a network *interface* is up, not whether the internet is actually reachable — a captive-portal wifi still counts as connected. Pass `verifyConnection` to make the banner depend on a real request:

```dart
ConnectivityBannerWidgetx(
  verifyConnection: () async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  },
  child: const HomePage(),
)
```

`statusStream` overrides the source entirely — useful in tests, and for apps that already track connection state themselves. The banner leaves the widget tree once it has slid away, so a hidden banner is never left rendering text where screen readers would still reach it.

---

### `ImagePickerSheetWidgetx`

The "Take a photo / Choose from gallery / Remove" sheet, with the picking already wired to `image_picker`.

```dart
// One call: sheet, picker, file.
final file = await ImagePickerSheetWidgetx.pick(
  context,
  showRemove: avatarPath != null,
  imageQuality: 70,
  maxWidth: 1080,
  onRemove: removeAvatar,
);
if (file != null) setState(() => avatarPath = file.path);

// Stop after the choice — for a cropper in between, or a custom camera.
final source = await ImagePickerSheetWidgetx.pickSource(context);

// Multiple gallery images.
final files = await ImagePickerSheetWidgetx.pickMultiple(context, limit: 5);
```

A denied permission or a plugin failure surfaces as `null` (or through `onError`) rather than crashing the calling screen. `picker:` accepts an injected `ImagePicker` for tests.

> **iOS setup:** add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `Info.plist`.

---

## Utils

### `PaginatorX<T>` — Pagination controller

The engine behind `PaginatedListWidgetx`, usable on its own with any layout — a `SliverList`, a `PageView`, your own custom scroll view — and with any state management, since it is just a `ChangeNotifier`.

```dart
final paginator = PaginatorX<User>(
  pageSize: 20,
  itemId: (u) => u.id,
  timeout: const Duration(seconds: 15),
  fetchPage: (page, cursor) async {
    final res = await api.users(page: page, limit: 20);
    return PageX(items: res.users, hasMore: res.hasNext);
  },
);

// Or, for an API that just returns a list:
final simple = PaginatorX<User>.simple(
  fetch: (page) => api.getUsers(page: page, limit: 20),
);

ListenableBuilder(
  listenable: paginator,
  builder: (context, _) => MyCustomLayout(items: paginator.items),
)
```

#### Loading

| Member | Description |
|---|---|
| `loadFirstPage({force})` | Loads page one; a no-op once loading has started |
| `loadNextPage()` | Loads the next page; a no-op unless `canLoadMore` |
| `refresh()` | Reloads from page one, keeping items visible until the new ones land |
| `retry()` | Repeats whichever request failed last and clears `isPaused` |
| `pause()` / `resume({loadMore})` | Suspend and restore auto-loading |
| `reset({notify})` | Clears items and all page/cursor state |
| `updateFetcher(fetcher, {reload})` | Swap the query — search terms, filters |

#### State

| Member | Type | Description |
|---|---|---|
| `items` | `UnmodifiableListView<T>` | Live view of every loaded item |
| `itemCount` | `int` | Number of loaded items |
| `status` | `PaginationStatus` | `initial`, `loadingFirst`, `refreshing`, `loadingMore`, `loaded`, `empty`, `firstPageError`, `loadMoreError` |
| `isLoading` / `isLoadingFirstPage` / `isLoadingMore` / `isRefreshing` | `bool` | In-flight flags |
| `hasError` / `error` / `stackTrace` | `bool` / `Object?` / `StackTrace?` | Last failure |
| `isEmpty` | `bool` | A load succeeded and produced nothing |
| `hasMore` / `canLoadMore` | `bool` | End-of-list, and whether a request is allowed right now |
| `nextPage` / `cursor` / `totalCount` | `int` / `String?` / `int?` | Request bookkeeping |
| `isPaused` | `bool` | Auto-loading suspended by `pause()` |

#### Local mutations

Reflect an optimistic create, edit, or delete without refetching the list:

```dart
paginator.addItem(user);
paginator.addItems(users);
paginator.insertItem(0, user);
paginator.removeAt(3);
paginator.removeWhere((u) => u.id == deletedId);
paginator.replaceAt(2, updatedUser);
paginator.updateWhere((u) => u.id == id, (u) => u.copyWith(liked: true));
paginator.setItems(newList);
paginator.clearItems();
```

#### What it guards for you

- **Re-entrancy** — a scroll listener firing 60×/second cannot queue duplicate requests for the same page.
- **Stale responses** — a `refresh()` pre-empts an in-flight page load, and the older response is discarded when it lands instead of appending to freshly refreshed data.
- **Post-dispose responses** — a request that outlives the screen never notifies a disposed controller.
- **Duplicate rows** — set `itemId` and rows that shift on the server between requests are dropped instead of appearing twice.
- **A lying `hasMore`** — an empty page, or one that adds nothing new and returns no fresh cursor, ends the list rather than looping forever.
- **Short first pages** — `PaginatedListWidgetx` keeps loading until the viewport is actually scrollable, so a tall screen with a small `pageSize` doesn't strand the list.

### `PageX<T>`

One page of results.

| Field | Type | Description |
|---|---|---|
| `items` | `List<T>` | The page's items |
| `hasMore` | `bool?` | Whether more pages exist; inferred from `pageSize` when `null` |
| `nextCursor` | `String?` | Cursor for the following page |
| `totalCount` | `int?` | Server-reported total, when available |

`PageX.empty()` returns an empty, final page — a handy early return in a fetcher.

---

### `FormX<K>` — Generic form controller

Manages all `TextEditingController` instances for a form under a single typed object. Works with enums, strings, or any key type — no more declaring a separate controller variable per field.

```dart
// 1. Define fields as an enum (one per form)
enum LoginField { email, password }

// 2. Create — one variable instead of many controllers
late final FormX<LoginField> form;

@override
void initState() {
  super.initState();
  form = FormX(LoginField.values);
}

@override
void dispose() {
  form.dispose(); // disposes all controllers at once
  super.dispose();
}

// 3. Wire up — works with TextField, TextFormField, with or without a Form widget
TextFormField(controller: form[LoginField.email])
TextField(controller: form[LoginField.password])

// 4. Get all values on submit
final data = form.values;
// {LoginField.email: 'ali@gmail.com', LoginField.password: '1234'}

// 5. Get a single value
final email = form.value(LoginField.email);

// 6. Pre-fill for edit screens
form.fill({LoginField.email: existingUser.email});

// 7. Clear all fields
form.reset();
```

String keys work identically if you prefer not to define an enum:

```dart
final form = FormX(['name', 'email', 'phone']);
TextFormField(controller: form['name'])
final data = form.values; // {'name': 'Ali', 'email': '...', 'phone': '...'}
```

| Member | Description |
|---|---|
| `FormX(List<K> keys)` | Creates a controller for each key |
| `form[key]` | Returns the `TextEditingController` for `key` |
| `form.values` | `Map<K, String>` of trimmed values for all fields |
| `form.value(key)` | Trimmed value for a single field |
| `form.fill(Map<K, String>)` | Pre-populates fields from existing data |
| `form.reset()` | Clears all fields |
| `form.dispose()` | Disposes all controllers — call in `State.dispose()` |

---

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

### Global Pagination Config

Set these once in `main()` and every paginated list in the app inherits them — including the copy, so a localised app sets its strings in one place:

```dart
defaultPaginationPageSizeGlobal          = 25;
defaultPaginationPrefetchThresholdGlobal = 400;
defaultPaginationErrorTitleGlobal        = 'Kuch ghalat ho gaya';
defaultPaginationErrorMessageGlobal      = 'Data load nahi ho saka. Dobara koshish karein.';
defaultPaginationTimeoutMessageGlobal    = 'Server ka jawab dair se aaya.';
defaultPaginationRetryTextGlobal         = 'Dobara';
defaultPaginationCancelTextGlobal        = 'Cancel';
defaultPaginationEmptyTitleGlobal        = 'Kuch nahi mila';
```

---

### Global Button, Field & Sheet Config

```dart
defaultButtonBorderRadiusGlobal   = 12;
defaultButtonHeightSmallGlobal    = 38;
defaultButtonHeightMediumGlobal   = 48;
defaultButtonHeightLargeGlobal    = 56;

defaultFieldBorderRadiusGlobal        = 12;
defaultFieldRequiredMessageGlobal     = 'Yeh field zaroori hai';
defaultFieldInvalidEmailMessageGlobal = 'Sahi email darj karein';
defaultFieldInvalidPhoneMessageGlobal = 'Sahi phone number darj karein';

defaultSheetBorderRadiusGlobal = 24;
defaultSheetCancelTextGlobal   = 'Cancel';
```

---

### Global Alert & Async Config

```dart
defaultAlertSuccessColorGlobal = const Color(0xFF2E7D32);
defaultAlertErrorColorGlobal   = const Color(0xFFC62828);
defaultAlertWarningColorGlobal = const Color(0xFFEF6C00);
defaultAlertInfoColorGlobal    = const Color(0xFF1565C0);

defaultAsyncErrorTitleGlobal   = 'Kuch ghalat ho gaya';
defaultAsyncErrorMessageGlobal = 'Data load nahi ho saka. Dobara koshish karein.';
defaultAsyncRetryTextGlobal    = 'Dobara';
defaultAsyncEmptyTitleGlobal   = 'Kuch nahi mila';
```

---

### Global Connectivity & Image Picker Config

```dart
defaultOfflineMessageGlobal = 'Internet band hai';
defaultOnlineMessageGlobal  = 'Internet wapas aa gaya';

defaultImagePickerTitleGlobal       = 'Tasveer chunein';
defaultImagePickerCameraTextGlobal  = 'Tasveer lein';
defaultImagePickerGalleryTextGlobal = 'Gallery se chunein';
defaultImagePickerRemoveTextGlobal  = 'Tasveer hatayein';
```

---

## Requirements

- Dart SDK `^3.12.0`
- Flutter `>=3.44.0`
- [`fluttertoast`](https://pub.dev/packages/fluttertoast) `^10.0.0` — used by `StringExtension.toastString()`
- [`flutter_auto_size_text`](https://pub.dev/packages/flutter_auto_size_text) `^5.0.0` — used by `VxTextBuilder`
- [`connectivity_plus`](https://pub.dev/packages/connectivity_plus) `^7.3.1` — used by `ConnectivityBannerWidgetx`
- [`image_picker`](https://pub.dev/packages/image_picker) `^1.2.3` — used by `ImagePickerSheetWidgetx`

`connectivity_plus` and `image_picker` are **platform plugins**, so every app depending on `baaba_extensions` inherits them even if it never uses those two widgets. Apps that use `ImagePickerSheetWidgetx` must also add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to their iOS `Info.plist`.
