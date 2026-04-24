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
