import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoreProvider>().fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StoreProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('فروشگاه'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.pushNamed(context, '/search')),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () => Navigator.pushNamed(context, '/cart')),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Navigator.pushNamed(context, '/profile')),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, '/settings')),
        ],
      ),
      body: p.categories.isEmpty && p.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => p.fetchHome(),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text('دسته‌بندی‌ها', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final cat = p.categories[i];
                  return ActionChip(label: Text(cat), onPressed: () => Navigator.pushNamed(context, '/category', arguments: cat));
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: p.categories.length,
              ),
            ),
            const SizedBox(height: 16),
            const Text('محصولات پیشنهادی', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: p.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .65,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (_, i) => ProductCard(
                p: p.products[i],
                onTap: () => Navigator.pushNamed(context, '/detail', arguments: p.products[i].id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}