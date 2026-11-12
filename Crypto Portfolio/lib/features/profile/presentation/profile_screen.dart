import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_controller.dart';
import '../../../core/widgets/animated_entrance.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _biometricsEnabled = true;
  bool _notificationsEnabled = true;
  String _selectedCurrency = 'USD (\$)';

  void _copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Address copied to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = context.watch<AppThemeController>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        // 1. Clean Profile Header Card
        AnimatedEntrance(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              color: colorScheme.surface,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isDark
                      ? AppColors.brandBlue.withValues(alpha: 0.18)
                      : AppColors.brandBlue.withValues(alpha: 0.12),
                  child: Text(
                    'AK',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF60A5FA) : AppColors.brandBlue,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Ahmaryar Khan',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ahmar.khan@cryptovista.io',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'Verified Level 2',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 2. Account Section
        AnimatedEntrance(
          delay: const Duration(milliseconds: 70),
          child: _SectionLabel(title: 'Account'),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 100),
          child: _GroupedSettingsCard(
            children: [
              _SettingsRow(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                subtitle: 'Name, email, phone number',
                onTap: () => _showSnack('Personal details'),
              ),
              const _SettingsDivider(),
              _SettingsRow(
                icon: Icons.verified_user_outlined,
                title: 'Identity Verification',
                subtitle: 'Level 2 • Unlimited trading & deposits',
                trailingText: 'Verified',
                trailingTextColor: const Color(0xFF10B981),
                onTap: () => _showSnack('Identity Verification: Level 2 Verified'),
              ),
              const _SettingsDivider(),
              _SettingsRow(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Primary Wallet',
                subtitle: '0x71C8...49B2',
                trailingIcon: Icons.copy_rounded,
                onTap: () => _copyAddress(
                  context,
                  '0x71C824a68C3202C26e3860F5f7FE0F4bCd3149B2',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3. Security Section
        AnimatedEntrance(
          delay: const Duration(milliseconds: 140),
          child: _SectionLabel(title: 'Security'),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 170),
          child: _GroupedSettingsCard(
            children: [
              _SettingsSwitchRow(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Authentication',
                subtitle: 'Unlock app with Face ID or fingerprint',
                value: _biometricsEnabled,
                onChanged: (val) {
                  setState(() => _biometricsEnabled = val);
                  _showSnack(val ? 'Biometrics enabled' : 'Biometrics disabled');
                },
              ),
              const _SettingsDivider(),
              _SettingsRow(
                icon: Icons.security_rounded,
                title: 'Two-Factor Authentication',
                subtitle: 'Google Authenticator',
                trailingText: 'Active',
                trailingTextColor: const Color(0xFF10B981),
                onTap: () => _showSnack('2FA is active'),
              ),
              const _SettingsDivider(),
              _SettingsRow(
                icon: Icons.lock_outline_rounded,
                title: 'Change Passcode',
                subtitle: 'Update your 6-digit security PIN',
                onTap: () => _showSnack('Change passcode flow'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 4. Preferences Section
        AnimatedEntrance(
          delay: const Duration(milliseconds: 210),
          child: _SectionLabel(title: 'Preferences'),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 240),
          child: _GroupedSettingsCard(
            children: [
              _SettingsRow(
                icon: Icons.attach_money_rounded,
                title: 'Local Currency',
                subtitle: 'Display prices in your currency',
                trailingText: _selectedCurrency,
                onTap: () {
                  setState(() {
                    _selectedCurrency = _selectedCurrency == 'USD (\$)'
                        ? 'EUR (€)'
                        : 'USD (\$)';
                  });
                  _showSnack('Currency changed to $_selectedCurrency');
                },
              ),
              const _SettingsDivider(),
              _SettingsSwitchRow(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Theme',
                subtitle: 'Toggle dark or light color scheme',
                value: themeController.isDarkMode(context),
                onChanged: (val) {
                  themeController.setPreference(
                    val ? AppThemePreference.dark : AppThemePreference.light,
                  );
                },
              ),
              const _SettingsDivider(),
              _SettingsSwitchRow(
                icon: Icons.notifications_none_rounded,
                title: 'Price Alerts & Notifications',
                subtitle: 'Push notifications on market movements',
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 5. Support & Legal Section
        AnimatedEntrance(
          delay: const Duration(milliseconds: 280),
          child: _SectionLabel(title: 'Support & Legal'),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 310),
          child: _GroupedSettingsCard(
            children: [
              _SettingsRow(
                icon: Icons.help_outline_rounded,
                title: 'Help Center & Support',
                onTap: () => _showSnack('Opening Help Center'),
              ),
              const _SettingsDivider(),
              _SettingsRow(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => _showSnack('Terms of Service'),
              ),
              const _SettingsDivider(),
              _SettingsRow(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () => _showSnack('Privacy Policy'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 6. Log Out Button & App Version
        AnimatedEntrance(
          delay: const Duration(milliseconds: 350),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showSnack('Logged out successfully'),
                  icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFEF4444)),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      side: BorderSide(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'CryptoVista v1.0.0 (Build 42)',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _GroupedSettingsCard extends StatelessWidget {
  const _GroupedSettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.5),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailingText,
    this.trailingTextColor,
    this.trailingIcon,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final String? trailingText;
  final Color? trailingTextColor;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : colorScheme.primary.withValues(alpha: 0.08),
              ),
              child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(
                  color: trailingTextColor ?? colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              trailingIcon ?? Icons.chevron_right_rounded,
              size: 18,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : colorScheme.primary.withValues(alpha: 0.08),
            ),
            child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
