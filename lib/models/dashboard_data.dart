import 'package:flutter/material.dart';

/// A kitchen category shown in the dashboard's horizontal strip.
class FoodCategory {
  const FoodCategory({
    required this.name,
    required this.count,
    required this.icon,
    required this.tint,
  });

  final String name;
  final int count;

  /// Icon artwork from assets/icons, and the pale square it sits on.
  final String icon;
  final Color tint;
}

/// A dish with today's order count.
class FoodOrder {
  const FoodOrder({
    required this.name,
    required this.description,
    required this.price,
    required this.orders,
    required this.image,
  });

  final String name;
  final String description;
  final int price;
  final int orders;

  /// Dish photo from assets/images/food.
  final String image;
}

/// The greeting for [hour] on a 24-hour clock.
String greetingForHour(int hour) {
  if (hour < 12) return 'GOOD MORNING';
  if (hour < 17) return 'GOOD AFTERNOON';
  return 'GOOD EVENING';
}

/// Sample content, standing in until the kitchen API is wired up.
const List<FoodCategory> kCategories = [
  FoodCategory(
    name: 'Breakfasts',
    count: 12,
    icon: 'assets/icons/cat_breakfast.png',
    tint: Color(0xFFFFF6DA),
  ),
  FoodCategory(
    name: 'Lunch',
    count: 8,
    icon: 'assets/icons/cat_lunch.svg',
    tint: Color(0xFFFFF1E3),
  ),
  FoodCategory(
    name: 'Snacks',
    count: 15,
    icon: 'assets/icons/cat_snacks.svg',
    tint: Color(0xFFFFE9ED),
  ),
  FoodCategory(
    name: 'Drinks',
    count: 6,
    icon: 'assets/icons/cat_drinks.png',
    tint: Color(0xFFE4F4FE),
  ),
  FoodCategory(
    name: 'Ice Creams',
    count: 4,
    icon: 'assets/icons/cat_icecream.png',
    tint: Color(0xFFF5EBFE),
  ),
];

const List<FoodOrder> kOrders = [
  FoodOrder(
    name: 'Idli Sambar',
    description: 'Steamed rice cakes with spicy lentil soup',
    price: 40,
    orders: 24,
    image: 'assets/images/food/idli_sambar.jpg',
  ),
  FoodOrder(
    name: 'Masala Dosa',
    description: 'Crispy crepe with spiced potato fill',
    price: 50,
    orders: 18,
    image: 'assets/images/food/masala_dosa.jpg',
  ),
  FoodOrder(
    name: 'Veg Upma',
    description: 'Roasted semolina with fresh veggies',
    price: 35,
    orders: 11,
    image: 'assets/images/food/veg_upma.jpg',
  ),
  FoodOrder(
    name: 'Ven Pongal',
    description: 'Savory rice and moong dal porridge',
    price: 45,
    orders: 9,
    image: 'assets/images/food/ven_pongal.jpg',
  ),
  FoodOrder(
    name: 'Poha',
    description: 'Flattened rice cooked with herbs & nuts',
    price: 30,
    orders: 14,
    image: 'assets/images/food/poha.jpg',
  ),
];

/// Total shown next to "Today's Orders".
int get kTotalOrders => kOrders.fold(0, (sum, order) => sum + order.orders);
