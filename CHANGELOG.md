## 0.8.0

The package now depends on nothing but the Flutter SDK. `fluttertoast`, `connectivity_plus`, and `image_picker` have been removed, so apps no longer inherit their native code, permissions, or `Info.plist` requirements, and `flutter_auto_size_text` has been removed along with auto-sizing in `VxTextBuilder`.

### Breaking
- **Removed `StringExtension.toastString()`** and the toast globals `defaultToastBackgroundColor`, `defaultToastTextColor`, `defaultToastGravityGlobal`, and `defaultToastBorderRadiusGlobal`. Use `context.showSnackBar(SnackBar(content: Text(message)))` from `ContextX`, or call `fluttertoast` from your app directly.
- **`ConnectivityBannerWidgetx.statusStream` is now required.** The widget no longer reads `connectivity_plus` itself. Pass a `Stream<bool>` (`true` = online) from whichever source your app uses:
  ```dart
  ConnectivityBannerWidgetx(
    statusStream: Connectivity().onConnectivityChanged
        .map((results) => results.any((r) => r != ConnectivityResult.none)),
    child: child!,
  )
  ```
  A stream that only fires on change should be seeded with the current state, or an app launched offline shows no banner.
- **`VxTextBuilder.make()` now builds a plain `Text` instead of an `AutoSizeText`.** Text renders at exactly the size you set:
  - Sizes below 12 are no longer enlarged to a 12pt floor. A `.size(10)` that used to render at 12pt now renders at 10pt.
  - Text with `maxLines` is truncated per `overflow` instead of first shrinking to fit. Wrap in `FittedBox(fit: BoxFit.scaleDown)` where shrinking is really wanted.
  - The system text scale is now respected. `AutoSizeText` ignored it. Apps wrapped in `MediaQuery.withNoTextScaling` see no difference.
  - `.isIntrinsic`, `minFontSize()`, `maxFontSize()`, `stepGranularity()`, `wrapWords()`, and `overflowReplacement()` are deprecated no-ops, so existing chains still compile. Remove them; they will be deleted in a later release.
- **`TrimMode` values renamed to lowerCamelCase:** `TrimMode.Length` is now `TrimMode.length`, and `TrimMode.Line` is now `TrimMode.line`.
- **Removed `ImagePickerSheetWidgetx.pick()` and `ImagePickerSheetWidgetx.pickMultiple()`.** The sheet itself and `pickSource()` remain: show the sheet with `pickSource()`, then call `image_picker` (or any picker) from your app with the returned `ImagePickerSourceX`.
- **`Patterns` fields are now `static const String`**, and `alphaRegExp` is `final`. Code that reassigned them no longer compiles; pass your own pattern to `hasMatch` instead.
- **`TrimMode` moved to `utils/enums.dart`.** It is still exported from the barrel, so only code importing `src/widgets/read_more_widgetx.dart` directly needs to change.
- **`isMaskingEnabledGlobal` moved to `utils/default_configs.dart`.** Same name, same barrel export.
- **`String.repeat()` now throws `ArgumentError` for a negative count.** It used to return `''`.
- **Stricter `Patterns`:** `email` is anchored, rejects `a,b@x.com` and trailing junk, and accepts hyphenated domains. `emailEnhanced` is anchored and accepts upper case. The file-type patterns need a real `.ext`, so `'notajpg'.isImage` is now false.
- **Case converters split words consistently:** `'userID'.toSnakeCase()` is `user_id`, `'HELLO_WORLD'.toCamelCase()` is `helloWorld`, and `'helloWorld'.toPascalCase()` is `HelloWorld` (was `Helloworld`).
- **`ColorX.toHex()` returns upper case** (`#2196F3`), as its doc always said.
- **`MapX.getOrDefault` returns a stored `null`** instead of the default; the default is only for a missing key.
- **Removed the `DurationX` `*` operator.** It was unreachable — `Duration`'s own `operator *(num)` always won — so `duration * 2.5` behaves exactly as before.
- **`AsyncBuilderWidgetx` no longer refetches when `future` is a new closure.** Every rebuild passed a new closure, so every rebuild refetched. Use `reloadOn` or `retry()`.
- **`SwiperWidgetx.pageController` is now a getter** backed by a controller the carousel owns and disposes. It throws `StateError` while that widget instance is not mounted.
- **`VxTextBuilder.make()` no longer forces `softWrap: true` / `overflow: clip`**, so an ambient `DefaultTextStyle` (AppBar titles, ListTile) applies. Size presets (`xs`…`xl6`, `scale()`) scale the themed or style font size instead of a fixed 14; with no size set, output is unchanged.
- **`ScrollxExtensions` on a controller attached to several views:** the jump/animate members move every view, and the getters report on the most recently attached one.
- **`IterableAsyncX.mapParallel` throws `ArgumentError` for `concurrency <= 0`** in release builds too.
- **`StepperIndicatorWidgetx` labels** are single-line, use the room between steps, and measure it with a `LayoutBuilder` — a labelled stepper can no longer sit inside `IntrinsicHeight`/`IntrinsicWidth`.

