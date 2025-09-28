import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../widgets/menu_item_tile.dart';
import 'cart_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 4,
        title: const Text(
          '🍲 Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == OrderStatus.failure) {
            return Center(
              child: Text(
                'Oops! Something went wrong.\n${state.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          } else if (state.menu.isEmpty) {
            return const Center(
              child: Text(
                'No menu items available 🍴',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.menu.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final menu = state.menu[idx];
              return MenuItemTile(
                menu: menu,
                onAdd: () {
                  context.read<OrderBloc>().add(AddToCart(menu));
                  final snack = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${menu.name} added to cart 🛒'),
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                },
              );
            },
          );
        },
      ),
    );
  }
}
