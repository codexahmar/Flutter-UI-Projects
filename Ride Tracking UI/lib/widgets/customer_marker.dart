import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

/// Custom-painted waiting human marker for the primary customer and nearby riders.
class CustomerMarker extends StatefulWidget {
  final bool isPrimary;
  final bool isPulsing;
  final String? callout;
  final String semanticLabel;

  const CustomerMarker({
    super.key,
    this.isPrimary = true,
    this.isPulsing = false,
    this.callout,
    this.semanticLabel = 'Your pickup location',
  });

  static const double width = 112;
  static const double height = 76;
  static const Offset anchorOffset = Offset(width / 2, height - 18);

  @override
  State<CustomerMarker> createState() => _CustomerMarkerState();
}

class _CustomerMarkerState extends State<CustomerMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant CustomerMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPulsing != widget.isPulsing) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    final active =
        widget.isPrimary &&
        widget.isPulsing &&
        !MediaQuery.disableAnimationsOf(context);
    if (active) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPrimary) {
      return Semantics(
        label: widget.semanticLabel,
        excludeSemantics: true,
        child: const SizedBox(
          width: 28,
          height: 36,
          child: CustomPaint(painter: _HumanPainter(isPrimary: false)),
        ),
      );
    }

    return Semantics(
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: CustomerMarker.width,
        height: CustomerMarker.height,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              child: CustomPaint(
                size: const Size(64, 36),
                painter: _GroundRipplePainter(progress: _pulse),
              ),
            ),
            const Positioned(
              bottom: 12,
              child: RepaintBoundary(
                child: SizedBox(
                  width: 36,
                  height: 44,
                  child: CustomPaint(painter: _HumanPainter(isPrimary: true)),
                ),
              ),
            ),
            if (widget.callout != null)
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RideSpacing.sm,
                    vertical: RideSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: RideColors.surface,
                    borderRadius: BorderRadius.circular(RideRadius.pill),
                    border: Border.all(color: RideColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: RideColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.callout!,
                    style: RideText.captionTabular,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GroundRipplePainter extends CustomPainter {
  final Animation<double> progress;

  _GroundRipplePainter({required this.progress}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0) return;

    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = RideColors.accent.withValues(alpha: (1 - t) * 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: 22 + t * 34, height: 12 + t * 18),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GroundRipplePainter oldDelegate) => false;
}

class _HumanPainter extends CustomPainter {
  final bool isPrimary;

  const _HumanPainter({required this.isPrimary});

  static final _shadowPaint = Paint()..color = RideColors.shadow;
  static final _padPaint = Paint()..color = RideColors.accent;
  static final _padRingPaint = Paint()
    ..color = RideColors.textPrimary
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.8;
  static final _ambientPadPaint = Paint()
    ..color = RideColors.ambientRider.withValues(alpha: 0.35);

  static final _skinPaint = Paint()..color = RideColors.customerSkin;
  static final _hairPaint = Paint()..color = RideColors.customerHair;
  static final _primaryCoatPaint = Paint()..color = RideColors.textPrimary;
  static final _ambientCoatPaint = Paint()..color = RideColors.ambientRider;
  static final _trouserPaint = Paint()..color = RideColors.carCabin;
  static final _outlinePaint = Paint()
    ..color = RideColors.mapRoadCasing
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.1;
  static final _accentStripePaint = Paint()
    ..color = RideColors.accent
    ..strokeWidth = 1.6
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final footY = size.height - 6;

    canvas.save();
    canvas.translate(cx, footY);
    if (!isPrimary) {
      canvas.scale(0.72);
    }

    // Ground pad / base shadow
    final padRect = Rect.fromCenter(
      center: Offset.zero,
      width: 18,
      height: 10,
    );
    canvas.drawOval(padRect.translate(0, 1.5), _shadowPaint);
    canvas.drawOval(padRect, isPrimary ? _padPaint : _ambientPadPaint);
    if (isPrimary) {
      canvas.drawOval(padRect, _padRingPaint);
    }

    // Legs / stance
    final legs = Path()
      ..moveTo(-4.0, -11.5)
      ..lineTo(-3.4, -0.5)
      ..lineTo(-0.7, -0.5)
      ..lineTo(-0.2, -8.5)
      ..lineTo(0.2, -8.5)
      ..lineTo(0.7, -0.5)
      ..lineTo(3.4, -0.5)
      ..lineTo(4.0, -11.5)
      ..close();
    canvas.drawPath(legs, _trouserPaint);

    // Coat / torso with gentle waving/phone-raised right arm on primary customer
    final coat = Path()
      ..moveTo(-5.8, -11.0)
      ..lineTo(-6.6, -19.5)
      ..quadraticBezierTo(-6.5, -23.0, -2.8, -23.4)
      ..lineTo(2.8, -23.4)
      ..quadraticBezierTo(6.5, -23.0, 7.6, -20.5);

    if (isPrimary) {
      coat
        ..lineTo(10.8, -24.5)
        ..quadraticBezierTo(12.0, -25.4, 12.8, -24.0)
        ..lineTo(8.5, -17.5)
        ..lineTo(5.6, -17.2)
        ..lineTo(5.2, -11.0)
        ..close();
    } else {
      coat
        ..lineTo(6.6, -19.5)
        ..lineTo(5.8, -11.0)
        ..close();
    }

    canvas.drawPath(coat, isPrimary ? _primaryCoatPaint : _ambientCoatPaint);
    canvas.drawPath(coat, _outlinePaint);

    // Accent collar/stripe detail on primary customer
    if (isPrimary) {
      canvas.drawLine(
        const Offset(0, -23.0),
        const Offset(0, -14.0),
        _accentStripePaint,
      );
    }

    // Head & hair
    const headCenter = Offset(0, -27.8);
    canvas.drawCircle(
      headCenter,
      4.5,
      isPrimary ? _skinPaint : _ambientCoatPaint,
    );
    canvas.drawCircle(headCenter, 4.5, _outlinePaint);

    if (isPrimary) {
      final hair = Path()
        ..addArc(
          Rect.fromCircle(center: headCenter, radius: 4.5),
          3.1,
          3.2,
        );
      canvas.drawPath(hair, _hairPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HumanPainter oldDelegate) {
    return oldDelegate.isPrimary != isPrimary;
  }
}
