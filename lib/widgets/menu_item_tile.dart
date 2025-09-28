import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem menu;
  final VoidCallback onAdd;

  const MenuItemTile({super.key, required this.menu, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(width: 64, height: 64, alignment: Alignment.center, child: Text(menu.name[0]))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(menu.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(menu.description, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Text('₹${menu.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
            ElevatedButton(onPressed: onAdd, child: const Text('Add'))
          ],
        ),
      ),
    );
  }
}
