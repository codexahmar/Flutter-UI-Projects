import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/screens/delivery_tracking_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';
import 'package:ai_food_delivery/widgets/quantity_stepper.dart';

/// Order summary and customization screen prior to live tracking.
class OrderConfirmationScreen extends StatefulWidget {
  final FoodItem food;

  const OrderConfirmationScreen({super.key, required this.food});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int _quantity = 1;
  bool _submitting = false;
  final Set<int> _selectedAddons = {0};

  int get _baseSubtotal => widget.food.priceValue * _quantity;

  int get _addonsSubtotal {
    var total = 0;
    for (final index in _selectedAddons) {
      if (index >= 0 && index < widget.food.addOns.length) {
        total += widget.food.addOns[index].price;
      }
    }
    return total;
  }

  static const int _deliveryFee = 120;
  static const int _serviceFee = 49;

  int get _discount => 100 + (_quantity > 1 ? 40 : 0);

  int get _total =>
      (_baseSubtotal + _addonsSubtotal + _deliveryFee + _serviceFee - _discount)
          .clamp(0, 999999);

  void _toggleAddon(int index) {
    setState(() {
      if (!_selectedAddons.remove(index)) {
        _selectedAddons.add(index);
      }
    });
  }

  Future<void> _placeOrder() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DeliveryTrackingScreen(food: widget.food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: Padding(
          padding: const EdgeInsets.only(left: FoodSpacing.sm),
          child: Center(
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            FoodSpacing.lg,
            FoodSpacing.sm,
            FoodSpacing.lg,
            FoodSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: FoodNetworkImage(
                        imageUrl: food.imageUrl,
                        heroTag: 'dish_${food.name}',
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(FoodRadius.lg - 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(FoodSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  food.name,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: FoodSpacing.md),
                              Text(
                                food.price,
                                style: FoodText.tabular.copyWith(
                                  color: FoodColors.accent,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: FoodSpacing.xs),
                          Text(
                            '${food.restaurant} · ${food.eta} · ${food.rating.toStringAsFixed(1)} rating',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: FoodSpacing.sm),
                          Text(
                            food.description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: FoodColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: FoodSpacing.lg),
                          const Divider(),
                          const SizedBox(height: FoodSpacing.md),
                          Row(
                            children: [
                              Text('Quantity', style: textTheme.titleMedium),
                              const Spacer(),
                              QuantityStepper(
                                value: _quantity,
                                onAdd: () => setState(() => _quantity += 1),
                                onRemove: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity -= 1);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (food.addOns.isNotEmpty) ...[
                const SizedBox(height: FoodSpacing.lg),
                _SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add-ons', style: textTheme.titleMedium),
                      const SizedBox(height: FoodSpacing.md),
                      Wrap(
                        spacing: FoodSpacing.sm,
                        runSpacing: FoodSpacing.sm,
                        children: List.generate(food.addOns.length, (index) {
                          final addon = food.addOns[index];
                          final selected = _selectedAddons.contains(index);
                          return _AddonChip(
                            addon: addon,
                            selected: selected,
                            onTap: () => _toggleAddon(index),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: FoodSpacing.lg),
              _SurfaceCard(
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      title: 'Delivery address',
                      value: 'House 12, Street 8, F-10/2 Islamabad',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: FoodSpacing.md),
                      child: Divider(),
                    ),
                    _DetailRow(
                      icon: Icons.credit_card_rounded,
                      title: 'Payment method',
                      value: 'Visa ending 4472',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FoodSpacing.lg),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Summary', style: textTheme.titleMedium),
                    const SizedBox(height: FoodSpacing.md),
                    _PriceRow(label: 'Subtotal', value: 'Rs. $_baseSubtotal'),
                    const SizedBox(height: FoodSpacing.sm),
                    _PriceRow(label: 'Add-ons', value: 'Rs. $_addonsSubtotal'),
                    const SizedBox(height: FoodSpacing.sm),
                    const _PriceRow(
                      label: 'Delivery fee',
                      value: 'Rs. $_deliveryFee',
                    ),
                    const SizedBox(height: FoodSpacing.sm),
                    const _PriceRow(
                      label: 'Service fee',
                      value: 'Rs. $_serviceFee',
                    ),
                    const SizedBox(height: FoodSpacing.sm),
                    _PriceRow(label: 'Promo discount', value: '- Rs. $_discount'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: FoodSpacing.md),
                      child: Divider(),
                    ),
                    _PriceRow(
                      label: 'Total',
                      value: 'Rs. $_total',
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FoodSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _submitting ? null : _placeOrder,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: FoodColors.inkOnAccent,
                          ),
                        )
                      : Text('Place order · Rs. $_total'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(FoodSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: FoodColors.surface,
        borderRadius: BorderRadius.circular(FoodRadius.lg),
        border: Border.all(color: FoodColors.border),
      ),
      child: child,
    );
  }
}

class _AddonChip extends StatelessWidget {
  final FoodAddon addon;
  final bool selected;
  final VoidCallback onTap;

  const _AddonChip({
    required this.addon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FoodColors.accentTint : FoodColors.surfaceSubtle,
      borderRadius: BorderRadius.circular(FoodRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FoodSpacing.md,
            vertical: FoodSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FoodRadius.pill),
            border: Border.all(
              color: selected ? FoodColors.accent : FoodColors.border,
            ),
          ),
          child: Text(
            '${addon.label} · +Rs. ${addon.price}',
            style: FoodText.caption.copyWith(
              color: selected ? FoodColors.accent : FoodColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: FoodColors.textSecondary, size: 20),
        const SizedBox(width: FoodSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: FoodText.caption),
              const SizedBox(height: 2),
              Text(value, style: FoodText.body),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _PriceRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: emphasize
                ? FoodText.title
                : FoodText.body.copyWith(color: FoodColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: FoodText.tabular.copyWith(
            fontSize: emphasize ? 16 : 14,
            color: emphasize ? FoodColors.accent : FoodColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

