import 'package:flutter/material.dart';

class QrCodeVectorIcon extends StatelessWidget {
  final Color color;
  final double size;

  const QrCodeVectorIcon({
    super.key,
    this.color = Colors.white,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _QrCodePainter(color),
    );
  }
}

class _QrCodePainter extends CustomPainter {
  final Color color;

  _QrCodePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Normalizing coordinates from a 24x24 design grid
    final double scaleX = size.width / 24.0;
    final double scaleY = size.height / 24.0;

    final path = Path();

    // Top-left square inner
    path.moveTo(9.5 * scaleX, 6.5 * scaleY);
    path.lineTo(9.5 * scaleX, 9.5 * scaleY);
    path.lineTo(6.5 * scaleX, 9.5 * scaleY);
    path.lineTo(6.5 * scaleX, 6.5 * scaleY);
    path.close();

    // Top-left square outer
    path.moveTo(11 * scaleX, 5 * scaleY);
    path.lineTo(5 * scaleX, 5 * scaleY);
    path.lineTo(5 * scaleX, 11 * scaleY);
    path.lineTo(11 * scaleX, 11 * scaleY);
    path.close();

    // Bottom-left square inner
    path.moveTo(9.5 * scaleX, 14.5 * scaleY);
    path.lineTo(9.5 * scaleX, 17.5 * scaleY);
    path.lineTo(6.5 * scaleX, 17.5 * scaleY);
    path.lineTo(6.5 * scaleX, 14.5 * scaleY);
    path.close();

    // Bottom-left square outer
    path.moveTo(11 * scaleX, 13 * scaleY);
    path.lineTo(5 * scaleX, 13 * scaleY);
    path.lineTo(5 * scaleX, 19 * scaleY);
    path.lineTo(11 * scaleX, 19 * scaleY);
    path.close();

    // Top-right square inner
    path.moveTo(17.5 * scaleX, 6.5 * scaleY);
    path.lineTo(17.5 * scaleX, 9.5 * scaleY);
    path.lineTo(14.5 * scaleX, 9.5 * scaleY);
    path.lineTo(14.5 * scaleX, 6.5 * scaleY);
    path.close();

    // Top-right square outer
    path.moveTo(19 * scaleX, 5 * scaleY);
    path.lineTo(13 * scaleX, 5 * scaleY);
    path.lineTo(13 * scaleX, 11 * scaleY);
    path.lineTo(19 * scaleX, 11 * scaleY);
    path.close();

    // Pixels
    path.moveTo(13 * scaleX, 13 * scaleY);
    path.lineTo(14.5 * scaleX, 13 * scaleY);
    path.lineTo(14.5 * scaleX, 14.5 * scaleY);
    path.lineTo(13 * scaleX, 14.5 * scaleY);
    path.close();

    path.moveTo(14.5 * scaleX, 14.5 * scaleY);
    path.lineTo(16 * scaleX, 14.5 * scaleY);
    path.lineTo(16 * scaleX, 16 * scaleY);
    path.lineTo(14.5 * scaleX, 16 * scaleY);
    path.close();

    path.moveTo(16 * scaleX, 13 * scaleY);
    path.lineTo(17.5 * scaleX, 13 * scaleY);
    path.lineTo(17.5 * scaleX, 14.5 * scaleY);
    path.lineTo(16 * scaleX, 14.5 * scaleY);
    path.close();

    path.moveTo(13 * scaleX, 16 * scaleY);
    path.lineTo(14.5 * scaleX, 16 * scaleY);
    path.lineTo(14.5 * scaleX, 17.5 * scaleY);
    path.lineTo(13 * scaleX, 17.5 * scaleY);
    path.close();

    path.moveTo(14.5 * scaleX, 17.5 * scaleY);
    path.lineTo(16 * scaleX, 17.5 * scaleY);
    path.lineTo(16 * scaleX, 19 * scaleY);
    path.lineTo(14.5 * scaleX, 19 * scaleY);
    path.close();

    path.moveTo(16 * scaleX, 16 * scaleY);
    path.lineTo(17.5 * scaleX, 16 * scaleY);
    path.lineTo(17.5 * scaleX, 17.5 * scaleY);
    path.lineTo(16 * scaleX, 17.5 * scaleY);
    path.close();

    path.moveTo(17.5 * scaleX, 14.5 * scaleY);
    path.lineTo(19 * scaleX, 14.5 * scaleY);
    path.lineTo(19 * scaleX, 16 * scaleY);
    path.lineTo(17.5 * scaleX, 16 * scaleY);
    path.close();

    path.moveTo(17.5 * scaleX, 17.5 * scaleY);
    path.lineTo(19 * scaleX, 17.5 * scaleY);
    path.lineTo(19 * scaleX, 19 * scaleY);
    path.lineTo(17.5 * scaleX, 19 * scaleY);
    path.close();

    // Corners
    path.moveTo(22 * scaleX, 7 * scaleY);
    path.lineTo(20 * scaleX, 7 * scaleY);
    path.lineTo(20 * scaleX, 4 * scaleY);
    path.lineTo(17 * scaleX, 4 * scaleY);
    path.lineTo(17 * scaleX, 2 * scaleY);
    path.lineTo(22 * scaleX, 2 * scaleY);
    path.close();

    path.moveTo(22 * scaleX, 22 * scaleY);
    path.lineTo(22 * scaleX, 17 * scaleY);
    path.lineTo(20 * scaleX, 17 * scaleY);
    path.lineTo(20 * scaleX, 20 * scaleY);
    path.lineTo(17 * scaleX, 20 * scaleY);
    path.lineTo(17 * scaleX, 22 * scaleY);
    path.close();

    path.moveTo(2 * scaleX, 22 * scaleY);
    path.lineTo(7 * scaleX, 22 * scaleY);
    path.lineTo(7 * scaleX, 20 * scaleY);
    path.lineTo(4 * scaleX, 20 * scaleY);
    path.lineTo(4 * scaleX, 17 * scaleY);
    path.lineTo(2 * scaleX, 17 * scaleY);
    path.close();

    path.moveTo(2 * scaleX, 2 * scaleY);
    path.lineTo(2 * scaleX, 7 * scaleY);
    path.lineTo(4 * scaleX, 7 * scaleY);
    path.lineTo(4 * scaleX, 4 * scaleY);
    path.lineTo(7 * scaleX, 4 * scaleY);
    path.lineTo(7 * scaleX, 2 * scaleY);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
