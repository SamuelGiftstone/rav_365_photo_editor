import 'package:flutter/material.dart';

class HistogramPainter extends CustomPainter {
  final List<int> red;
  final List<int> green;
  final List<int> blue;

  HistogramPainter({
    required this.red,
    required this.green,
    required this.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (red.isEmpty) return;

    final double widthStep = size.width / (red.length - 1);
    final int maxVal = 100;

    _drawChannel(canvas, size, red, const Color(0xFFEF4444).withOpacity(0.5), widthStep, maxVal);
    _drawChannel(canvas, size, green, const Color(0xFF10B981).withOpacity(0.5), widthStep, maxVal);
    _drawChannel(canvas, size, blue, const Color(0xFF3B82F6).withOpacity(0.5), widthStep, maxVal);
  }

  void _drawChannel(Canvas canvas, Size size, List<int> values, Color color, double widthStep, int maxVal) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    path.moveTo(0, size.height);
    for (int i = 0; i < values.length; i++) {
      final double x = i * widthStep;
      final double y = size.height - (values[i] / maxVal) * size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
