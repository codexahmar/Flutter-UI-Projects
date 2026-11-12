import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/screens/delivery_tracking_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';
import 'package:ai_food_delivery/widgets/quantity_stepper.dart';

/// Light-surface checkout screen harmonized to Warm Ivory, Deep Espresso, and Terracotta.
class OrderConfirmationScreen extends StatefulWidget {
  final FoodItem food;

  const OrderConfirmationScreen({
    super.key,
    required this.food,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  static const int _deliveryFee = 180;
  static const int _promoAmount = 150;

  final Set<int> _selectedAddOnIndices = {0};
  int _quantity = 1;
  bool _leaveAtDoor = true;
  bool _applyPromo = true;

  int get _addOnSubtotal => _selectedAddOnIndices.fold(
        0,
        (sum, index) => sum + widget.food.addOns[index].price,
      );

  int get _subtotal => (widget.food.priceValue + _addOnSubtotal) * _quantity;
  int get _discount => _applyPromo ? _promoAmount : 0;
  int get _total => (_subtotal + _deliveryFee - _discount).clamp(0, 999999);

  void _toggleAddOn(int index) {
    setState(() {
      if (_selectedAddOnIndices.contains(index)) {
        _selectedAddOnIndices.remove(index);
      } else {
        _selectedAddOnIndices.add(index);
      }
    });
  }

  void _placeOrder() {
    Navigator.of(context).pushReplacement<bool, bool>(
      MaterialPageRoute(
        builder: (_) => DeliveryTrackingScreen(food: widget.food),
      ),
      result: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: FoodColors.canvas,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FoodSpacing.sm),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(FoodRadius.pill),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: FoodColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: FoodColors.border),
                ),
                child: const Icon(
                  CupertinoIcons.back,
                  size: 18,
                  color: FoodColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkout', style: FoodText.title),
            Text(
              widget.food.restaurant,
              style: FoodText.caption,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                FoodSpacing.lg,
                FoodSpacing.md,
                FoodSpacing.lg,
                FoodSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: FoodColors.accentTint,
                                borderRadius:
                                    BorderRadius.circular(FoodRadius.sm),
                              ),
                              child: const Icon(
                                CupertinoIcons.location_solid,
                                color: FoodColors.accent,
                                size: 19,
                              ),
                            ),
                            const SizedBox(width: FoodSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'House 12, Street 8 · F-10/3',
                                    style: FoodText.title,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Estimated arrival · ${widget.food.eta}',
                                    style: FoodText.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: FoodSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: FoodColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(FoodRadius.pill),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _HandoffOption(
                                  label: 'Leave at door',
                                  isSelected: _leaveAtDoor,
                                  onTap: () =>
                                      setState(() => _leaveAtDoor = true),
                                ),
                              ),
                              Expanded(
                                child: _HandoffOption(
                                  label: 'Meet at door',
                                  isSelected: !_leaveAtDoor,
                                  onTap: () =>
                                      setState(() => _leaveAtDoor = false),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.md),
                  _SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(FoodRadius.sm),
                              child: FoodNetworkImage(
                                imageUrl: widget.food.imageUrl,
                                width: 64,
                                height: 64,
                              ),
                            ),
                            const SizedBox(width: FoodSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.food.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: FoodText.title.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.food.price,
                                    style: FoodText.tabular.copyWith(
                                      color: FoodColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: FoodSpacing.sm),
                            QuantityStepper(
                              quantity: _quantity,
                              onDecrement: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              onIncrement: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                        if (widget.food.addOns.isNotEmpty) ...[
                          const SizedBox(height: FoodSpacing.lg),
                          const Divider(),
                          const SizedBox(height: FoodSpacing.md),
                          Text(
                            'Add extras',
                            style: FoodText.title.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: FoodSpacing.xs),
                          ...List.generate(widget.food.addOns.length, (index) {
                            final addOn = widget.food.addOns[index];
                            final selected =
                                _selectedAddOnIndices.contains(index);
                            return InkWell(
                              onTap: () => _toggleAddOn(index),
                              borderRadius:
                                  BorderRadius.circular(FoodRadius.sm),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: FoodSpacing.sm,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      selected
                                          ? CupertinoIcons.checkmark_circle_fill
                                          : CupertinoIcons.circle,
                                      size: 20,
                                      color: selected
                                          ? FoodColors.accent
                                          : FoodColors.textSecondary,
                                    ),
                                    const SizedBox(width: FoodSpacing.md),
                                    Expanded(
                                      child: Text(
                                        addOn.label,
                                        style: FoodText.body,
                                      ),
                                    ),
                                    Text(
                                      '+Rs. ${addOn.price}',
                                      style: FoodText.tabular.copyWith(
                                        fontSize: 13,
                                        color: selected
                                            ? FoodColors.textPrimary
                                            : FoodColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.md),
                  _SurfaceCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.creditcard_fill,
                              size: 18,
                              color: FoodColors.textPrimary,
                            ),
                            const SizedBox(width: FoodSpacing.md),
                            Expanded(
                              child: Text(
                                'Apple Pay · •••• 4242',
                                style: FoodText.body,
                              ),
                            ),
                            Text(
                              'Default',
                              style: FoodText.caption.copyWith(
                                color: FoodColors.accentInk,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: FoodSpacing.md),
                        const Divider(),
                        const SizedBox(height: FoodSpacing.sm),
                        InkWell(
                          onTap: () =>
                              setState(() => _applyPromo = !_applyPromo),
                          borderRadius: BorderRadius.circular(FoodRadius.sm),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: FoodSpacing.xs,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.tag_fill,
                                  size: 17,
                                  color: _applyPromo
                                      ? FoodColors.accent
                                      : FoodColors.textSecondary,
                                ),
                                const SizedBox(width: FoodSpacing.md),
                                Expanded(
                                  child: Text(
                                    _applyPromo
                                        ? 'CRAVE150 applied (-Rs. $_promoAmount)'
                                        : 'Apply promo CRAVE150 (-Rs. $_promoAmount)',
                                    style: FoodText.body.copyWith(
                                      color: _applyPromo
                                          ? FoodColors.accentInk
                                          : FoodColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _applyPromo
                                      ? CupertinoIcons.checkmark_circle_fill
                                      : CupertinoIcons.plus_circle,
                                  size: 18,
                                  color: _applyPromo
                                      ? FoodColors.accent
                                      : FoodColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.md),
                  _SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order summary',
                          style: FoodText.title.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: FoodSpacing.md),
                        _BillRow(label: 'Subtotal', value: 'Rs. $_subtotal'),
                        const SizedBox(height: FoodSpacing.sm),
                        const _BillRow(
                          label: 'Delivery fee',
                          value: 'Rs. $_deliveryFee',
                        ),
                        if (_applyPromo) ...[
                          const SizedBox(height: FoodSpacing.sm),
                          const _BillRow(
                            label: 'Promo discount',
                            value: '-Rs. $_promoAmount',
                            valueColor: FoodColors.accentInk,
                          ),
                        ],
                        const SizedBox(height: FoodSpacing.md),
                        const Divider(),
                        const SizedBox(height: FoodSpacing.md),
                        _BillRow(
                          label: 'Total',
                          value: 'Rs. $_total',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              FoodSpacing.lg,
              FoodSpacing.md,
              FoodSpacing.lg,
              bottomPadding + FoodSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: FoodColors.surface,
              border: Border(top: BorderSide(color: FoodColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _placeOrder,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Place order · '),
                    Text(
                      'Rs. $_total',
                      style: FoodText.tabular.copyWith(
                        color: FoodColors.inkOnAccent,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FoodSpacing.lg),
      decoration: BoxDecoration(
        color: FoodColors.surface,
        borderRadius: BorderRadius.circular(FoodRadius.md),
        border: Border.all(color: FoodColors.border),
        boxShadow: const [
          BoxShadow(
            color: FoodColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HandoffOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _HandoffOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? FoodColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(FoodRadius.pill),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: FoodColors.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: FoodText.caption.copyWith(
            fontSize: 13,
            color: isSelected ? FoodColors.textPrimary : FoodColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _BillRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: isTotal
                ? FoodText.title.copyWith(fontSize: 16)
                : FoodText.body.copyWith(color: FoodColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: FoodText.tabular.copyWith(
            fontSize: isTotal ? 17 : 14,
            color: valueColor ?? FoodColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
