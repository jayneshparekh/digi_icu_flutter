import 'package:flutter/material.dart';

/// A network image displayed as an avatar with rounded corners. Falls back to
/// [fallbackAsset] (or a generic [Icons.person] icon) when the image URL is
/// empty or fails to load.
class AppNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;
  final String fallbackAsset;

  const AppNetworkAvatar({
    super.key,
    required this.imageUrl,
    this.size = 72,
    this.borderRadius = 6,
    this.fallbackAsset = 'assets/images/default_user.png',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Image.asset(
      fallbackAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.person,
        size: 48,
        color: Colors.grey,
      ),
    );
  }
}
