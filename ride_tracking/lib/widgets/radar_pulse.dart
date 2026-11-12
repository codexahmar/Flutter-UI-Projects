import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

/// Minimal searching pulse indicator that respects reduced-motion preferences.
class RadarPulse extends StatefulWidget {
  const RadarPulse({super.key});

  @override
  State<RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<RadarPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0.35;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(
        painter: _RadarPainter(progress: _controller),
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: RideColors.accent,
              boxShadow: [
                BoxShadow(
                  color: RideColors.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_searching_rounded,
              color: RideColors.inkOnAccent,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Animation<double> progress;

  _RadarPainter({required this.progress}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 2; i++) {
      final t = (progress.value + i * 0.5) % 1.0;
      final radius = 28 + t * 52;
      ringPaint.color = RideColors.accent.withValues(alpha: (1 - t) * 0.35);
      canvas.drawCircle(center, radius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => false;
}