### Added
- **`GroupedDigitsInputFormatterX`** (`utils/grouped_digits_formatterx.dart`): a `TextInputFormatter` that keeps only digits and groups them as you type.
  - Presets: `.cnic()` for `00000-0000000-0` and `.pkMobile()` for `0300-1234567`. Any other grouping works through `groupLengths` and `separator`.
  - Pasted text is reformatted, and input past the last group is dropped.
  - The caret stays beside the digit it was next to when editing mid-number.
  - Backspacing over a separator deletes the digit before it.
  - `format()` formats a string outside a text field.
  - Replaces `mask_text_input_formatter` for digit masks.
- **`FieldTypeX.cnic`** on `TextFieldWidgetx`: the CNIC mask, the numeric keyboard, a badge icon, and validation against `Patterns.cnic`. The message comes from the new `defaultFieldInvalidCnicMessageGlobal`. Adding an enum value breaks exhaustive `switch`es over `FieldTypeX` in your own code.
- **`StringExtension.formatCnic`**: formats 13 digits as `00000-0000000-0` and returns anything else unchanged. **`StringExtension.isCnic`**: accepts a CNIC with dashes or as 13 bare digits.
- **`StringExtension.ifBlank(fallback)`** returns `fallback` when the string is null, empty, or only whitespace, and the string unchanged otherwise. It replaces the inline `value.trim().isEmpty ? fallback : value`.
- **`DateTimeExt.format(pattern)`** formats with `intl`-style tokens without depending on `intl`. Example: `date.format('d MMM, h:mm a')` → `'5 Mar, 2:05 PM'`.
  - Tokens: `yyyy`/`yy`/`y`, `MMMM`/`MMM`/`MM`/`M`, `dd`/`d`, `EEEE`/`EEE`, `HH`/`H`, `hh`/`h`, `mm`/`m`, `ss`/`s`, `SSS`, `a`.
  - Text in single quotes is copied literally, and `''` is a quote.
  - Output is English only. Keep `intl` for localised dates.
- **`DurationX.toClock()`** formats a duration as a clock reading: `'04:59'`, or `'1:04:59'` from one hour up. `CountdownTimerWidgetx` now uses it in place of its private formatter, with unchanged output.
- **`Patterns.cnicDigits`**: a CNIC without dashes.
- **`WidgetX.toPngBytes()`**: renders a widget off-screen to PNG bytes, sized to the widget, for custom map markers, share images, and thumbnails.
  - Ported from the identical `createImageFromWidget` helpers in two apps, with three fixes: the off-screen tree, image, and focus manager are now disposed after each capture; `textDirection` is honoured; and `view` can be injected for tests.
- **`DateTimeExt.shiftDaysX(days)`** moves a date by calendar days, keeping the wall-clock time across a daylight-saving change. `addDays`, `subtractDays`, `daysAgo`, and `daysFromNow` now use it.
- **`PaginatedListWidgetx.reloadOn`**: restarts from page 1 when it changes, for search and filters. A changed fetcher is used by the next page or refresh without refetching on rebuild.
- **`VxTextBuilder.fromText(Text)`**, behind `Text.text`: carries the source's style, `maxLines`, `textAlign`, `overflow`, `softWrap`, `strutStyle`, key, and `Text.rich` spans.
- **`StringExtension.hasMatch(pattern, caseSensitive:)`** and **`Patterns.alpha`**.

### Changed
- `ConnectivityBannerWidgetx.verifyConnection` now applies to every status from `statusStream`. Previously an injected stream bypassed it.

