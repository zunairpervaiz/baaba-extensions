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
