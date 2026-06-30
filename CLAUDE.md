# baaba_extensions

Flutter/Dart extension package. Dart SDK `^3.11.3`, Flutter `>=1.17.0`.

## Dependencies
- `fluttertoast: ^9.0.0` — used only in `StringExtension.toastString()`
- `flutter_auto_size_text: ^5.0.0` — used only in `VxTextBuilder`
- Linting: `flutter_lints ^6.0.0` (inherits `flutter.yaml` rules)

## Folder Layout

```
lib/
  baaba_extensions.dart            # barrel export — ALL public symbols must be exported here
  src/
    boolx_extensions.dart          # bool → BoolxExtensions
    colorx_extensions.dart         # Color → ColorX
    contextx_extensions.dart       # BuildContext → ContextX
    date_timex_extensions.dart     # DateTime → DateTimeExt + top-level helpers
    dialogx_extensions.dart        # BuildContext → DialogX
    durationx_extensions.dart      # Duration → DurationX
    listx_extensions.dart          # Iterable<T>? → ListX; List<T> → ListSplit, ListSwapExtension, IterableIterableX
    listx_widgets_extensions.dart  # List<Widget> → ListxWidgetExtensions
    mapx_extensions.dart           # Map<K,V> → MapX
    numx_extensions.dart           # num → NumX/NumPaddingX; int → NumDurationX/NumTimeX/NumCoerceInExtension
    scrollx_extensions.dart        # ScrollController → ScrollxExtensions
    stringx_extensions.dart        # String? → StringExtension
    widgetx_extensions.dart        # Widget → WidgetX
    utils/
      default_configs.dart         # mutable global config vars (toast + dialog colours/gravity)
      enums.dart                   # package-wide enums: MaskType, LoadingOverlayMode
      formx.dart                   # FormX<K> — generic multi-field form controller
      patterns.dart                # Patterns class — static regex strings only
      time_formatter.dart          # formatTime() helper for timeAgo
    widgets/
      avatar_widgetx.dart
      countdown_timer_widgetx.dart
      empty_state_widgetx.dart
      expandable_widgetx.dart
      gradient_button_widgetx.dart
      horizontal_list_without_height.dart
      loading_overlay_widgetx.dart
      pin_input_widgetx.dart
      rating_widgetx.dart
      read_more_widgetx.dart        # also defines TrimMode enum (see Known Issues)
      restart_app_widgetx.dart
      search_bar_widgetx.dart
      skeleton_loader_widgetx.dart
      stepper_indicator_widgetx.dart
      swiper_widgetx.dart
      text_widgetx.dart             # VxTextBuilder + VxStringTextExtensions + VxTextExtensions
test/
  baaba_extensions_test.dart
```

## Hard Rules

### File & Extension Naming
- One extension file per Dart type. File name: `{type}x_extensions.dart` (snake_case).
- Extension name: `{TypeName}X` suffix — e.g. `ContextX`, `NumX`, `ListX`, `WidgetX`.
  - Legacy exceptions (keep as-is, do not rename):
    - `StringExtension` on `String?`
    - `DateTimeExt` on `DateTime`
    - `BoolxExtensions` on `bool`
    - `ListSwapExtension` on `List<E>`
    - `ScrollxExtensions` on `ScrollController`
    - `ListxWidgetExtensions` on `List<Widget>`
    - `IterableIterableX` on `Iterable<Iterable<T>>`
- Never put two unrelated types in the same extension file.

### Null Safety Pattern
- Extensions on nullable receivers (`on String?`, `on Iterable<T>?`) MUST expose a `validate()` method that returns a safe non-null default before any other member accesses `this`.
- Call `validate()` (not `this!`) inside extension bodies wherever the receiver could be null.
- Extensions on non-nullable types (`on Widget`, `on num`, `on DateTime`) must NOT call `validate()`.

### Method Signatures
- Prefer `get` properties over zero-argument methods when there are no parameters and no side effects.
- Return the most specific type available — `SizedBox`, `ClipRRect`, `EdgeInsets` — not a widened `Widget` or `Object`.
- Use named parameters with defaults for optional config (e.g. `{String separator = ','}`).

### Utils Folder Rules
- `patterns.dart` — static `String` constants only inside `class Patterns`. No methods. All fields must be `static const String` (not mutable `static String`).
- `enums.dart` — all package-level enums here, one enum per logical group. Do not define enums inside widget files.
- `default_configs.dart` — mutable `var` globals for configurable defaults. All global state lives here. Prefix with `default…Global` or `is…Global`.
- `time_formatter.dart` — internal helpers only; do not add public API here.
- Never import from `utils/` in extension files directly from outside `src/` — always re-export through `baaba_extensions.dart`.

### Widgets Folder Rules
- One widget per file. File name: `{widget_name}_widgetx.dart` (snake_case).
- Widget class name: `{WidgetName}Widgetx` (PascalCase + `Widgetx` suffix).
- Prefer `StatelessWidget` unless the widget manages its own animation, timer, or controller.
- Every constructor parameter gets a `///` doc comment. Required parameters first, then optional with defaults.
- Export every new widget from `baaba_extensions.dart`.

### Doc Comments
- Every public extension member gets a `///` doc comment.
- Format: one sentence describing the return value or effect. Start with "Returns" or a verb.
- Include a short `Example:` line for non-obvious transformations.
- Do NOT add `///` to private helpers or `validate()` overloads.

### Barrel File (`baaba_extensions.dart`)
- Every new extension, utility, and widget must be exported here via `export 'src/…'`.
- Do NOT add implementation code to the barrel file.

### Global State
- All mutable global config lives only in `utils/default_configs.dart`.
- Extension bodies read globals; they never reassign them directly.
- To toggle masking at call-site use the `isMaskingEnabled` named parameter — do not mutate the global.
- **Known violation:** `isMaskingEnabledGlobal` is currently declared in `stringx_extensions.dart` (line 11) instead of `default_configs.dart`. Move it there when refactoring.

### Regex
- All regex patterns belong in `Patterns` — never define inline `RegExp(r'...')` literals in extension bodies except for trivial single-use cases.
- All fields in `Patterns` must be `static const String` — not `static String` (mutable).

### Testing
- Test file imports `baaba_extensions.dart` (barrel), never individual `src/` files.
- Each extension file should have at least one test group named after the extension.
- Do not ship the placeholder `Calculator` test — replace it with real extension tests.

## Known Issues

These are confirmed bugs or rule violations to fix in the next patch release:

| Issue | Location | Description |
|---|---|---|
| `isMaskingEnabledGlobal` in wrong file | `stringx_extensions.dart:11` | Violates global-state rule; move to `default_configs.dart` and remove from here |
| `repeat()` never throws | `stringx_extensions.dart:218` | `ArgumentError(...)` is constructed but not thrown — add `throw` keyword |
| `isInt` unsafe null dereference | `stringx_extensions.dart:94` | `bool get isInt => this!.isDigit()` — should be `validate().isDigit()` |
| `toIntX` rejects negative integers | `stringx_extensions.dart:166` | Uses `isDigit()` which rejects `-5`; replace with `int.tryParse` |
| `Patterns` fields not `const` | `utils/patterns.dart` | Non-Pakistan fields are `static String` (mutable); all should be `static const String` |
| `TrimMode` defined inside widget file | `widgets/read_more_widgetx.dart:4` | Enum should live in `utils/enums.dart`, not inside a widget file |
| `alphaRegExp` is mutable top-level var | `stringx_extensions.dart:9` | Should be `final RegExp` or a `static const String` in `Patterns` |