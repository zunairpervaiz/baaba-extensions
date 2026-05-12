import 'package:flutter/material.dart';

/// A circular avatar that supports a network image, an initials fallback,
/// an online indicator, and a badge count.
///
/// Example:
/// ```dart
/// AvatarWidgetx(name: 'John Doe', imageUrl: user.photoUrl, showOnlineIndicator: true)
/// AvatarWidgetx(name: 'Jane', radius: 32, badgeCount: 3)
/// ```
class AvatarWidgetx extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final bool showOnlineIndicator;
  final Color onlineColor;
  final int? badgeCount;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const AvatarWidgetx({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 24,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.showOnlineIndicator = false,
    this.onlineColor = const Color(0xFF4CAF50),
    this.badgeCount,
    this.badgeColor,
    this.badgeTextColor,
  });

  String get _initials {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fg = textColor ?? theme.colorScheme.onPrimaryContainer;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: hasImage
          ? null
          : Text(
              _initials,
              style: textStyle ??
                  TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w600,
                    fontSize: radius * 0.6,
                  ),
            ),
    );

    if (!showOnlineIndicator && badgeCount == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        if (showOnlineIndicator)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.45,
              height: radius * 0.45,
              decoration: BoxDecoration(
                color: onlineColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 1.5,
                ),
              ),
            ),
          ),
        if (badgeCount != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                minWidth: radius * 0.5,
                minHeight: radius * 0.5,
              ),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor ?? theme.colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 1.5,
                ),
              ),
              child: Text(
                badgeCount! > 99 ? '99+' : '$badgeCount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: badgeTextColor ?? theme.colorScheme.onError,
                  fontSize: radius * 0.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
