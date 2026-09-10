enum MaskType { auto, email, phone }

/// Controls the visual style of [LoadingOverlayWidgetx].
///
/// - [fullScreen] — a translucent barrier fills the entire widget area with
///   a centred spinner on top.
/// - [centered] — only the spinner is shown at the centre; no background tint.
///
/// In both modes the underlying child is fully non-interactive while loading.
enum LoadingOverlayMode { fullScreen, centered }

/// The lifecycle state of a [PaginatorX].
///
/// - [initial] — nothing has been requested yet.
/// - [loadingFirst] — the first page is in flight and no items are held.
/// - [refreshing] — a pull-to-refresh is in flight; existing items stay visible.
/// - [loadingMore] — a subsequent page is in flight.
/// - [loaded] — idle with at least one item.
/// - [empty] — a successful load returned zero items.
/// - [firstPageError] — a load failed while the list was empty.
/// - [loadMoreError] — a load failed but previously loaded items are still held.
enum PaginationStatus { initial, loadingFirst, refreshing, loadingMore, loaded, empty, firstPageError, loadMoreError }

/// Controls whether a paginated list also surfaces load failures in a dialog.
///
/// An inline error state is *always* rendered — the body shows a retry state
/// when the first page fails and the footer shows a retry row when a later
/// page fails. This enum only decides whether a blocking Retry / Cancel
/// dialog is shown on top of it.
///
/// - [inline] — no dialog; inline retry only. Recommended default: a failed
///   background page-load should not interrupt someone mid-scroll.
/// - [dialog] — a dialog on every failure, including later pages.
/// - [dialogOnFirstPage] — a dialog only when the list is still empty, since a
///   blank screen genuinely needs an explanation; later failures stay inline.
enum PaginationErrorMode { inline, dialog, dialogOnFirstPage }

/// The visual style of a [ButtonWidgetx].
///
/// - [filled] — solid background in the primary colour. The default call to action.
/// - [tonal] — muted background in the secondary container colour.
/// - [outlined] — transparent with a border; a secondary action.
/// - [text] — no background or border; a tertiary action.
/// - [danger] — solid background in the error colour, for destructive actions.
enum ButtonVariantX { filled, tonal, outlined, text, danger }

/// The height and typography scale of a [ButtonWidgetx].
enum ButtonSizeX { small, medium, large }

/// The severity of an [AlertBannerWidgetx], which selects its colour and icon.
enum AlertTypeX { success, error, warning, info }

/// The state of a single [TimelineItemX] within a [TimelineWidgetx].
///
/// - [completed] — the step is done; the node is filled and the connector solid.
/// - [active] — the step is in progress; the node is ringed and highlighted.
/// - [pending] — the step has not started; the node and connector are muted.
enum TimelineItemStateX { completed, active, pending }

/// The selection behaviour of a [ChipsFilterWidgetx].
///
/// - [single] — at most one chip is selected at a time.
/// - [multiple] — any number of chips may be selected.
enum ChipsSelectionModeX { single, multiple }

/// The choice a user made in an [ImagePickerSheetWidgetx].
///
/// - [camera] — take a new photo with the camera.
/// - [gallery] — choose an existing photo from the gallery.
/// - [remove] — clear the currently selected image.
enum ImagePickerSourceX { camera, gallery, remove }

/// Presets applied by a [TextFieldWidgetx] — keyboard type, autofill hints,
/// obscuring, default icon, and the validation pattern used when
/// `validationPattern` is not given explicitly.
///
/// - [text] — plain single-line text; no pattern.
/// - [email] — email keyboard, validated against `Patterns.email`.
/// - [password] — obscured with a visibility toggle.
/// - [phone] — phone keyboard, validated against `Patterns.phone`.
/// - [number] — numeric keyboard, digits only.
/// - [multiline] — expands to several lines.
/// - [search] — search action key on the keyboard.
/// - [url] — URL keyboard, validated against `Patterns.url`.
enum FieldTypeX { text, email, password, phone, number, multiline, search, url }
