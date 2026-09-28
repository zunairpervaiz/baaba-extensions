# baaba_extensions

Flutter/Dart extension package. Dart SDK `^3.12.0`, Flutter `>=3.44.0` (floor set by `fluttertoast ^10.0.0`).

## Dependencies
- `fluttertoast: ^10.0.0` — used only in `StringExtension.toastString()`
- `flutter_auto_size_text: ^5.0.0` — used only in `VxTextBuilder`
- `connectivity_plus: ^7.3.1` — used only in `ConnectivityBannerWidgetx`
- `image_picker: ^1.2.3` — used only in `ImagePickerSheetWidgetx`
- Linting: `flutter_lints ^6.0.0` (inherits `flutter.yaml` rules)

Keep the dependency list small. `connectivity_plus` and `image_picker` are **platform plugins**, so every consuming app inherits them whether or not it uses those two widgets, and `image_picker` additionally requires `NSCameraUsageDescription` / `NSPhotoLibraryUsageDescription` in the app's iOS `Info.plist`. Do not add another plugin dependency without a deliberate decision; prefer an injection seam (as `ConnectivityBannerWidgetx.statusStream` and `ImagePickerSheetWidgetx.picker` provide) so the widget stays testable and the plugin stays replaceable.

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
    listx_extensions.dart          # Iterable<T>? → ListX, IterableAsyncX; Iterable<T?>? → IterableNullableX;
                                   #   List<T> → ListSplit, ListAccessX, ListMutationX, ListTransformX,
                                   #   ListSwapExtension; Iterable<Iterable<T>> → IterableIterableX
    listx_widgets_extensions.dart  # List<Widget> → ListxWidgetExtensions
    mapx_extensions.dart           # Map<K,V> → MapX
    numx_extensions.dart           # num → NumX/NumPaddingX; int → NumDurationX/NumTimeX/NumCoerceInExtension
    scrollx_extensions.dart        # ScrollController → ScrollxExtensions
    sheetx_extensions.dart         # BuildContext → SheetX (+ SheetActionX model)
    stringx_extensions.dart        # String? → StringExtension
    widgetx_extensions.dart        # Widget → WidgetX
    mixins/                        # INTERNAL — not exported; support for text_widgetx.dart only
      color_mixin.dart             # VxColorMixin<T>
      render_mixin.dart            # VxRenderMixin<T>
      vx_mixin.dart                # Vx
    utils/
      default_configs.dart         # mutable global config vars (toast, dialog, pagination, button,
                                   #   field, sheet, alert, async, connectivity, image picker)
      enums.dart                   # package-wide enums — see the enum list below
      formx.dart                   # FormX<K> — generic multi-field form controller
      none_widget.dart             # INTERNAL — NoneWidget; not exported
      paginatorx.dart              # PaginatorX<T> + PageX<T> — pagination controller
      patterns.dart                # Patterns class — static regex strings only
      time_formatter.dart          # formatTime() helper for timeAgo
      widget_builder.dart          # INTERNAL — VxWidgetBuilders et al; not exported
    widgets/
      alert_banner_widgetx.dart
      animated_counter_widgetx.dart
      async_builder_widgetx.dart    # AsyncBuilderWidgetx<T> + public AsyncBuilderWidgetxState<T>
      avatar_widgetx.dart
      badge_widgetx.dart
      button_widgetx.dart
      chips_filter_widgetx.dart
      circular_progress_widgetx.dart
      connectivity_banner_widgetx.dart
      countdown_timer_widgetx.dart
      empty_state_widgetx.dart
      expandable_widgetx.dart
      gradient_button_widgetx.dart
      horizontal_list_without_height.dart
      image_picker_sheet_widgetx.dart
      loading_overlay_widgetx.dart
      network_image_widgetx.dart
      paginated_list_widgetx.dart
      pin_input_widgetx.dart
      quantity_stepper_widgetx.dart
      rating_widgetx.dart
      read_more_widgetx.dart        # also defines TrimMode enum (see Known Issues)
      restart_app_widgetx.dart
      scroll_to_top_widgetx.dart
      search_bar_widgetx.dart
      segmented_control_widgetx.dart
      skeleton_list_widgetx.dart
      skeleton_loader_widgetx.dart
      stepper_indicator_widgetx.dart
      swiper_widgetx.dart
      text_field_widgetx.dart       # TextFieldWidgetx<K> — pairs with FormX
      text_widgetx.dart             # VxTextBuilder + VxStringTextExtensions + VxTextExtensions
      timeline_widgetx.dart         # TimelineWidgetx + TimelineItemX model
test/
  baaba_extensions_test.dart
