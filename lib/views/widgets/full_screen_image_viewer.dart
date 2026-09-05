import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full-screen interactive image viewer widget with pinch-to-zoom and pan support.
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.title = 'Prescription Image',
  });

  /// Helper static method to show the full-screen image viewer overlay.
  static Future<void> show(BuildContext context, String imageUrl, {String title = 'Prescription Image'}) {
    return Get.dialog<void>(
      FullScreenImageViewer(
        imageUrl: imageUrl,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: AppColors.pureBlack,
        appBar: AppBar(
          backgroundColor: AppColors.navy,
          iconTheme: const IconThemeData(color: AppColors.white),
          title: Text(
            title,
            style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.white),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 5.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                    color: AppColors.teal,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image, size: 64, color: AppColors.coolGray),
                    SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: AppColors.coolGray, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
