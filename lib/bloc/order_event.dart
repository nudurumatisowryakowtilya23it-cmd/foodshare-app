part of 'order_bloc.dart';

abstract class OrderEvent {}

class LoadRestaurants extends OrderEvent {}

class SelectRestaurant extends OrderEvent {
  final Restaurant restaurant;
  SelectRestaurant(this.restaurant);
}

class AddToCart extends OrderEvent {
  final MenuItem menu;
  AddToCart(this.menu);
}

class RemoveFromCart extends OrderEvent {
  final String menuItemId;
  RemoveFromCart(this.menuItemId);
}

class ChangeQuantity extends OrderEvent {
  final String menuItemId;
  final int quantity;
  ChangeQuantity(this.menuItemId, this.quantity);
}

class Checkout extends OrderEvent {}

class ResetOrder extends OrderEvent {}
