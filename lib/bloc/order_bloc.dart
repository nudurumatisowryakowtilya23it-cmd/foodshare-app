import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/restaurant_repository.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final RestaurantRepository repository;

  OrderBloc({required this.repository}) : super(const OrderState.initial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SelectRestaurant>(_onSelectRestaurant);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ChangeQuantity>(_onChangeQuantity);
    on<Checkout>(_onCheckout);
    on<ResetOrder>(_onResetOrder);
  }

  Future<void> _onLoadRestaurants(
      LoadRestaurants event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final data = await repository.fetchRestaurants();
      emit(state.copyWith(
          status: OrderStatus.restaurantsLoaded, restaurants: data));
    } catch (e) {
      emit(state.copyWith(
          status: OrderStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSelectRestaurant(
      SelectRestaurant event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final menu = await repository.fetchMenu(event.restaurant.id);
      emit(state.copyWith(
          status: OrderStatus.menuLoaded,
          selectedRestaurant: event.restaurant,
          menu: menu));
    } catch (e) {
      emit(state.copyWith(
          status: OrderStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onAddToCart(AddToCart event, Emitter<OrderState> emit) {
    final items = List<CartItem>.from(state.cart);
    final index = items.indexWhere((c) => c.menuItemId == event.menu.id);

    if (index != -1) {
      final existing = items[index];
      items[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      items.add(CartItem(
          menuItemId: event.menu.id,
          name: event.menu.name,
          price: event.menu.price,
          quantity: 1));
    }

    emit(state.copyWith(cart: items, status: OrderStatus.cartUpdated));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<OrderState> emit) {
    final items =
        state.cart.where((c) => c.menuItemId != event.menuItemId).toList();
    emit(state.copyWith(cart: items, status: OrderStatus.cartUpdated));
  }

  void _onChangeQuantity(ChangeQuantity event, Emitter<OrderState> emit) {
    final items = state.cart.map((c) {
      if (c.menuItemId == event.menuItemId) {
        return c.copyWith(quantity: event.quantity);
      }
      return c;
    }).toList();

    emit(state.copyWith(cart: items, status: OrderStatus.cartUpdated));
  }

  Future<void> _onCheckout(Checkout event, Emitter<OrderState> emit) async {
    if (state.cart.isEmpty) {
      emit(state.copyWith(
          status: OrderStatus.failure, errorMessage: 'Cart is empty'));
      return;
    }
    emit(state.copyWith(status: OrderStatus.loading));
    await Future.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(status: OrderStatus.confirmed));
  }

  void _onResetOrder(ResetOrder event, Emitter<OrderState> emit) {
    emit(const OrderState.initial());
  }
}