### Fixed
- **Strings:** `isInt`, `hasMatch` and the validators, `splitAfter`, `prefixText`, and `suffixText` no longer throw or print `null` on a null receiver. `toIntX` parses negatives and returns the default on overflow or hex. `maskEmail` no longer throws on `'@x.com'`. `ellipsize` no longer throws when `maxLength` is shorter than the ellipsis. `splitBetween` stops at the first end match. `formatNumberWithComma` leaves decimals alone. `countWords` is 0 for empty text. `reverse` keeps whitespace and emoji. `removeAllWhiteSpace` removes trailing spaces. File-type checks ignore case.
- **`Patterns`:** `url` accepts `localhost` and IPv4 hosts; `creditCard` accepts 2-series Mastercard.
- **Dates and numbers:** `timeAgo` reads `'in 3 days'` for the future (was `'Just now'`). `startOfWeek`, `endOfWeek`, `isYesterday`, and `isTomorrow` use calendar days, so a DST change can't shift them. `DateTime.format` pads `SSSS`+ correctly. `ordinal` handles negatives. `Duration.format()` signs negative durations.
- **`toPngBytes`** builds at the capture pixel ratio, so `Image.asset` picks the 2x/3x variant instead of a blurry 1x.
- **`GroupedDigitsInputFormatterX`:** forward-delete over a separator deletes the digit after it; typing into a full field is rejected instead of pushing out the last digit.
- **`ConnectivityBannerWidgetx`:** a `verifyConnection` still running when `statusStream` is swapped is discarded.
- **`ScrollxExtensions`:** `animateToTop` / `animateToBottom` are no-ops on an unattached controller.
- **`ContextX.pickDate`:** the default `initialDate` is clamped into `firstDate`…`lastDate`, so date-of-birth pickers no longer assert.
- **`VxTextBuilder`:** `Text.text.when(false)` no longer throws; zero-blur shadows render.
- **`ListSplit.chunked(size <= 0)`** returns a copy (or `[]`), not the receiver.
- **`AsyncBuilderWidgetx`:** a failed pull-to-refresh with no prior data no longer throws; `keepPreviousData: false` shows loading after a `reloadOn` change; `retry()` calls `onRefresh` only after success.
- **`PaginatedListWidgetx`:** dropping a caller `controller` falls back to the fetcher.
- **`TextFieldWidgetx`:** adding or removing `controller`, `focusNode`, or `form` between builds no longer crashes.
- **`SearchBarWidgetx`:** no `setState` after dispose with a caller controller; swapped controllers are followed; cursor moves don't fire `onChanged`/`onSearch`; Clear fires `onSearch('')` once; the clear button shows for pre-filled text.
- **`PinInputWidgetx`:** paste and SMS autofill fill every box; backspace on an empty box reports `onChanged`; `length` can change at runtime.
- **`QuantityStepperWidgetx`:** holding minus stops at `min` and never removes the item; the display resyncs when the parent rejects a change.
- **`FormX`:** `fill()` with surrounding whitespace no longer marks the form dirty.
- **`ReadMoreWidgetx`:** `TrimMode.line` renders (it showed nothing); length mode no longer splits an emoji; the tap recognizer and text painter are disposed.
- **`SegmentedControlWidgetx(expand: false)`** and **`TimelineWidgetx(dashPendingConnector: true)`** no longer throw.
- **`SwiperWidgetx`:** accepts integer `viewportFraction`/`initialPage`, renders nothing for zero items, and no longer leaks a `PageController` per rebuild.
- **`CircularProgressWidgetx`:** NaN or infinite values show 0%.
- **`AvatarWidgetx`:** initials from emoji names no longer throw.
- **`CountdownTimerWidgetx`:** `onFinished` fires on the tick that reaches zero, and a changed `duration` restarts the countdown.
- **`RatingWidgetx`:** follows changes to `initialRating` and `starCount`.
- **`StepperIndicatorWidgetx`:** labels are no longer ellipsised to the circle's width; `totalSteps <= 0` renders nothing.
- **`ChipsFilterWidgetx`:** single mode honours only the first selected item.
- **`ScrollToTopWidgetx`:** shows the button when the list starts past `threshold`.
- `ListxWidgetExtensions.toListView()`, `ListxWidgetExtensions.toGrid()`, and `PaginatedListWidgetx` now pass their `cacheExtent` to Flutter's `scrollCacheExtent` as `ScrollCacheExtent.pixels(...)`. The old `cacheExtent` argument was deprecated in Flutter 3.41. Your `double? cacheExtent` parameter is unchanged and behaves the same.
- The `VxTextBuilder` size presets (`xs` … `xl5`) now compound with the system text scale instead of replacing it. They previously set a fixed `TextScaler`. At the default text scale, output is unchanged.
- `VxTextBuilder` text no longer throws under dry layout. `AutoSizeText`'s render object did not implement `computeDryLayout`.
- A `verifyConnection` call that finishes after a newer status arrived is now discarded, so a slow check can no longer flip the banner back to online after the device went offline.

## 0.7.1

### Changed
- Upgraded `fluttertoast` from `^9.0.0` to `^10.0.0`. The toast API used by `StringExtension.toastString()` and the toast globals in `default_configs.dart` is unchanged; the upstream release moves its Android build to Kotlin compiler options built into the Flutter toolchain.
- Raised the minimum SDKs to Dart `^3.12.0` and Flutter `>=3.44.0` (were `^3.11.3` and `>=1.17.0`). `fluttertoast` 10 requires these versions, so the old floors could no longer be resolved. Apps on older toolchains should stay on `0.7.0`.

### Tooling
- `analysis_options.yaml` now excludes `build/**` from analysis.

## 0.7.0

### Added — Widgets

#### `ButtonWidgetx` (`widgets/button_widgetx.dart`)
- A button that understands async work: when `onPressed` returns a `Future` the button disables itself, swaps its label for a spinner, and restores itself once the future settles — no `bool _isLoading` + `setState` boilerplate, and a second tap cannot fire while the first is still running.
- Five variants via `ButtonVariantX` — `filled`, `tonal`, `outlined`, `text`, `danger` — each with a named constructor (`ButtonWidgetx.danger(...)`).
- Three sizes via `ButtonSizeX` (`small`, `medium`, `large`), driving height, font size, icon size, and padding.
- `isLoading` accepts an external flag, so the loading state can live in Bloc/Provider/Riverpod instead.
- `onError` receives a failure from the returned future; when it is null the error is rethrown after the loading state has cleared, so it still reaches your error handler.
- `icon`, `trailingIcon`, `child`, `expand`, `isEnabled`, `loadingIndicator`, `margin`, `elevation`, plus full colour/shape overrides.
- A future landing after the button is disposed does not throw.
- Wrapped in `Semantics` with `button`, `enabled`, and a label.

