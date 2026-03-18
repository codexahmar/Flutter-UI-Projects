import 'package:flutter/material.dart';

class CryptoIconAvatar extends StatelessWidget {
  const CryptoIconAvatar({
    super.key,
    required this.symbol,
    required this.brandColor,
    this.iconUrl,
    this.size = 42,
  });

  final String symbol;
  final Color brandColor;
  final String? iconUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasUrl = iconUrl != null && iconUrl!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: brandColor.withValues(alpha: 0.14),
      ),
      alignment: Alignment.center,
      child: hasUrl
          ? ClipOval(
              child: Image.network(
                iconUrl!,
                width: size * 0.74,
                height: size * 0.74,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _FallbackSymbol(
                    symbol: symbol,
                    brandColor: brandColor,
                  );
                },
              ),
            )
          : _FallbackSymbol(symbol: symbol, brandColor: brandColor),
    );
  }
}

class _FallbackSymbol extends StatelessWidget {
  const _FallbackSymbol({required this.symbol, required this.brandColor});

  final String symbol;
  final Color brandColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol.substring(0, 1),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: brandColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
