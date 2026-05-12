## 0.5.0

### Added — Extensions

#### `WidgetX on Widget` (new members)
- `.padding(EdgeInsets)` / `.paddingAll(double)` / `.paddingSymmetric(h, v)` / `.paddingOnly(...)` — padding wrappers.
- `.opacity(double)` — `Opacity` wrapper; value clamped to 0.0–1.0.
- `.rotate(double)` — `Transform.rotate` wrapper (angle in radians).
- `.scale(double)` — `Transform.scale` wrapper.
- `.translate({dx, dy})` — `Transform.translate` wrapper.
- `.flexible({flex, fit})` — `Flexible` wrapper.
- `.card({elevation, color, shadowColor, borderRadius, margin})` — `Card` wrapper.
- `.tooltip(String)` — `Tooltip` wrapper.
- `.hero(Object tag)` — `Hero` wrapper.
- `.safeArea({top, bottom, left, right})` — `SafeArea` wrapper.
- `.sliverBox` — `SliverToBoxAdapter` getter.

#### `ContextX on BuildContext` (new members)
- `.isDark` / `.isLight` — theme brightness checks.
- `.orientation` / `.isPortrait` / `.isLandscape` — device orientation.
- `.topPadding` / `.bottomPadding` / `.viewPadding` / `.viewInsets` — safe-area insets.
- `.pixelRatio` / `.locale` — device and locale info.
- `.navigator` — nearest `NavigatorState`.
- `.push(page)` / `.pop()` / `.pushNamed(route)` / `.pushReplacement(page)` / `.pushAndRemoveAll(page)` — navigation helpers.
- `.showSnackBar(SnackBar)` — `ScaffoldMessenger` shortcut.
- `.showModalSheet({builder, ...})` — modal bottom sheet shortcut.

#### `DateTimeExt on DateTime` (new members)
- `.isWeekend` / `.isWeekday` — day-of-week checks.
- `.startOfWeek` / `.endOfWeek` — week boundary `DateTime`s.
- `.startOfMonth` / `.endOfMonth` — month boundary `DateTime`s.
- `.startOfYear` / `.endOfYear` — year boundary `DateTime`s.
- `.isSameMonth(other)` / `.isSameYear(other)` — calendar comparisons.
- `.quarterOf` — returns 1–4.
- `.age` — full years elapsed from this date to today.
- `.addDays(n)` / `.subtractDays(n)` / `.addHours(n)` / `.subtractHours(n)` / `.addMinutes(n)` / `.subtractMinutes(n)` — convenience arithmetic.

#### `NumTimeX on int` (new members)
- `.minutesAgo` / `.secondsAgo` — past relative `DateTime`s.
- `.daysFromNow` / `.hoursFromNow` / `.minutesFromNow` / `.secondsFromNow` — future relative `DateTime`s.

#### `NumX on num` (new members)
- `.isBetween(min, max)` — inclusive range check.
- `.roundTo(int decimals)` — rounds to N decimal places and returns `double`.

#### `NumPaddingX on num` (improved)
- `.ordinal` — fixed 11th/12th/13th (teen) edge cases.

#### `ListX on Iterable<T>?` (new members)
- `.distinct()` — deduplicates preserving order.
- `.sortedBy(keySelector)` — returns a sorted copy.
- `.mapIndexed(transform)` — maps with index.
- `.countWhere(predicate)` — counts matching elements.
- `.maxBy(keySelector)` / `.minBy(keySelector)` — find extremes by property.
- `.none(predicate)` — true when no element satisfies the predicate.

#### `IterableIterableX on Iterable<Iterable<T>>` (new extension)
- `.flatten()` — flattens nested iterables into a single `List`.

#### `ScrollxExtensions on ScrollController` (new members)
- `.jumpToBottom()` / `.jumpToTop()` — instant non-animated scroll.
- `.isAtTop` / `.isAtBottom` — exact edge checks.
- `.isNearTop({threshold})` — counterpart to `isNearBottom`.
- `.scrollPercentage` — 0.0–1.0 progress through the scrollable.

#### `StringExtension on String?` (new members)
- `.stripHtml()` — removes all HTML tags.
- `.containsAny(List<String>)` — true if any needle is present.
- `.containsAll(List<String>)` — true if all needles are present.
- `.wrapAt(int lineLength)` — soft-wraps at word boundaries.

#### `Patterns` (new constants)
- `cnic` — Pakistani CNIC format `00000-0000000-0`.
- `ntn` — Pakistani NTN format `0000000-0`.
- `ipv4` — IPv4 address.
- `creditCard` — Visa / Mastercard / Amex / Discover / JCB.
- `hexColor` — `#fff` or `#ffffff`.

### Added — New Extensions

