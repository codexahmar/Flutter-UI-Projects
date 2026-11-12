import 'package:flutter/material.dart';

/// Authentic uniform-stroke Pinterest iOS iconography scaled to any optical size.
class PinterestHomeIcon extends StatelessWidget {
  final bool active;
  final Color color;
  final double size;

  const PinterestHomeIcon({
    super.key,
    required this.active,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _HomePainter(active: active, color: color),
    );
  }
}

class _HomePainter extends CustomPainter {
  final bool active;
  final Color color;

  _HomePainter({required this.active, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale);

    final house = Path()
      ..moveTo(11.15, 3.15)
      ..quadraticBezierTo(12.0, 2.45, 12.85, 3.15)
      ..lineTo(20.15, 9.15)
      ..quadraticBezierTo(20.8, 9.7, 20.8, 10.65)
      ..lineTo(20.8, 18.8)
      ..quadraticBezierTo(20.8, 20.8, 18.8, 20.8)
      ..lineTo(5.2, 20.8)
      ..quadraticBezierTo(3.2, 20.8, 3.2, 18.8)
      ..lineTo(3.2, 10.65)
      ..quadraticBezierTo(3.2, 9.7, 3.85, 9.15)
      ..close();

    if (active) {
      house.fillType = PathFillType.evenOdd;
      house.addRRect(
         RRect.fromLTRBAndCorners(
          9.6,
          13.6,
          14.4,
          20.9,
          topLeft: Radius.circular(2.4),
          topRight: Radius.circular(2.4),
        ),
      );
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(house, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(house, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HomePainter oldDelegate) =>
      oldDelegate.active != active || oldDelegate.color != color;
}

class PinterestSearchIcon extends StatelessWidget {
  final bool active;
  final Color color;
  final double size;

  const PinterestSearchIcon({
    super.key,
    this.active = false,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SearchPainter(active: active, color: color),
    );
  }
}

class _SearchPainter extends CustomPainter {
  final bool active;
  final Color color;

  _SearchPainter({required this.active, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 2.6 : 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawCircle(const Offset(10.6, 10.6), 6.7, paint);
    canvas.drawLine(const Offset(15.6, 15.6), const Offset(20.4, 20.4), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SearchPainter oldDelegate) =>
      oldDelegate.active != active || oldDelegate.color != color;
}

class PinterestCreateIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const PinterestCreateIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.strokeWidth = 2.1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CreatePainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _CreatePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _CreatePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(4.8, 12.0), const Offset(19.2, 12.0), paint);
    canvas.drawLine(const Offset(12.0, 4.8), const Offset(12.0, 19.2), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CreatePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class PinterestInboxIcon extends StatelessWidget {
  final bool active;
  final Color color;
  final double size;

  const PinterestInboxIcon({
    super.key,
    required this.active,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _InboxPainter(active: active, color: color),
    );
  }
}

class _InboxPainter extends CustomPainter {
  final bool active;
  final Color color;

  _InboxPainter({required this.active, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale);

    final bubble = Path()
      ..moveTo(12.0, 3.1)
      ..cubicTo(17.1, 3.1, 21.0, 6.65, 21.0, 11.2)
      ..cubicTo(21.0, 15.75, 17.1, 19.3, 12.0, 19.3)
      ..cubicTo(10.65, 19.3, 9.4, 19.05, 8.25, 18.6)
      ..lineTo(4.3, 20.6)
      ..quadraticBezierTo(3.75, 20.85, 3.95, 20.25)
      ..lineTo(5.15, 16.55)
      ..cubicTo(3.8, 15.15, 3.0, 13.25, 3.0, 11.2)
      ..cubicTo(3.0, 6.65, 6.9, 3.1, 12.0, 3.1)
      ..close();

    if (active) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(bubble, fillPaint);

      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(8.4, 11.2), 1.15, dotPaint);
      canvas.drawCircle(const Offset(12.0, 11.2), 1.15, dotPaint);
      canvas.drawCircle(const Offset(15.6, 11.2), 1.15, dotPaint);
    } else {
      final strokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(bubble, strokePaint);

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(8.4, 11.2), 1.05, dotPaint);
      canvas.drawCircle(const Offset(12.0, 11.2), 1.05, dotPaint);
      canvas.drawCircle(const Offset(15.6, 11.2), 1.05, dotPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InboxPainter oldDelegate) =>
      oldDelegate.active != active || oldDelegate.color != color;
}

class PinterestBellIcon extends StatelessWidget {
  final bool active;
  final Color color;
  final double size;

  const PinterestBellIcon({
    super.key,
    required this.active,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BellPainter(active: active, color: color),
    );
  }
}

class _BellPainter extends CustomPainter {
  final bool active;
  final Color color;

  _BellPainter({required this.active, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale);

    final bellBody = Path()
      ..moveTo(12.0, 3.0)
      ..cubicTo(8.5, 3.0, 6.2, 5.55, 6.2, 9.25)
      ..lineTo(6.2, 13.45)
      ..cubicTo(6.2, 14.75, 5.45, 15.85, 4.4, 16.55)
      ..quadraticBezierTo(3.9, 16.9, 4.1, 17.45)
      ..quadraticBezierTo(4.25, 17.85, 4.8, 17.85)
      ..lineTo(19.2, 17.85)
      ..quadraticBezierTo(19.75, 17.85, 19.9, 17.45)
      ..quadraticBezierTo(20.1, 16.9, 19.6, 16.55)
      ..cubicTo(18.55, 15.85, 17.8, 14.75, 17.8, 13.45)
      ..lineTo(17.8, 9.25)
      ..cubicTo(17.8, 5.55, 15.5, 3.0, 12.0, 3.0)
      ..close();

    if (active) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(bellBody, fillPaint);

      final clapperPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.1
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        const Rect.fromLTWH(9.6, 17.8, 4.8, 3.2),
        0.15,
        2.84,
        false,
        clapperPaint,
      );
    } else {
      final strokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(bellBody, strokePaint);
      canvas.drawArc(
        const Rect.fromLTWH(9.8, 17.8, 4.4, 3.0),
        0.15,
        2.84,
        false,
        strokePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BellPainter oldDelegate) =>
      oldDelegate.active != active || oldDelegate.color != color;
}

/// Subtle iOS tactile scale feedback on tap without Material ink ripple clutter.
class TactileScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double pressedScale;

  const TactileScaleTap({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.90,
  });

  @override
  State<TactileScaleTap> createState() => _TactileScaleTapState();
}

class _TactileScaleTapState extends State<TactileScaleTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
