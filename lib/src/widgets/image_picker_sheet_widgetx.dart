import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../sheetx_extensions.dart';
import '../utils/default_configs.dart';
import '../utils/enums.dart';

/// The "Take a photo / Choose from gallery / Remove" sheet, with the picking
/// already wired to [image_picker].
///
/// [pick] is the one-call version — it shows the sheet, runs the picker, and
/// hands back the file:
///
/// ```dart
/// final file = await ImagePickerSheetWidgetx.pick(
///   context,
///   showRemove: avatarPath != null,
///   imageQuality: 70,
///   maxWidth: 1080,
/// );
/// if (file != null) setState(() => avatarPath = file.path);
/// ```
///
/// [pickSource] stops after the choice, for callers that do their own picking
/// (a cropper in between, a different plugin, a custom camera):
///
/// ```dart
/// final source = await ImagePickerSheetWidgetx.pickSource(context);
/// if (source == ImagePickerSourceX.remove) removeAvatar();
/// ```
///
/// The platform permission entries are the app's responsibility — add
/// `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to
/// `Info.plist` on iOS. A denied permission surfaces as `null`, or through
/// [onError] when the plugin throws.
class ImagePickerSheetWidgetx extends StatelessWidget {
  /// Heading of the sheet. Defaults to [defaultImagePickerTitleGlobal].
  final String? title;

  /// Label of the camera row. Defaults to [defaultImagePickerCameraTextGlobal].
  final String? cameraText;

  /// Label of the gallery row. Defaults to [defaultImagePickerGalleryTextGlobal].
  final String? galleryText;

  /// Label of the remove row. Defaults to [defaultImagePickerRemoveTextGlobal].
  final String? removeText;

  /// Whether the destructive remove row is offered.
  /// Set it to `true` only when there is an image to remove.
  final bool showRemove;

  /// Whether the camera row is offered.
  final bool showCamera;

  /// Whether the gallery row is offered.
  final bool showGallery;

  /// Icon of the camera row.
  final IconData cameraIcon;

  /// Icon of the gallery row.
  final IconData galleryIcon;

  /// Icon of the remove row.
  final IconData removeIcon;

  const ImagePickerSheetWidgetx({
    super.key,
    this.title,
    this.cameraText,
    this.galleryText,
    this.removeText,
    this.showRemove = false,
    this.showCamera = true,
    this.showGallery = true,
    this.cameraIcon = Icons.photo_camera_outlined,
    this.galleryIcon = Icons.photo_library_outlined,
    this.removeIcon = Icons.delete_outline_rounded,
  });

  /// The rows this sheet offers, in order.
  List<SheetActionX<ImagePickerSourceX>> buildActions() => [
    if (showCamera)
      SheetActionX(label: cameraText ?? defaultImagePickerCameraTextGlobal, icon: cameraIcon, value: ImagePickerSourceX.camera),
    if (showGallery)
      SheetActionX(label: galleryText ?? defaultImagePickerGalleryTextGlobal, icon: galleryIcon, value: ImagePickerSourceX.gallery),
    if (showRemove)
      SheetActionX(
        label: removeText ?? defaultImagePickerRemoveTextGlobal,
        icon: removeIcon,
        value: ImagePickerSourceX.remove,
        isDestructive: true,
      ),
  ];

  /// Shows the sheet and returns the choice the user made, without picking
  /// anything. Returns `null` if the sheet was dismissed.
  static Future<ImagePickerSourceX?> pickSource(
    BuildContext context, {
    String? title,
    String? cameraText,
    String? galleryText,
    String? removeText,
    String? cancelText,
    bool showRemove = false,
    bool showCamera = true,
    bool showGallery = true,
    IconData cameraIcon = Icons.photo_camera_outlined,
    IconData galleryIcon = Icons.photo_library_outlined,
    IconData removeIcon = Icons.delete_outline_rounded,
  }) {
    final sheet = ImagePickerSheetWidgetx(
      title: title,
      cameraText: cameraText,
      galleryText: galleryText,
      removeText: removeText,
      showRemove: showRemove,
      showCamera: showCamera,
      showGallery: showGallery,
      cameraIcon: cameraIcon,
      galleryIcon: galleryIcon,
      removeIcon: removeIcon,
    );

    return context.showActionSheet<ImagePickerSourceX>(
      title: title ?? defaultImagePickerTitleGlobal,
      cancelText: cancelText,
      actions: sheet.buildActions(),
    );
  }

