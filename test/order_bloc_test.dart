import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ordering_workflow/bloc/order_bloc.dart';
import 'package:food_ordering_workflow/repositories/restaurant_repository.dart';

void main() {
  late RestaurantRepository repo;
  late OrderBloc bloc;

  setUp(() {
    repo = RestaurantRepository();
    bloc = OrderBloc(repository: repo);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state', () {
    expect(bloc.state.status, OrderStatus.initial);
  });

  blocTest<OrderBloc, OrderState>(
    'loads restaurants then selects one and adds to cart then checkout',
    build: () => bloc,
    act: (b) async {
      b.add(LoadRestaurants());
      await Future.delayed(const Duration(milliseconds: 500));
      final r = b.state.restaurants.first;
      b.add(SelectRestaurant(r));
      await Future.delayed(const Duration(milliseconds: 500));
      final menu = b.state.menu.first;
      b.add(AddToCart(menu));
      b.add(Checkout());
    },
    wait: const Duration(seconds: 1),
    expect: () => [
      // loading
      // restaurantsLoaded
      // loading (menu)
      // menuLoaded
      // cartUpdated
      // loading (checkout)
      // confirmed
    ],
    verify: (b) {
      expect(b.state.status, OrderStatus.confirmed);
      expect(b.state.cart.isNotEmpty, true);
    }
  );
}