#### `TextFieldWidgetx<K>` (`widgets/text_field_widgetx.dart`)
- The form field that pairs with `FormX` — pass `form:` and `fieldKey:` and the controller, focus node, and next-field focus traversal (`nextField:`) are wired for you. Works standalone with `controller:` / `focusNode:` too.
- `FieldTypeX` presets (`text`, `email`, `password`, `phone`, `number`, `multiline`, `search`, `url`) select the keyboard type, autofill hints, prefix icon, input formatters, and the validation pattern from `Patterns` in one parameter.
- `FieldTypeX.password` obscures the value and renders a visibility toggle.
- Built-in validation: `isRequired` (appends `*` to the label), `minLength`, `validationPattern` + `validationMessage`, and a `validator` callback for anything else. An optional field left blank skips the pattern check.
- Only the controller and focus node the widget itself created are disposed — a `FormX` or a caller-supplied controller outlives the field.
- Full decoration control: `prefix`/`suffix`, `fillColor`, `borderColor`, `focusedBorderColor`, `borderRadius`, `contentPadding`, `helperText`, external `errorText`, counter visibility, and more.

#### `AsyncBuilderWidgetx<T>` (`widgets/async_builder_widgetx.dart`)
- `FutureBuilder` with the loading, empty, and error states already wired — what `PaginatedListWidgetx` does for paginated lists, for every single-shot fetch.
- Takes a *factory* (`future: () => api.get()`), so a rebuild never refires the request and `retry()` can re-run it. `reloadOn:` refetches when an id, filter, or query changes.
- Default empty detection covers `null`, empty `Iterable`, empty `Map`, and blank `String`; override with `isEmpty`.
- Defaults reuse the package's own states — a centered spinner, and `EmptyStateWidgetx` for both empty and error (with a working retry action). Every state is overridable via `loadingBuilder`, `emptyBuilder`, `errorBuilder`.
- `AsyncBuilderWidgetx.stream(...)` watches a `Stream` instead; no retry action is offered since a stream cannot be re-run.
- `keepPreviousData` holds the last result on screen through a retry or reload, `enableRefresh` adds pull-to-refresh, `onError` / `onData` fire once per distinct event after the frame, and `errorMessageBuilder` has a distinct default for `TimeoutException`.
- State is exposed as `AsyncBuilderWidgetxState<T>` so a `GlobalKey` can call `retry()`.

#### `QuantityStepperWidgetx` (`widgets/quantity_stepper_widgetx.dart`)
- The `− n +` cart control: `min`, `max`, `step`, and clamping handled, with `onChanged` reporting only in-range values.
- `onRemove` turns the minus button into a delete icon at `min` — the usual "decrement to remove" cart behaviour. Without it the minus button is simply disabled at `min`.
- Holding a button repeats it (`enableLongPressRepeat`), tracked internally so it keeps counting without waiting for the parent to rebuild. Repeat is deliberately not wired to the destructive remove action.
- `allowManualInput` lets the user type a quantity, committed on submit or on focus loss.
- `isLoading` swaps the number for a spinner during an in-flight cart update.

#### `BadgeWidgetx` (`widgets/badge_widgetx.dart`)
- Count or dot badge anchored to any child. Hides at zero (unless `showZero`), caps at `maxCount` rendering `99+`.
- `BadgeWidgetx.dot(...)` for a plain status dot; `label` for text badges like `NEW`.
- Animates in, out, and on value change via `AnimatedSwitcher` + `ScaleTransition`.
- `alignment`, `offset`, `borderColor`/`borderWidth` ring, and full colour control.

#### `AlertBannerWidgetx` (`widgets/alert_banner_widgetx.dart`)
- Inline success / error / warning / info banner for the cases a snackbar is wrong: a validation summary, an account-status notice, a warning that must stay until resolved.
- Named constructors `.success`, `.error`, `.warning`, `.info`, each selecting its colour and icon from the new global config.
- Optional `title`, close button (`onClose`), and an inline action (`actionText` + `onAction`).
- Two styles: tinted with a left accent bar (default) or `isFilled` solid.
- Marked as a `liveRegion` for screen readers.

#### `TimelineWidgetx` (`widgets/timeline_widgetx.dart`)
- Vertical timeline for order tracking, activity feeds, and audit trails, built from `TimelineItemX` entries.
- `TimelineItemStateX` (`completed`, `active`, `pending`) drives node and connector styling — completed nodes show a check, the active node is ringed and shadowed, pending steps are muted.
- Optional leading timestamp column (`timestampWidth`), dashed pending connectors, per-entry `content` widget, per-entry `onTap`, and a full `itemBuilder` override.

#### `ChipsFilterWidgetx<T>` (`widgets/chips_filter_widgetx.dart`)
- Filter chip group in `ChipsSelectionModeX.single` or `.multiple`, wrapping onto several lines or scrolling horizontally on one (`isScrollable`).
- Emits a new list rather than mutating the one it was given, so immutable state stays safe.
- `allowEmpty` decides whether re-tapping the selected chip clears it in single mode.
- `labelBuilder`, `iconBuilder`, `countBuilder` for `Pizza (12)`-style counts, and full colour/shape control.