  /// Shows the sheet, runs [ImagePicker] against the chosen source, and
  /// returns the file.
  ///
  /// Returns `null` when the sheet was dismissed, when the picker was
  /// cancelled, when the user chose remove — [onRemove] fires in that case —
  /// or when the pick failed.
  static Future<XFile?> pick(
    BuildContext context, {
    String? title,
    String? cameraText,
    String? galleryText,
    String? removeText,
    String? cancelText,
    bool showRemove = false,
    bool showCamera = true,
    bool showGallery = true,
    IconData cameraIcon = Icons.photo_camera_outlined,
    IconData galleryIcon = Icons.photo_library_outlined,
    IconData removeIcon = Icons.delete_outline_rounded,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
    VoidCallback? onRemove,
    void Function(Object error, StackTrace stackTrace)? onError,
    ImagePicker? picker,
  }) async {
    final source = await pickSource(
      context,
      title: title,
      cameraText: cameraText,
      galleryText: galleryText,
      removeText: removeText,
      cancelText: cancelText,
      showRemove: showRemove,
      showCamera: showCamera,
      showGallery: showGallery,
      cameraIcon: cameraIcon,
      galleryIcon: galleryIcon,
      removeIcon: removeIcon,
    );

    if (source == null) return null;
    if (source == ImagePickerSourceX.remove) {
      onRemove?.call();
      return null;
    }

    try {
      return await (picker ?? ImagePicker()).pickImage(
        source: source == ImagePickerSourceX.camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );
    } catch (error, stackTrace) {
      // A denied permission and a cancelled system dialog both land here on
      // some platforms; neither should crash the calling screen.
      if (onError == null) return null;
      onError(error, stackTrace);
      return null;
    }
  }

  /// Shows the sheet and returns every image the user picked from the gallery.
  ///
  /// Choosing the camera still yields a single-item list. Returns an empty
  /// list when nothing was picked.
  static Future<List<XFile>> pickMultiple(
    BuildContext context, {
    String? title,
    String? cameraText,
    String? galleryText,
    String? cancelText,
    bool showCamera = true,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    void Function(Object error, StackTrace stackTrace)? onError,
    ImagePicker? picker,
  }) async {
    final source = await pickSource(
      context,
      title: title,
      cameraText: cameraText,
      galleryText: galleryText,
      cancelText: cancelText,
      showCamera: showCamera,
    );

    if (source == null || source == ImagePickerSourceX.remove) return const [];
    final imagePicker = picker ?? ImagePicker();

    try {
      if (source == ImagePickerSourceX.camera) {
        final file = await imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
        return file == null ? const [] : [file];
      }
      return await imagePicker.pickMultiImage(maxWidth: maxWidth, maxHeight: maxHeight, imageQuality: imageQuality, limit: limit);
    } catch (error, stackTrace) {
      if (onError != null) onError(error, stackTrace);
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rendered directly only when embedded rather than shown as a sheet — the
    // static helpers above are the usual entry points.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final action in buildActions())
          ListTile(
            leading: Icon(action.icon, color: action.isDestructive ? Theme.of(context).colorScheme.error : null),
            title: Text(action.label, style: TextStyle(color: action.isDestructive ? Theme.of(context).colorScheme.error : null)),
            onTap: () => Navigator.of(context).pop(action.value),
          ),
      ],
    );
  }
}
