import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/product_detail_controller.dart';

class BuyActionButton extends StatelessWidget {
  final BuyState buyState;
  final int totalPrice;
  final VoidCallback onPressed;

  const BuyActionButton({
    super.key,
    required this.buyState,
    required this.totalPrice,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (buyState == BuyState.purchased) {
      return Container(
        key: const ValueKey('purchased'),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.forestGreen,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.checkmark_alt,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Order Confirmed',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (buyState == BuyState.continueShopping) {
      return GestureDetector(
        key: const ValueKey('continue'),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.pureBlack,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                CupertinoIcons.arrow_right,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      key: const ValueKey('buy'),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.pureBlack,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            'Buy for \$$totalPrice',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
