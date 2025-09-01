import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoreProvider>().fetchCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StoreProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: p.categoryProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: p.categoryProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .65,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (_, i) => ProductCard(
          p: p.categoryProducts[i],
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: p.categoryProducts[i].id),
        ),
      ),
    );
  }
}