import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final q = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StoreProvider>();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: q,
          decoration: const InputDecoration(hintText: 'جستجو...', border: InputBorder.none),
          textInputAction: TextInputAction.search,
          onSubmitted: (v) {
            if (v.isNotEmpty) context.read<StoreProvider>().search(v);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              q.clear();
              setState(() => context.read<StoreProvider>().searchResults.clear());
            },
          )
        ],
      ),
      body: p.searchResults.isEmpty
          ? const Center(child: Text('عبارتی جستجو کنید'))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: p.searchResults.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .65,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (_, i) => ProductCard(
          p: p.searchResults[i],
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: p.searchResults[i].id),
        ),
      ),
    );
  }
}