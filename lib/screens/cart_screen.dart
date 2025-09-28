import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_workflow/screens/home_screen.dart';
import '../bloc/order_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Your Cart'),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final cart = state.cart;
          if (cart.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          final total = cart.fold<double>(0, (p, e) => p + e.total);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, idx) {
                      final c = cart[idx];

                      return BlocBuilder<OrderBloc, OrderState>(
                        buildWhen: (previous, current) {
                          final oldItem = previous.cart.firstWhere(
                              (item) => item.menuItemId == c.menuItemId,
                              orElse: () => c);
                          final newItem = current.cart.firstWhere(
                              (item) => item.menuItemId == c.menuItemId,
                              orElse: () => c);
                          return oldItem.quantity != newItem.quantity;
                        },
                        builder: (context, state) {
                          final updatedItem = state.cart.firstWhere(
                              (item) => item.menuItemId == c.menuItemId);

                          return ListTile(
                            title: Text(updatedItem.name),
                            subtitle: Text(
                                '₹${updatedItem.price.toStringAsFixed(2)} × ${updatedItem.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    final newQ = updatedItem.quantity - 1;
                                    if (newQ <= 0) {
                                      context.read<OrderBloc>().add(
                                          RemoveFromCart(
                                              updatedItem.menuItemId));
                                    } else {
                                      context.read<OrderBloc>().add(
                                          ChangeQuantity(
                                              updatedItem.menuItemId, newQ));
                                    }
                                  },
                                ),
                                Text('${updatedItem.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    context.read<OrderBloc>().add(
                                        ChangeQuantity(updatedItem.menuItemId,
                                            updatedItem.quantity + 1));
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text('Total: ₹${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<OrderBloc>().add(Checkout()),
                  child: const Text('Checkout'),
                ),
                const SizedBox(height: 12),
                if (state.status == OrderStatus.confirmed)
                  Column(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 48, color: Colors.green),
                      const SizedBox(height: 6),
                      const Text('Order Confirmed!'),
                      TextButton(
                        onPressed: () {
                          context.read<OrderBloc>().add(ResetOrder());
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
