String formatCompactCurrency(double value) {
  final absolute = value.abs();
  if (absolute >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (absolute >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(1)}K';
  }

  return '\$${value.toStringAsFixed(2)}';
}

String formatCurrency(double value) {
  final isNegative = value < 0;
  final absValue = value.abs();
  final fixed = absValue.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0];
  final decimals = parts[1];

  final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final formattedWhole = whole.replaceAllMapped(regExp, (Match m) => '${m[1]},');

  return '${isNegative ? '-' : ''}\$$formattedWhole.$decimals';
}