#### `ColorX on Color`
- `.lighten([amount])` / `.darken([amount])` — HSL-based lightness adjustment.
- `.toHex({leadingHash, includeAlpha})` — hex string, e.g. `'#2196F3'`.
- `.isLight` / `.isDark` — luminance-based brightness check.
- `.complementary` — color with hue shifted 180°.
- `.mix(Color, {weight})` — blend two colors by weight.
- `.withSaturationLevel(double)` / `.withLightnessLevel(double)` — HSL component overrides.

#### `MapX on Map<K, V>`
- `.getOrDefault(key, defaultValue)` — safe key lookup.
- `.mapValues(transform)` — transform all values.
- `.filterKeys(predicate)` / `.filterValues(predicate)` — filter by key or value.
- `.toListX(transform)` — convert entries to a list.
- `.mergeWith(other, {resolve})` — merge two maps with optional conflict resolver.
- `.inverse` — swap keys and values.

#### `DurationX on Duration`
- `.format()` — compact human-readable string, e.g. `'2h 30m'`, `'45s'`.
- `.fromNow` — `DateTime` this duration from now.
- `.ago` — `DateTime` this duration before now.
- `.delay(VoidCallback)` — `Future.delayed` shortcut.
- `.isZero` — true when `inMicroseconds == 0`.
- `* double` operator — scaled `Duration`.

### Added — New Widgets

| Widget | Description |
|---|---|
| `SkeletonLoaderWidgetx` | Shimmer loading placeholder with customizable size, radius, and colors |
| `EmptyStateWidgetx` | Icon + title + subtitle + optional action button, auto-centered |
| `AvatarWidgetx` | Circular avatar with network image, initials fallback, badge count, online indicator |
| `PinInputWidgetx` | PIN / OTP input as a row of individual boxes with auto-focus and backspace navigation |
| `ExpandableWidgetx` | Animated expand / collapse container with chevron icon |
| `GradientButtonWidgetx` | Ink-ripple button with a `LinearGradient` fill |
| `SearchBarWidgetx` | Styled search field with clear button and configurable debounce |
| `StepperIndicatorWidgetx` | Horizontal step indicator with completed / active / inactive states and optional labels |
| `RatingWidgetx` | Star rating input and display with optional half-star support |
| `CountdownTimerWidgetx` | Auto-ticking countdown with `start()`, `pause()`, `reset()` control and `onFinished` callback |

---

## 0.4.0

### Added
- `ListxWidgetExtensions on List<Widget>` — convert a list of widgets directly into layout widgets:
  - `.toRow(...)` — wraps children in a `Row` with full `Row` parameter support.
  - `.toColumn(...)` — wraps children in a `Column` with full `Column` parameter support.
  - `.toStack(...)` — wraps children in a `Stack` with alignment, fit, and clip options.
  - `.toList(...)` — wraps children in a `ListView` (children mode) with all `ListView` parameters.
  - `.toListView(itemBuilder:, ...)` — wraps children in a `ListView.builder` with a custom item builder.
- `ScrollxExtensions on ScrollController` — fluent scroll utilities:
  - `.animateToPosition(offset)` — smooth animated scroll to any offset.
  - `.animateToBottom()` — animated scroll to the end of the scrollable.
  - `.animateToTop()` — animated scroll to the beginning of the scrollable.
  - `.isNearBottom({threshold})` — returns `true` when within `threshold` pixels of the bottom.
  - `.canScroll` — `true` if the controller has clients and the content is actually scrollable.

---

## 0.3.0

### Added
- `VxTextBuilder` — a fluent, chainable text-styling builder backed by `AutoSizeText`:
  - **Font weights** — `.hairLine`, `.thin`, `.light`, `.normal`, `.medium`, `.semiBold`, `.bold`, `.extraBold`, `.extraBlack`.
  - **Scale aliases** — `.xs` (0.75×), `.sm` (0.875×), `.base` (1×), `.lg` (1.125×), `.xl`–`.xl6` up to 4×; or exact size via `.size(n)`.
  - **Alignment** — `.center`, `.start`, `.end`, `.justify`.
  - **Text transforms** — `.uppercase`, `.lowercase`, `.capitalize`.
  - **Overflow** — `.ellipsis`, `.fade`, `.visible`, or `.overflow(TextOverflow.*)`.
  - **Text decoration** — `.underline`, `.lineThrough`, `.overline`.
  - **Letter spacing** — `.tight`, `.tighter`, `.tightest`, `.wide`, `.wider`, `.widest`, or `.letterSpacing(n)`.
  - **Line height** — `.heightTight`, `.heightSnug`, `.heightRelaxed`, `.heightLoose`, or `.lineHeight(n)`.
  - **Shadow** — `.shadow(offsetX, offsetY, blur, color)`, `.shadowBlur()`, `.shadowColor()`, `.shadowOffset()`.
  - **Color** — full Tailwind-style palette via shorthand getters (e.g. `.blue500`, `.red300`, `.emerald700`), plus `.white`, `.black`, `.transparent`.
  - **TextTheme integration** — `.displayLarge(context)`, `.headlineMedium(context)`, `.bodySmall(context)`, etc. for all M3 text roles.
  - **Conditional rendering** — `.when(bool)` — renders `SizedBox.shrink()` when false.
  - **Auto-size controls** — `.minFontSize()`, `.maxFontSize()`, `.stepGranularity()`, `.overflowReplacement()`, `.wrapWords()`.
  - **Intrinsic mode** — `.isIntrinsic` disables `AutoSizeText` for widgets incompatible with `LayoutBuilder` (e.g. `IntrinsicWidth`).
  - `.make({Key? key})` — produces the final `Widget`.
