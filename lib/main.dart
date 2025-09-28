import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/order_bloc.dart';
import 'repositories/restaurant_repository.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoodOrderingApp());
}

class FoodOrderingApp extends StatelessWidget {
  const FoodOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RestaurantRepository>(
      create: (_) => RestaurantRepository(),
      child: BlocProvider<OrderBloc>(
        create: (context) {
          final restaurantRepo = context.read<RestaurantRepository>();
          return OrderBloc(repository: restaurantRepo);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food Ordering Workflow',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
