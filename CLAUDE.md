# baaba_extensions

Flutter/Dart extension package. Dart SDK `^3.11.3`, Flutter `>=1.17.0`.

## Dependencies
- `fluttertoast: ^9.0.0` — used only in `StringExtension.toastString()`
- Linting: `flutter_lints ^6.0.0` (inherits `flutter.yaml` rules)

## Folder Layout

```
lib/
  baaba_extensions.dart       # barrel export — ALL public symbols must be exported here
  src/
    contextx_extensions.dart  # BuildContext → ContextX
    date_timex_extensions.dart# DateTime → DateTimeExt + top-level helpers
    listx_extensions.dart     # Iterable<T>? → ListX, List<T> → ListSplit, ListSwapExtension
    numx_extensions.dart      # num → NumX/NumPaddingX, int → NumDurationX/NumTimeX/NumCoerceInExtension
    stringx_extensions.dart   # String? → StringExtension
    widgetx_tensions.dart     # Widget → WidgetX  (filename typo — do not rename without checking imports)
    utils/
      default_configs.dart    # mutable global config vars (toast colors, gravity)
      enums.dart              # package-wide enums (MaskType)
      patterns.dart           # Patterns class — static regex strings only
      time_formatter.dart     # formatTime() helper for timeAgo
test/
  baaba_extensions_test.dart
```

## Hard Rules

### File & Extension Naming
- One extension file per Dart type. File name: `{type}x_extensions.dart` (snake_case).
- Extension name: `{TypeName}X` suffix — e.g. `ContextX`, `NumX`, `ListX`, `WidgetX`.
  - Exception: `StringExtension` and `DateTimeExt` (legacy names — keep them).
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
- `patterns.dart` — static `String` constants only inside `class Patterns`. No methods.
- `enums.dart` — all package-level enums here, one enum per logical group.
- `default_configs.dart` — mutable `var` globals for configurable defaults. Prefix with `default…Global`.
- Never import from `utils/` in extension files directly from outside `src/` — always re-export through `baaba_extensions.dart`.

### Doc Comments
- Every public extension member gets a `///` doc comment.
- Format: one sentence describing the return value or effect. Start with "Returns" or a verb.
- Include a short `Example:` line for non-obvious transformations.
- Do NOT add `///` to private helpers or `validate()` overloads.

### Barrel File (`baaba_extensions.dart`)
- Every new extension and utility must be exported here via `export 'src/…'`.
- Do NOT add implementation code to the barrel file.

### Global State
- Global mutable config (`isMaskingEnabledGlobal`, toast defaults) lives only in `utils/default_configs.dart`.
- Extension bodies read globals; they never reassign them directly.
- To toggle masking at call-site use the `isMaskingEnabled` named parameter — do not mutate the global.

### Regex
- All regex patterns belong in `Patterns` — never define inline `RegExp(r'...')` literals in extension bodies except for trivial single-use cases.
- Pakistan-specific patterns (`pkMobileLocal`, `pkMobileGlobal`) are `const String`; generic ones may be `static String`.

### Testing
- Test file imports `baaba_extensions.dart` (barrel), never individual `src/` files.
- Each extension file should have at least one test group named after the extension.
- Do not ship the placeholder `Calculator` test — replace it with real extension tests.

## Known Issues (do not silently work around)
- `lib/baaba_extensions.dart` is still a stub (`Calculator` class). Replace with proper `export` directives.
