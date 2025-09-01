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

  final Map<String, IconData> categoryIcons = {

    'BEAUTY': Icons.face_retouching_natural,
    'FRAGRANCE': Icons.spa,
    'FURNITURE': Icons.chair,
    'GROCERIES': Icons.food_bank,
    'HOME DECOR': Icons.home,
  };


  IconData getCategoryIcon(String categoryName) {

    if (categoryIcons.containsKey(categoryName)) {
      return categoryIcons[categoryName]!;
    }


    String lowerCase = categoryName.toLowerCase().trim();
    if (categoryIcons.containsKey(lowerCase)) {
      return categoryIcons[lowerCase]!;
    }


    String noSpace = lowerCase.replaceAll(' ', '').replaceAll('-', '');
    if (categoryIcons.containsKey(noSpace)) {
      return categoryIcons[noSpace]!;
    }


    if (lowerCase.contains('beauty')) return Icons.face_retouching_natural;
    if (lowerCase.contains('fragrance') || lowerCase.contains('perfume')) return Icons.spa;
    if (lowerCase.contains('furniture')) return Icons.chair;
    if (lowerCase.contains('grocer') || lowerCase.contains('food')) return Icons.food_bank;
    if (lowerCase.contains('home') || lowerCase.contains('decor')) return Icons.home;


    return Icons.category;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StoreProvider>().fetchHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StoreProvider>();
    final Color headerColor = Colors.red;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: headerColor,
        centerTitle: true,
        title: const Text(
          'دیجی‌کالا',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),

      body: p.categories.isEmpty && p.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => p.fetchHome(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            Container(
              color: headerColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  readOnly: true,
                  onTap: () => Navigator.pushNamed(context, '/search'),
                  decoration: InputDecoration(
                    hintText: 'جستجو',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://www.perfumeprice.co.uk/media/iopt/magezon/resized/1076x538/wysiwyg/Best-Dior-Fragrances-1600-x-800_1.webp',
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 170,
                      alignment: Alignment.center,
                      color: Colors.grey.shade200,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 170,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text('خطا در بارگذاری بنر'),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'دسته‌بندی‌ها',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: p.categories.length,
                itemBuilder: (_, i) {
                  final cat = p.categories[i];
                  return _buildCategoryItem(cat, headerColor);
                },
              ),
            ),

            const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'محصولات پیشنهادی',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('مشاهده همه', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .65,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: p.products.length,
                itemBuilder: (_, i) => ProductCard(
                  p: p.products[i],
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: p.products[i].id,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String categoryName, Color headerColor) {

    final icon = getCategoryIcon(categoryName);


    debugPrint('Category: "$categoryName" -> Icon: $icon');

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/category', arguments: categoryName);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    headerColor.withOpacity(0.1),
                    headerColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: headerColor.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: headerColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 30,
                color: headerColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}