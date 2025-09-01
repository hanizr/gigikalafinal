import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    final prov = context.read<StoreProvider>(); // read: مجازه در initState
    if (prov.cart == null) prov.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<StoreProvider>();
    final cart = prov.cart;
    final items = (cart?['products'] as List?) ?? []; // اینجا تعریفش کن

    return Scaffold(
      appBar: AppBar(
        title: const Text('سبد خرید'),
        actions: [IconButton(onPressed: () => prov.fetchCart(), icon: const Icon(Icons.refresh))],
      ),
      body: items.isEmpty
          ? const Center(child: Text('سبد خالی است'))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final item = items[i];
                return ListTile(
                  leading: CircleAvatar(child: Text('${item['quantity']}')),
                  title: Text(item['title'] ?? 'محصول'),
                  subtitle: Text('\$${item['price']} x ${item['quantity']}'),
                  trailing: Text('\$${item['total']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('جمع کل: \$${cart?['total'] ?? 0}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    prov.checkout(); // سبد را خالی می‌کند
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('خرید با موفقیت انجام شد ✅')),
                    );
                  },
                  child: const Text('تسویه حساب'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}