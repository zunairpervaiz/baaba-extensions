enum MaskType { auto, email, phone }

/// Controls the visual style of [LoadingOverlayWidgetx].
///
/// - [fullScreen] — a translucent barrier fills the entire widget area with
///   a centred spinner on top.
/// - [centered] — only the spinner is shown at the centre; no background tint.
///
/// In both modes the underlying child is fully non-interactive while loading.
enum LoadingOverlayMode { fullScreen, centered }