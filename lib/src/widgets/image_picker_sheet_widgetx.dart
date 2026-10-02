import 'package:flutter/material.dart';

import '../sheetx_extensions.dart';
import '../utils/default_configs.dart';
import '../utils/enums.dart';

/// The "Take a photo / Choose from gallery / Remove" sheet.
///
/// [pickSource] shows the sheet and returns the choice; the picking itself is
/// left to the app, so the package carries no camera or gallery plugin and
/// any picker, cropper, or custom camera can follow:
///
/// ```dart
/// final source = await ImagePickerSheetWidgetx.pickSource(
///   context,
///   showRemove: avatarPath != null,
/// );
/// switch (source) {
///   case ImagePickerSourceX.camera:
///     final file = await ImagePicker().pickImage(source: ImageSource.camera);
///   case ImagePickerSourceX.gallery:
///     final file = await ImagePicker().pickImage(source: ImageSource.gallery);
///   case ImagePickerSourceX.remove:
///     removeAvatar();
///   case null:
///     break; // dismissed
/// }
/// ```
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
