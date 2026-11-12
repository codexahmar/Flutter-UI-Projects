import 'package:flutter/cupertino.dart';

import 'package:ai_food_delivery/models/food_item.dart';

const List<FoodItem> kDemoFoods = [
  FoodItem(
    name: 'Son of a Bun Smash',
    restaurant: 'Howdy',
    description:
        'Double smashed beef patties, molten cheddar, caramelized onions, and smoky house sauce.',
    price: 'Rs. 1,190',
    priceValue: 1190,
    eta: '18 min',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '20% off',
    category: 'Burgers',
    addOns: [
      FoodAddon('Extra cheese slice', 110),
      FoodAddon('Curly masala fries', 240),
      FoodAddon('Smoky chipotle dip', 80),
    ],
    distance: '1.2 km',
  ),
  FoodItem(
    name: 'Behari Crown Crust Pizza',
    restaurant: 'Cheezious',
    description:
        'Seekh-kabab stuffed crust topped with spicy behari chicken, onions, and molten cheese.',
    price: 'Rs. 1,650',
    priceValue: 1650,
    eta: '22 min',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1200&q=80',
    promoLabel: 'Bestseller',
    category: 'Pizza',
    addOns: [
      FoodAddon('Garlic mayo dip', 90),
      FoodAddon('Extra mozzarella', 180),
      FoodAddon('Stuffed kabab edge', 220),
    ],
    distance: '0.9 km',
  ),
  FoodItem(
    name: 'Chicken Pulao Kabab',
    restaurant: 'Savour Foods',
    description:
        'Fragrant aged basmati pulao served with two seared shami kababs, mint raita, and kachumber.',
    price: 'Rs. 720',
    priceValue: 720,
    eta: '16 min',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1200&q=80',
    promoLabel: 'Signature',
    category: 'Rice',
    addOns: [
      FoodAddon('Extra shami kabab', 150),
      FoodAddon('Sweet kheer cup', 180),
      FoodAddon('Mint raita', 60),
    ],
    distance: '1.5 km',
  ),
  FoodItem(
    name: 'Crispy Zinger Paratha Roll',
    restaurant: 'Hot n Spicy',
    description:
        'Flaky tandoori paratha loaded with crunchy zinger strips, garlic imli chutney, and onions.',
    price: 'Rs. 490',
    priceValue: 490,
    eta: '15 min',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=1200&q=80',
    promoLabel: 'Hot pick',
    category: 'Rolls',
    addOns: [
      FoodAddon('Cheddar drizzle', 80),
      FoodAddon('Garlic mayo', 60),
      FoodAddon('Extra zinger strip', 140),
    ],
    distance: '0.8 km',
  ),
  FoodItem(
    name: 'Loaded Masala Fries',
    restaurant: 'Ranchers',
    description:
        'Crisp golden fries dusted in Lahore chaat masala with jalapeños and warm ranch cheddar.',
    price: 'Rs. 590',
    priceValue: 590,
    eta: '14 min',
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1576107232684-1279f390859f?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '15% off',
    category: 'Fries',
    addOns: [
      FoodAddon('Smoked chicken bits', 160),
      FoodAddon('Pickled jalapeños', 50),
      FoodAddon('Dynamite sauce', 75),
    ],
    distance: '1.0 km',
  ),
  FoodItem(
    name: 'Mighty Zinger Burger',
    restaurant: 'Ranchers',
    description:
        'Crunchy spiced chicken fillet, double cheddar, crisp lettuce, and creamy herb dressing.',
    price: 'Rs. 850',
    priceValue: 850,
    eta: '17 min',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1606755962773-d324e0a13086?auto=format&fit=crop&w=1200&q=80',
    promoLabel: '25% off',
    category: 'Burgers',
    addOns: [
      FoodAddon('Jalapeño relish', 60),
      FoodAddon('Regular fries', 190),
      FoodAddon('Coleslaw cup', 90),
    ],
    distance: '1.0 km',
  ),
  FoodItem(
    name: 'Mint Margarita',
    restaurant: 'Howdy',
    description:
        'Chilled crushed-ice blend of fresh garden mint, squeezed lime, kala namak, and soda.',
    price: 'Rs. 360',
    priceValue: 360,
    eta: '12 min',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=1200&q=80',
    promoLabel: 'Chilled',
    category: 'Drinks',
    addOns: [
      FoodAddon('Extra lime twist', 30),
      FoodAddon('Large 500ml cup', 90),
    ],
    distance: '1.2 km',
  ),
];

const List<RestaurantSpot> kFeaturedRestaurants = [
  RestaurantSpot(
    name: 'Howdy',
    cuisine: 'Smash burgers · Shakes',
    eta: '18 min',
    distance: '1.2 km',
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=80',
    rating: 4.9,
  ),
  RestaurantSpot(
    name: 'Cheezious',
    cuisine: 'Crown crust · Loaded pizza',
    eta: '22 min',
    distance: '0.9 km',
    imageUrl:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1200&q=80',
    rating: 4.9,
  ),
  RestaurantSpot(
    name: 'Savour Foods',
    cuisine: 'Pulao kabab · Desi fast',
    eta: '16 min',
    distance: '1.5 km',
    imageUrl:
        'https://images.unsplash.com/photo-1589302168068-964664d93dc0?auto=format&fit=crop&w=1200&q=80',
    rating: 4.9,
  ),
];

const List<FoodCategory> kDemoCategories = [
  FoodCategory('All', CupertinoIcons.square_grid_2x2_fill),
  FoodCategory('Burgers', CupertinoIcons.flame_fill),
  FoodCategory('Pizza', CupertinoIcons.circle_grid_hex_fill),
  FoodCategory('Rolls', CupertinoIcons.layers_fill),
  FoodCategory('Rice', CupertinoIcons.tray_fill),
  FoodCategory('Fries', CupertinoIcons.cube_box_fill),
  FoodCategory('Drinks', CupertinoIcons.drop_fill),
];