#### `SegmentedControlWidgetx<T>` (`widgets/segmented_control_widgetx.dart`)
- Two- or three-way toggle with an animated sliding indicator — cleaner than a `TabBar` for a small fixed set of choices.
- `labelBuilder` and `iconBuilder`; `showLabels: false` gives an icon-only control.
- Tapping the already-selected segment does not fire `onChanged`; a value not present in `items` simply highlights nothing instead of throwing.
- `expand` fills the width with equal segments, or sizes to content.

#### `NetworkImageWidgetx` (`widgets/network_image_widgetx.dart`)
- `Image.network` with the four things it leaves to you: a shimmering `SkeletonLoaderWidgetx` placeholder, an error fallback, rounded corners, and a fade-in.
- A null or blank `url` goes straight to the error state, so a missing avatar needs no null check at the call site.
- `NetworkImageWidgetx.circle(size: ...)` for avatars; `errorWidget` for initials fallbacks.
- `showProgress` renders a determinate spinner, staying indeterminate when the server omits `Content-Length`.
- `heroTag`, `onTap`, `border`, `headers` (auth tokens), `cacheWidth`, and `semanticLabel`.

#### `ScrollToTopWidgetx` (`widgets/scroll_to_top_widgetx.dart`)
- Floats a "back to top" button over any scrollable once the user passes `threshold`, animating in with scale + opacity.
- Rebuilds only when the button actually crosses the threshold, not on every scroll notification.
- Optional `label` turns it into an extended FAB; `button` replaces it entirely while keeping the show/hide behaviour.
- Uses the existing `ScrollxExtensions.animateToTop`. The controller belongs to the caller — only the listener is removed on dispose.

#### `AnimatedCounterWidgetx` (`widgets/animated_counter_widgetx.dart`)
- A number that animates from its previous value to its new one — stat tiles, cart totals, live scores.
- `decimals`, `prefix`, `suffix`, and `useThousandsSeparator` (sign- and fraction-aware), or a `formatter` callback to plug in `intl`.
- `initialValue` controls whether the first build counts up from zero or renders the final number immediately.
- `format()` is public, so the formatting is unit-testable without pumping a widget.

#### `CircularProgressWidgetx` (`widgets/circular_progress_widgetx.dart`)
- Circular progress ring with a percentage label — dashboards, upload progress, goal rings, quiz scores.
- Animates between values, supports a `SweepGradient` arc (`gradientColors`), rounded caps, and a configurable `startAngle` measured from twelve o'clock.
- `center` replaces the label with any widget; `caption` adds a line under the percentage.
- A null `value` falls back to an indeterminate spinner rather than animating a fabricated value.

#### `ConnectivityBannerWidgetx` (`widgets/connectivity_banner_widgetx.dart`)
- Slides an offline banner over the app when connectivity drops, and a brief "Back online" confirmation when it returns. Wrap it once in `MaterialApp.builder`.
- Reads the current state on mount as well as listening for changes, so an app launched offline still shows the banner.
- `verifyConnection` adds a reachability check on top of `connectivity_plus`, which only reports whether a network *interface* is up — a captive-portal wifi still counts as connected.
- `statusStream` overrides the source entirely, for tests and for apps that already track connection state.
- The banner leaves the widget tree once it has slid away, so a hidden banner is not left rendering text where screen readers would still reach it.
- `showAtBottom`, `bannerBuilder`, `onStatusChanged`, safe-area handling, and full colour/duration control.

#### `ImagePickerSheetWidgetx` (`widgets/image_picker_sheet_widgetx.dart`)
- The "Take a photo / Choose from gallery / Remove" sheet with the picking already wired to `image_picker`, built on the new `SheetX.showActionSheet`.
- `ImagePickerSheetWidgetx.pick(context, ...)` shows the sheet, runs the picker, and returns an `XFile?`, forwarding `maxWidth`, `maxHeight`, `imageQuality`, and `preferredCameraDevice`.
- `pickSource(context, ...)` stops after the choice, for callers that crop in between or use a custom camera.
- `pickMultiple(context, ...)` returns every gallery selection, with `limit` support.
- A denied permission or a plugin failure surfaces as `null` (or through `onError`) rather than crashing the calling screen. `picker:` accepts an injected `ImagePicker` for tests.

### Added — Extensions

#### `SheetX` — on `BuildContext` (`sheetx_extensions.dart`)
- The bottom-sheet counterpart to `DialogX`, since sheets are more common than dialogs on mobile.
- `showSheet<T>(...)` — rounded modal sheet with a drag handle, safe-area padding, keyboard avoidance, a `maxHeightFactor` cap, and content that scrolls when tall. Returns the value the sheet was popped with.
- `showScrollableSheet<T>(...)` — a `DraggableScrollableSheet` the user can drag between `minSize` and `maxSize`, handing a `ScrollController` to the builder.
- `showActionSheet<T>(...)` — a list of `SheetActionX<T>` rows returning the value of the one that was tapped; supports subtitles, leading widgets, destructive rows, disabled rows, and a cancel row. Rows pop before firing `onTap`, so the callback can safely push a route or open another sheet.
- New `SheetActionX<T>` model class.


