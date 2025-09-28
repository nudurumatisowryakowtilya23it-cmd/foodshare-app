part of 'order_bloc.dart';

enum OrderStatus { initial, loading, restaurantsLoaded, menuLoaded, cartUpdated, confirmed, failure }

class OrderState extends Equatable {
  final OrderStatus status;
  final List<Restaurant> restaurants;
  final Restaurant? selectedRestaurant;
  final List<MenuItem> menu;
  final List<CartItem> cart;
  final String? errorMessage;

  const OrderState({
    required this.status,
    this.restaurants = const [],
    this.selectedRestaurant,
    this.menu = const [],
    this.cart = const [],
    this.errorMessage,
  });

  const OrderState.initial() : this(status: OrderStatus.initial);

  OrderState copyWith({
    OrderStatus? status,
    List<Restaurant>? restaurants,
    Restaurant? selectedRestaurant,
    List<MenuItem>? menu,
    List<CartItem>? cart,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      menu: menu ?? this.menu,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, restaurants, selectedRestaurant, menu, cart, errorMessage];
}
