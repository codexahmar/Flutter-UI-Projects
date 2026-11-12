import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/models/product.dart';
import '../widgets/circular_icon_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/hero_featured_card.dart';

class HeroPromoScreen extends StatelessWidget {
  final Product heroProduct;
  final VoidCallback onBack;
  final VoidCallback onShopMore;
  final VoidCallback onSelectHeroProduct;

  const HeroPromoScreen({
    super.key,
    required this.heroProduct,
    required this.onBack,
    required this.onShopMore,
    required this.onSelectHeroProduct,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularIconButton(
                    icon: CupertinoIcons.arrow_left,
                    onTap: onBack,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    iconColor: Colors.white,
                    hasShadow: false,
                  ),
                  CircularIconButton(
                    icon: CupertinoIcons.bag,
                    badgeText: '1',
                    badgeColor: Colors.white,
                    badgeTextColor: AppColors.forestGreen,
                    onTap: onSelectHeroProduct,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    iconColor: Colors.white,
                    hasShadow: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Sculpted Form,\nEnduring Comfort',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: HeroFeaturedCard(
                  product: heroProduct,
                  onTap: onSelectHeroProduct,
                ),
              ),
              const SizedBox(height: 38),
              CustomButton(
                text: 'Explore Collection',
                onPressed: onShopMore,
                backgroundColor: Colors.white,
                textColor: AppColors.pureBlack,
              ),
              SizedBox(height: bottomPadding > 0 ? bottomPadding + 10 : 24),
            ],
          ),
        ),
      ),
    );
  }
}