#### `ListX` — on `Iterable<T>?` (`listx_extensions.dart`)
- Emptiness, mirroring `StringExtension` — `isEmptyOrNull`, `isNotEmptyOrNull`, `lengthOrZero`.
- `firstOrNull` / `lastOrNull` on a **nullable** receiver, so no `?.` is needed. The SDK's own `Iterable.firstOrNull` still wins on a non-null receiver, so nothing is shadowed.
- Keying — `associateBy` (index by id), `associateWith` (derive key and value), `groupCountBy` (counts without collecting the elements), `distinctBy` (dedupe model objects that lack value equality, which plain `distinct()` cannot).
- Lookups that never throw — `lastWhereOrNull`, `singleWhereOrNull` (null for none *or* many), `indexWhereOrNull` (null instead of `-1`, so it composes with `??`).
- Sorting, all returning copies — `sortedByDescending`, `sortedWith(comparator)`, `sortedByMany([...])` for tie-breaking on successive keys, and `isSortedBy`.
- Mapping — `mapNotNull` (map and drop nulls in one pass), `whereNotNullBy` (keep elements whose field is set), `joinToString`.
- Set maths, order-preserving — `containsAny`, `containsAll`, `except`, `intersect`.
- `pageAt(page, size:)` for client-side paging, 1-based to match `PaginatorX.firstPage`; an out-of-range page yields an empty list rather than throwing.
- `shuffled([Random])` (a copy, unlike `List.shuffle`) and `randomOrNull([Random])`, both accepting a seed for reproducible tests.

#### `IterableNullableX` — on `Iterable<T?>?` (`listx_extensions.dart`)
- `whereNotNull()` and `firstNotNull`.

#### `IterableAsyncX` — on `Iterable<T>?` (`listx_extensions.dart`)
- `mapAsync` and `forEachAsync` — strictly sequential, for writes that must not overlap or a rate-limited API.
- `mapParallel(transform, {concurrency})` — concurrent with results in the original order, and an optional cap implemented as a worker pool. Firing an unbounded `Future.wait` at a server is a common cause of timeouts, so the cap is the recommended path for network work.
- `firstWhereAsync` — short-circuits, so elements after the first match are never tested.

#### `ListAccessX` — on `List<T>` (`listx_extensions.dart`)
- `getOrNull`, `getOrElse`, and `safeSublist` — indexing that clamps instead of throwing.