- `VxTextExtensions on Text` — `.text` getter converts an existing `Text` into a `VxTextBuilder` for further styling.
- `NoneWidget` — internal `SizedBox.shrink()` sentinel; used by `VxTextBuilder.when(false)`.
- `VxWidgetBuilders` / `VxWidgetContextBuilder` / `VxTextSpanBuilder` — internal abstract builder base classes.
- `VxColorMixin` / `VxRenderMixin` — internal mixins consumed by `VxTextBuilder`.
- `Vx` mixin — internal Tailwind-scale color constants, pixel-value constants, and `EdgeInsets` presets used by the builder system.
- `StringExtension.capitalizeAllWords()` — capitalizes the first letter of every word in a string; used internally by `VxTextBuilder.capitalize`.
- Added `flutter_auto_size_text: ^5.0.0` dependency.

---

## 0.2.0

### Added
- `SwiperWidgetx` — a fully-featured carousel/swiper widget with both list and builder constructors:
  - Supports infinite scroll, auto-play, custom intervals/curves, enlarge-center-page, and bi-directional scroll.
  - Named constructors: `SwiperWidgetx(items: [...])` and `SwiperWidgetx.builder(itemCount:, itemBuilder:)`.
  - Programmatic control via `nextPage`, `previousPage`, `jumpToPage`, and `animateToPage`.
  - Configurable `viewportFraction`, `aspectRatio`, `height`, `scrollDirection`, fast-scrolling toggle, and `onPageChanged` callback.

---

## 0.1.0

### Added
- `DialogX on BuildContext` — two new context-level dialog methods:
  - `showConfirmDialog(...)` — confirmation dialog with confirm/cancel actions, returns `Future<bool?>` (`true` = confirmed, `false` = cancelled, `null` = dismissed).
  - `showInfoDialog(...)` — information dialog with a single close action, returns `Future<void>`.
- Both dialogs support full customization: `title`, `message`, `icon`, `confirmColor`/`accentColor`, `cancelColor`, `backgroundColor`, `borderRadius`, `titleStyle`, `messageStyle`, `barrierDismissible`, and optional callbacks.
- New global dialog config vars in `default_configs.dart`:
  - `defaultDialogConfirmColorGlobal`
  - `defaultDialogCancelColorGlobal`
  - `defaultDialogInfoColorGlobal`
  - `defaultDialogBorderRadiusGlobal`

---

## 0.0.1

### Added
- `StringExtension on String?` — null-safe string helpers: validation, formatting, masking, conversion, clipboard, Firebase search param, Pakistan mobile formatting, toast.
- `NumX` / `NumPaddingX on num` — `SizedBox` and `EdgeInsets` shortcuts, ordinal, percentage, async delay.
- `NumDurationX` / `NumTimeX` / `NumCoerceInExtension on int` — readable `Duration` construction, relative `DateTime` helpers, clamping.
- `ListX on Iterable<T>?` — null-safe iteration, `groupBy`, `sumBy`, `averageBy`, `firstWhereOrNull`.
- `ListSplit` / `ListSwapExtension on List<T>` — `splitAt`, `chunked`, `partition`, `swap`.
- `ContextX on BuildContext` — `theme`, `colorScheme`, `screenSize`, device-class helpers, keyboard utilities.
- `DateTimeExt on DateTime` — `timeAgo`, `isToday`, `isFuture`, `startOfDay`, `endOfDay`, `isSameDay`; top-level `currentMillisecondsTimeStamp`, `leapYear`, `daysInMonth`.
- `WidgetX on Widget` — `center`, `expanded`, `withWidth`, `withHeight`, `withSize`, `visible`, `cornerRadiusWithClipRRect`, `onTap`.
- `BoolxExtensions on bool` — `isTrue`, `isFalse`, `toggle`.
- `Patterns` — static regex strings for email, URL, phone, file types, Pakistan mobile.
- `MaskType` enum — `auto`, `email`, `phone`.
- Global toast config: `defaultToastBackgroundColor`, `defaultToastTextColor`, `defaultToastGravityGlobal`, `defaultToastBorderRadiusGlobal`.
- Widgets: `HorizontalListWithoutHeight`, `ReadMoreWidgetx`, `RestartAppWidgetx`.
