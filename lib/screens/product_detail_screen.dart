import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final int id;
  const ProductDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<StoreProvider>();
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await prov.addToCart(id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('به سبد اضافه شد')));
          }
        },
        label: const Text('افزودن به سبد'),
        icon: const Icon(Icons.add_shopping_cart),
      ),
      body: FutureBuilder<Product>(
        future: prov.fetchProduct(id),
        builder: (c, s) {
          if (!s.hasData) return const Center(child: CircularProgressIndicator());
          final p = s.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(p.images.isNotEmpty ? p.images.first : p.thumbnail, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(p.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: [Icon(Icons.star, color: Colors.amber.shade700), Text(p.rating.toString())]),
              const SizedBox(height: 6),
              Text('\$${p.price}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 12),
              Text(p.description),
            ],
          );
        },
      ),
    );
  }
}