import 'package:flutter/material.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: GraphPainter(),
        child: Container(),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw grid lines
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.grey[300]!;

    // Vertical grid lines
    for (int i = 0; i <= 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal grid lines
    for (int i = 0; i <= 5; i++) {
      final y = (size.height / 5) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw data points and lines
    final points = [
      Offset(20, size.height * 0.8),
      Offset(60, size.height * 0.6),
      Offset(100, size.height * 0.4),
      Offset(140, size.height * 0.7),
      Offset(180, size.height * 0.3),
      Offset(220, size.height * 0.5),
      Offset(260, size.height * 0.2),
      Offset(300, size.height * 0.6),
    ];

    // Blue line
    paint.color = Colors.blue;
    _drawLineWithPoints(canvas, paint, points);

    // Teal line (offset slightly)
    paint.color = Colors.teal;
    final tealPoints = points.map((p) => Offset(p.dx, p.dy - 20)).toList();
    _drawLineWithPoints(canvas, paint, tealPoints);

    // Yellow line (offset slightly)
    paint.color = Colors.amber;
    final yellowPoints = points.map((p) => Offset(p.dx, p.dy + 20)).toList();
    _drawLineWithPoints(canvas, paint, yellowPoints);

    // Draw colored bars at bottom
    final barColors = [
      Colors.green,
      Colors.lightBlue,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
    ];

    final barWidth = size.width / barColors.length;
    for (int i = 0; i < barColors.length; i++) {
      final barPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = barColors[i];

      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth,
          size.height - 15,
          barWidth - 2,
          15,
        ),
        barPaint,
      );
    }
  }

  void _drawLineWithPoints(Canvas canvas, Paint paint, List<Offset> points) {
    // Draw lines
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    final pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = paint.color;

    for (final point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 