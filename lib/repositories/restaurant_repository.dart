import 'dart:async';
import '../models/restaurant.dart';
import '../models/menu_item.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class RestaurantRepository {
  Future<List<Restaurant>> fetchRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _restaurants;
  }

  Future<List<MenuItem>> fetchMenu(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final menu = _menus.where((m) => m.restaurantId == restaurantId).toList();
    if (menu.isEmpty) {
      throw NetworkException('Menu not found for restaurant');
    }
    return menu;
  }
}

final List<Restaurant> _restaurants = [
  Restaurant(
    id: 'r1',
    name: 'Spice Villa',
    cuisine: 'Indian',
    rating: 4.5,
    imagePath: 'assets/restaurant1.jpg',
  ),
  Restaurant(
    id: 'r2',
    name: 'Pasta Palace',
    cuisine: 'Italian',
    rating: 4.3,
    imagePath: 'assets/restaurant1.jpg',
  ),
  Restaurant(
    id: 'r3',
    name: 'Sushi Central',
    cuisine: 'Japanese',
    rating: 4.7,
    imagePath: 'assets/restaurant1.jpg',
  ),
];

final List<MenuItem> _menus = [
  MenuItem(
    id: 'm1',
    restaurantId: 'r1',
    name: 'Butter Chicken',
    description: 'Creamy tomato gravy',
    price: 8.5,
  ),
  MenuItem(
    id: 'm2',
    restaurantId: 'r1',
    name: 'Paneer Tikka',
    description: 'Smoky grilled paneer',
    price: 7.0,
  ),
  MenuItem(
    id: 'm3',
    restaurantId: 'r2',
    name: 'Spaghetti Carbonara',
    description: 'Pancetta & parmesan',
    price: 9.0,
  ),
  MenuItem(
    id: 'm4',
    restaurantId: 'r2',
    name: 'Margherita Pizza',
    description: 'Fresh basil & mozzarella',
    price: 11.0,
  ),
  MenuItem(
    id: 'm5',
    restaurantId: 'r3',
    name: 'Salmon Nigiri',
    description: 'Two pieces of fresh salmon',
    price: 6.5,
  ),
];
