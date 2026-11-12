import 'package:flutter/material.dart';

/// Menu dish model displayed across discovery, checkout, and tracking.
class FoodItem {
  final String name;
  final String restaurant;
  final String description;
  final String price;
  final int priceValue;
  final String eta;
  final double rating;
  final String imageUrl;
  final String promoLabel;
  final String category;
  final List<FoodAddon> addOns;
  final String distance;

  const FoodItem({
    required this.name,
    required this.restaurant,
    required this.description,
    required this.price,
    required this.priceValue,
    required this.eta,
    required this.rating,
    required this.imageUrl,
    required this.promoLabel,
    required this.category,
    required this.addOns,
    required this.distance,
  });
}

/// Paid add-on option belonging to a menu dish.
class FoodAddon {
  final String label;
  final int price;

  const FoodAddon(this.label, this.price);
}

/// Featured restaurant entry in the discovery carousel.
class RestaurantSpot {
  final String name;
  final String cuisine;
  final String eta;
  final String distance;
  final String imageUrl;
  final double rating;

  const RestaurantSpot({
    required this.name,
    required this.cuisine,
    required this.eta,
    required this.distance,
    required this.imageUrl,
    required this.rating,
  });
}

/// Filter category chip metadata.
class FoodCategory {
  final String label;
  final IconData icon;

  const FoodCategory(this.label, this.icon);
}
