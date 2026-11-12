import 'package:flutter/material.dart';

import 'package:ai_food_delivery/models/food_item.dart';

const List<FoodItem> kDemoFoods = [
  FoodItem(
    name: 'Black Label Wagyu Burger',
    restaurant: 'Midnight Grill',
    description: 'Seared wagyu, truffle mayo, aged cheddar, and crisp fries.',
    price: 'Rs. 1,490',
    priceValue: 1490,
    eta: '18 min',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '25% off',
    category: 'Burgers',
    addOns: [
      FoodAddon('Extra cheddar', 80),
      FoodAddon('Truffle dip', 90),
      FoodAddon('Garlic fries', 160),
    ],
    distance: '1.2 km',
  ),
  FoodItem(
    name: 'Creamy Alfredo Pasta',
    restaurant: 'Pasta Lab',
    description: 'Silky parmesan alfredo with grilled chicken and herb oil.',
    price: 'Rs. 1,050',
    priceValue: 1050,
    eta: '22 min',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '15% off',
    category: 'Pasta',
    addOns: [
      FoodAddon('Parmesan crumble', 70),
      FoodAddon('Grilled chicken', 180),
      FoodAddon('Garlic bread', 120),
    ],
    distance: '2.1 km',
  ),
  FoodItem(
    name: 'Stone Oven Pepperoni Pizza',
    restaurant: 'Crust Club',
    description:
        'Thin crust, smoked pepperoni, fresh basil, and molten mozzarella.',
    price: 'Rs. 1,280',
    priceValue: 1280,
    eta: '16 min',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '30% off',
    category: 'Pizza',
    addOns: [
      FoodAddon('Ranch dip', 60),
      FoodAddon('Kalamata olives', 90),
      FoodAddon('Extra mozzarella', 150),
    ],
    distance: '0.9 km',
  ),
  FoodItem(
    name: 'Korean Chili Fries',
    restaurant: 'Snack Station',
    description: 'Crisp fries glazed in sweet chili, sesame, and fresh herbs.',
    price: 'Rs. 620',
    priceValue: 620,
    eta: '14 min',
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1576107232684-1279f390859f?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '12% off',
    category: 'Snacks',
    addOns: [
      FoodAddon('Spicy mayo', 50),
      FoodAddon('Cheese sauce', 95),
      FoodAddon('Pickled jalapeños', 45),
    ],
    distance: '0.7 km',
  ),
  FoodItem(
    name: 'Citrus Mint Cooler',
    restaurant: 'Aroma Bar',
    description: 'Chilled citrus spritz with crushed mint and sparkling soda.',
    price: 'Rs. 390',
    priceValue: 390,
    eta: '10 min',
    rating: 4.6,
    imageUrl:
        'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '2 for 1',
    category: 'Drinks',
    addOns: [
      FoodAddon('Fresh mint', 30),
      FoodAddon('Lime wedge', 25),
      FoodAddon('Ginger splash', 45),
    ],
    distance: '0.5 km',
  ),
  FoodItem(
    name: 'Chargrilled Rice Bowl',
    restaurant: 'Urban Spoon',
    description: 'Warm herb rice bowl with seared chicken and roasted greens.',
    price: 'Rs. 980',
    priceValue: 980,
    eta: '20 min',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',
    promoLabel: 'Free drink',
    category: 'Bowls',
    addOns: [
      FoodAddon('Soft egg', 70),
      FoodAddon('Garlic yogurt', 55),
      FoodAddon('Avocado slice', 140),
    ],
    distance: '1.7 km',
  ),
];

const List<RestaurantSpot> kFeaturedRestaurants = [
  RestaurantSpot(
    name: 'Midnight Grill',
    cuisine: 'Burgers · Steaks',
    eta: '18 min',
    imageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80',
    rating: 4.9,
  ),
  RestaurantSpot(
    name: 'Crust Club',
    cuisine: 'Wood-fired pizza',
    eta: '16 min',
    imageUrl:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',
    rating: 4.8,
  ),
  RestaurantSpot(
    name: 'Pasta Lab',
    cuisine: 'Pasta · Risotto',
    eta: '22 min',
    imageUrl:
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=1200&q=80',
    rating: 4.8,
  ),
];

const List<FoodCategory> kDemoCategories = [
  FoodCategory('All', Icons.grid_view_rounded),
  FoodCategory('Burgers', Icons.lunch_dining_rounded),
  FoodCategory('Pizza', Icons.local_pizza_rounded),
  FoodCategory('Pasta', Icons.ramen_dining_rounded),
  FoodCategory('Snacks', Icons.fastfood_rounded),
  FoodCategory('Drinks', Icons.local_drink_rounded),
  FoodCategory('Bowls', Icons.rice_bowl_rounded),
];