#### `ListMutationX` — on `List<T>` (`listx_extensions.dart`)
- `toggle` (add if absent, remove if present — the whole of a multi-select filter's logic), `moveItem` (what `ReorderableListView.onReorder` hands you), `addIf`, `addAllIf`, `removeWhereCounted`.

#### `ListTransformX` — on `List<T>` (`listx_extensions.dart`)
- Copy-on-write edits for immutable state — `replaceWhere`, `upsert(item, by:)` (update the match or append), `rotate` (wrapping in both directions), `diff` (returns `(added:, removed:)`), and `intersperse`.
- `intersperse` is deliberately not named `separatedBy`: on a homogeneous widget list such as `List<Text>` both this extension and `ListxWidgetExtensions` apply, and the generic one would win and demand a `Text` separator.

#### `ListxWidgetExtensions` — on `List<Widget>` (`listx_widgets_extensions.dart`)
- New layout builders — `toWrap`, `toGrid`, `toPageView`, `toIndexedStack`, `toSliverList`, `toSliverGrid`, `toScrollableRow`, `toScrollableColumn`.
- New list-to-list helpers that chain into any builder — `separatedBy(Widget)`, `withSpacing(gap, {axis})`, `withDividers(...)`, `expanded({flex})`, `flexible({flex, fit})`, `paddedAll`, `paddedSymmetric`.
- Every builder now returns its concrete type (`Row`, `Column`, `Stack`, `ListView`, `Wrap`, …) instead of a widened `Widget`, per the package's own "return the most specific type" rule. Returning a subtype is source-compatible, so existing call sites are unaffected.
- Doc comments added to the previously undocumented members, and the unused `<E>` type parameter on the extension removed.

### Added — Utils

- New enums in `utils/enums.dart`: `ButtonVariantX`, `ButtonSizeX`, `FieldTypeX`, `AlertTypeX`, `TimelineItemStateX`, `ChipsSelectionModeX`, `ImagePickerSourceX`.
- New globals in `utils/default_configs.dart`:
  - Button — `defaultButtonBorderRadiusGlobal`, `defaultButtonHeightSmallGlobal`, `defaultButtonHeightMediumGlobal`, `defaultButtonHeightLargeGlobal`.
  - Text field — `defaultFieldBorderRadiusGlobal`, `defaultFieldRequiredMessageGlobal`, `defaultFieldInvalidEmailMessageGlobal`, `defaultFieldInvalidPhoneMessageGlobal`.
  - Sheet — `defaultSheetBorderRadiusGlobal`, `defaultSheetCancelTextGlobal`.
  - Alert — `defaultAlertSuccessColorGlobal`, `defaultAlertErrorColorGlobal`, `defaultAlertWarningColorGlobal`, `defaultAlertInfoColorGlobal`.
  - Async — `defaultAsyncErrorTitleGlobal`, `defaultAsyncErrorMessageGlobal`, `defaultAsyncRetryTextGlobal`, `defaultAsyncEmptyTitleGlobal`.
  - Connectivity — `defaultOfflineMessageGlobal`, `defaultOnlineMessageGlobal`.
  - Image picker — `defaultImagePickerTitleGlobal`, `defaultImagePickerCameraTextGlobal`, `defaultImagePickerGalleryTextGlobal`, `defaultImagePickerRemoveTextGlobal`.

### Dependencies

- **Added `connectivity_plus: ^7.3.1`** — required by `ConnectivityBannerWidgetx`.
- **Added `image_picker: ^1.2.3`** — required by `ImagePickerSheetWidgetx`.
- Both are plugin dependencies inherited by every consumer of this package. Apps using `ImagePickerSheetWidgetx` must add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `Info.plist` on iOS.

### Fixed

- **`ListxWidgetExtensions.toList()` was unreachable.** `Iterable.toList` is an instance method and instance members always beat extensions, so `widgets.toList()` has always returned a plain `List<Widget>` copy rather than a `ListView` — the extension member could never be called. It has been removed, and `toListView()` now covers both modes: children by default, `ListView.builder` when an `itemBuilder` is passed. Existing `toListView(itemBuilder: ...)` calls are unchanged, and code calling `.toList()` keeps the `Iterable.toList` behaviour it was already getting.
- `ChipsFilterWidgetx` now uses the new `ListMutationX.toggle` instead of its own inline add/remove branch, so the selection logic lives in one place.

### Testing

- 157 new tests covering all 16 widget additions and the list-extension additions, including the async-button re-entrancy guard, a future landing after the button unmounts, `FormX` wiring and focus traversal, controller-ownership on dispose, the async builder not refiring on rebuild, `reloadOn` refetching, retry-after-failure recovery, sheet return values and dismissal, stepper clamping and the remove threshold, chip lists not being mutated in place, badge capping, and the connectivity banner's transitions.

---

## 0.6.0

### Added — Utils

#### `PaginatorX<T>` — Pagination controller (`utils/paginatorx.dart`)
- State-management-agnostic `ChangeNotifier` that owns the accumulated items, the page/cursor bookkeeping, and the loading/error state. Works with `ListenableBuilder`, Provider, Bloc, or plain `setState`, and with any layout — not just `PaginatedListWidgetx`.
- Two constructors: `PaginatorX(fetchPage: (page, cursor) => Future<PageX<T>>)` for APIs that report `hasMore` or paginate by cursor, and `PaginatorX.simple(fetch: (page) => Future<List<T>>)` where `hasMore` is inferred from `pageSize`.
- Loading API — `loadFirstPage({force})`, `loadNextPage()`, `refresh()`, `retry()`, `pause()`, `resume({loadMore})`, `reset({notify})`, `updateFetcher(fetcher, {reload})`.
- State API — `items` (a live `UnmodifiableListView`), `itemCount`, `status`, `isLoading`, `isLoadingFirstPage`, `isLoadingMore`, `isRefreshing`, `hasError`, `error`, `stackTrace`, `isEmpty`, `hasMore`, `canLoadMore`, `nextPage`, `cursor`, `totalCount`, `isPaused`.
- Local mutations, so an optimistic create/edit/delete needs no refetch — `addItem`, `addItems`, `insertItem`, `removeAt`, `removeWhere`, `replaceAt`, `updateWhere`, `setItems`, `clearItems`.
- `itemId` — optional stable identity that drops duplicate rows arriving across pages, common when data shifts on the server between requests.
- `timeout` — optional per-request timeout; a timed-out page fails through the normal retry path.
- Race guards: re-entrant page loads are dropped, a `refresh()` pre-empts an in-flight load and the superseded response is discarded rather than appended, responses landing after `dispose()` never notify, and a server that claims `hasMore` while returning an empty (or entirely duplicate) page ends the list instead of looping forever.

#### `PageX<T>` (`utils/paginatorx.dart`)
- Page result carrying `items`, optional `hasMore`, `nextCursor`, and `totalCount`, plus a `PageX.empty()` factory.

### Added — Widgets

#### `PaginatedListWidgetx<T>` (`widgets/paginated_list_widgetx.dart`)
- Plug-and-play infinite-scrolling list or grid: pass `fetchItems` (or `fetchPage`, or an existing `controller`) plus `itemBuilder` and every state is already wired.
- Dual prefetch trigger — the next page is requested when the scroll position comes within `prefetchThreshold` pixels of the end, **or** when one of the last `prefetchItemCount` items is built. The second trigger keeps a first page too short to fill the viewport from stranding the list, capped by `maxAutoFillPages`.
- Built-in states, each overridable: `loadingBuilder` (defaults to `SkeletonListWidgetx`), `emptyBuilder` and `errorBuilder` (default to `EmptyStateWidgetx`), `loadMoreBuilder` (spinner footer), `loadMoreErrorBuilder` (inline retry footer), and `endBuilder` for the end of the list.
- Error handling — an inline retry is always available; `errorMode` decides whether a Retry / Cancel dialog appears on top of it. `PaginationErrorMode.inline` (default), `.dialog`, or `.dialogOnFirstPage`. The dialog reuses `DialogX.showConfirmDialog`; Cancel pauses auto-loading so scrolling does not re-fire the failed request, and it will not reappear for the same failure.
- Pull-to-refresh via `enableRefresh` (on by default), working on the empty and error states too, with an optional `onRefresh` hook.
- `gridDelegate` renders a paginated grid; `separator` / `separatorBuilder` set the gap between rows; `header` and `footer` pin content inside the scroll view.
- `parentScrollController` — observe an outer scroll view so prefetching still works when the list is nested with `shrinkWrap: true`.
- `onError` for crash reporting, `errorMessageBuilder` for user-facing copy (with a distinct default message for `TimeoutException`), and `onErrorCancelled`.
- Forwards `physics`, `shrinkWrap`, `scrollDirection`, `reverse`, `primary`, `cacheExtent`, `keyboardDismissBehavior`, `clipBehavior`, `restorationId`, `padding`, and `scrollController` to the underlying scroll view.
- Does not throw when a page lands after the screen is unmounted, and never raises a dialog over a route the user has already left.

#### `SkeletonListWidgetx` (`widgets/skeleton_list_widgetx.dart`)
- Shimmering list placeholder built from `SkeletonLoaderWidgetx` — `rows`, `rowHeight`, `spacing`, `padding`, `showAvatar`, `avatarSize`, `borderRadius`, `baseColor`, `highlightColor`, `physics`, `shrinkWrap`, and `rowBuilder` for a fully custom row.

### Added — Utils

- `PaginationStatus` and `PaginationErrorMode` enums added to `utils/enums.dart`.
- Global pagination config added to `utils/default_configs.dart` — `defaultPaginationPageSizeGlobal`, `defaultPaginationPrefetchThresholdGlobal`, `defaultPaginationErrorTitleGlobal`, `defaultPaginationErrorMessageGlobal`, `defaultPaginationTimeoutMessageGlobal`, `defaultPaginationRetryTextGlobal`, `defaultPaginationCancelTextGlobal`, `defaultPaginationEmptyTitleGlobal`.

### Testing
- 40 new tests covering `PaginatorX` and `PaginatedListWidgetx`, including the race conditions: concurrent page requests, a refresh pre-empting an in-flight load, a response landing after `dispose()`, a page landing after unmount, a server lying about `hasMore`, cross-page duplicates, timeouts, retry-after-failed-refresh, and the dialog's Retry and Cancel paths.

### Documentation
- Documented `PaginatedListWidgetx`, `SkeletonListWidgetx`, `PaginatorX`, `PageX`, and the global pagination config in `README.md`.

---

## 0.5.3

### Added — Widgets

#### `LoadingOverlayWidgetx` (`widgets/loading_overlay_widgetx.dart`)
- Blocking overlay that sits on top of any child widget via a `Stack`.
- When `isLoading` is `true`, the child absorbs no pointer events (`AbsorbPointer`) and the overlay fades in (`AnimatedOpacity`). When `false`, the overlay fades out and the child becomes interactive again.
- `mode: LoadingOverlayMode.fullScreen` (default) — translucent `barrierColor` layer fills the widget area with a centred spinner.
- `mode: LoadingOverlayMode.centered` — only the spinner is shown; no background tint.
- `indicator` — accepts any widget as a custom loading spinner; defaults to `CircularProgressIndicator`.
- `barrierColor` — configurable barrier colour; defaults to `Colors.black54`.
- `animationDuration` — configurable fade duration; defaults to `200ms`.
- `LoadingOverlayMode` enum added to `utils/enums.dart`.

### Documentation
- Updated `README.md` to document `LoadingOverlayWidgetx` and `LoadingOverlayMode`.
- Rewrote `CLAUDE.md` to reflect the complete current folder layout (all extension files, `widgets/` subfolder), add widget naming rules, a Known Issues table, and corrections to the global-state and regex rules.

---

## 0.5.2

### Added — Utils

#### `FormX<K>` — Generic form controller (`utils/formx.dart`)
- Manages `TextEditingController` instances for any set of keys — enums, strings, or any Dart type.
- `[]` operator — retrieve a controller by key; assert fires in debug mode if key is missing.
- `.values` — `Map<K, String>` of trimmed text values for every field.
- `.value(key)` — trimmed value for a single field.
- `.fill(Map<K, String>)` — pre-populate fields from existing data (edit-screen support).
- `.reset()` — clear all fields at once.
- `.dispose()` — dispose all controllers in one call; use in `State.dispose()`.

---

## 0.5.1

### Fixed
- Added `VxStringTextExtensions on String` so that `'hello'.text.make()` now works directly on string literals. Previously `.text` was only available on `Text` widgets.

---

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
