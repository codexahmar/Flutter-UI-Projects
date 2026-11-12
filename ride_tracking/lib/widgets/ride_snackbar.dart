import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

typedef RideNotice = ({
  int id,
  String title,
  String? subtitle,
  IconData icon,
  String? tag,
  bool isMuted,
});

/// Notification-style top snackbar banner anchored cleanly along the screen rails.
class RideSnackbar extends StatelessWidget {
  final RideNotice? notice;
  final VoidCallback onDismiss;

  const RideSnackbar({
    super.key,
    required this.notice,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final current = notice;

    return AnimatedSwitcher(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) {
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.25),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        );
      },
      child: current == null
          ? const SizedBox.shrink(key: ValueKey('no_notice'))
          : _NotificationBanner(
              key: ValueKey('notice_${current.id}'),
              notice: current,
              onDismiss: onDismiss,
            ),
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  final RideNotice notice;
  final VoidCallback onDismiss;

  const _NotificationBanner({
    super.key,
    required this.notice,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = notice.isMuted
        ? RideColors.border
        : RideColors.accentBorder;
    final badgeBg = notice.isMuted
        ? RideColors.surface
        : RideColors.accentTint;
    final iconColor = notice.isMuted
        ? RideColors.textSecondary
        : RideColors.accent;
    final labelText = notice.subtitle == null
        ? notice.title
        : '${notice.title}, ${notice.subtitle}';

    return Semantics(
      liveRegion: true,
      label: labelText,
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: RideSpacing.md,
            vertical: RideSpacing.md,
          ),
          decoration: BoxDecoration(
            color: RideColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(RideRadius.lg),
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: RideColors.shadow,
                blurRadius: 22,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(RideRadius.sm),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(notice.icon, size: 17, color: iconColor),
              ),
              const SizedBox(width: RideSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      notice.title,
                      style: RideText.body.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notice.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        notice.subtitle!,
                        style: RideText.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (notice.tag != null) ...[
                const SizedBox(width: RideSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RideSpacing.md,
                    vertical: RideSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(RideRadius.pill),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    notice.tag!,
                    style: RideText.captionTabular.copyWith(
                      color: notice.isMuted
                          ? RideColors.textSecondary
                          : RideColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