```

### Enums in `utils/enums.dart`
`MaskType`, `LoadingOverlayMode`, `PaginationStatus`, `PaginationErrorMode`, `ButtonVariantX`, `ButtonSizeX`, `AlertTypeX`, `TimelineItemStateX`, `ChipsSelectionModeX`, `ImagePickerSourceX`, `FieldTypeX`.

`TrimMode` is the one exception, still declared in `widgets/read_more_widgetx.dart` — see Known Issues.

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

### Extension Resolution Traps
Both of these have already caused real bugs here. Check for them whenever adding an extension member.

- **Instance members always beat extensions.** An extension member whose name matches a real member on the receiver is silently unreachable — it compiles, and the instance member is called instead. `ListxWidgetExtensions.toList()` was dead for exactly this reason (`Iterable.toList` won every time), so it was removed in favour of `toListView()`. Before naming a member, confirm the name does not already exist on the receiver type. Names already taken on `Iterable`: `toList`, `firstOrNull`, `lastOrNull`, `singleOrNull`, `elementAtOrNull`, `indexed`, `nonNulls`, `reversed`, `map`, `where`, `expand`, `fold`, `any`, `every`.
  - A member on an extension over a **nullable** receiver (`on Iterable<T>?`) is fine even when the name exists on the non-null type — the instance member wins for non-null receivers and the extension only fills the nullable gap. `ListX.firstOrNull` / `lastOrNull` do this deliberately.
- **A generic extension can shadow a more specific one through covariance.** `List<Text>` is a subtype of `List<Widget>`, so an extension `on List<T>` and one `on List<Widget>` can both apply, and Dart picks the more specific instantiation — the generic one — which then demands a `Text` argument and fails to compile. This is why the generic separator helper is named `ListTransformX.intersperse` and not `separatedBy`. Never give a member on `List<T>` the same name as one on `List<Widget>`.

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
- Keep the three comment-grouped blocks (`// Extensions`, `// Utils`, `// Widgets`) alphabetised.
- **Deliberately not exported** — internal support for `text_widgetx.dart`, kept off the public API: `src/mixins/` (all three files), `src/utils/none_widget.dart`, `src/utils/widget_builder.dart`. Leave them unexported; everything else must be exported.

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
- Every widget gets a `testWidgets` group named after the class. Cover, where they apply: the disposal path (a future or stream landing after unmount must not throw), controller ownership (a caller-supplied controller must survive the widget), and the disabled/loading paths.
- Anything randomised or time-based takes an injectable seam so tests are deterministic — a seeded `Random`, an injected `statusStream`, an injected `ImagePicker`.

### Formatting
- The repo is **not** uniformly `dart format`ted, and there is no configured page width. Do **not** run `dart format` across `lib/` or `test/` — it reformats unrelated files and buries real changes in whitespace churn. Match the surrounding style by hand.

## Known Issues

These are confirmed bugs or rule violations to fix in the next patch release. All were re-verified against the working tree as of the 0.7.0 work; line numbers are current.

| Issue | Location | Description |
|---|---|---|
| `isMaskingEnabledGlobal` in wrong file | `stringx_extensions.dart:11` | Violates global-state rule; move to `default_configs.dart` and remove from here |
| `repeat()` never throws | `stringx_extensions.dart:217` | `ArgumentError(...)` is constructed but not thrown — add `throw` keyword |
| `isInt` unsafe null dereference | `stringx_extensions.dart:93` | `bool get isInt => this!.isDigit()` — should be `validate().isDigit()` |
| `toIntX` rejects negative integers | `stringx_extensions.dart:165` | Uses `isDigit()` which rejects `-5`; replace with `int.tryParse` |
| `Patterns` fields not `const` | `utils/patterns.dart` | 14 fields are `static String` (mutable); all should be `static const String` |
| `TrimMode` defined inside widget file | `widgets/read_more_widgetx.dart:4` | Enum should live in `utils/enums.dart`, not inside a widget file. Its members `Length`/`Line` also violate `constant_identifier_names` — two of the three outstanding analyzer infos |
| `alphaRegExp` is mutable top-level var | `stringx_extensions.dart:9` | Should be `final RegExp` or a `static const String` in `Patterns` |
| Unused type parameter shadows a type | `utils/widget_builder.dart:15` | `VxTextSpanBuilder<TextSpan>` names its type parameter after a real type — the third outstanding analyzer info |

`flutter analyze` is otherwise clean: the only 3 reported infos are the `TrimMode` constant names and the `widget_builder.dart` type parameter above. Keep it that way — a new warning means new work, not an accepted baseline.