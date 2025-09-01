import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class StoreProvider extends ChangeNotifier {
  final api = ApiService();
  bool loading = false;

  String? token;
  int userId = 1;
  Map<String, dynamic>? user;

  List<String> categories = [];
  List<Product> products = [];
  List<Product> categoryProducts = [];
  List<Product> searchResults = [];

  Map<String, dynamic>? cart;
  bool dark = false;

  Future<void> login(String u, String p) async {
    loading = true;
    notifyListeners();
    try {
      final res = await api.post('/auth/login', {'username': u, 'password': p});
      token = res['token'];
      api.token = token;
      userId = (res['id'] ?? 1);
      user = res;
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHome() async {
    try {
      // 1) دسته‌بندی‌ها: هم حالت String و هم Map(slug/name) را پوشش بده
      final cats = await api.get('/products/categories');
      if (cats is List) {
        categories = cats
            .map<String>((e) => e is String ? e : (e['slug'] ?? e['name'] ?? '$e'))
            .toList();
      } else {
        categories = [];
      }

      // 2) محصولات: فقط limit بفرست (sortBy/order بعضی وقت‌ها ارور می‌ده)
      final res = await api.get('/products', {'limit': '20'});
      final list = (res['products'] as List? ) ?? [];
      products = list.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      // جلوی کرش رو می‌گیریم؛ لاگ برای دیباگ
      print('fetchHome error: $e');
    }
    notifyListeners();
  }

  Future<void> fetchCategory(String cat) async {
    final res = await api.get('/products/category/$cat');
    categoryProducts = (res['products'] as List).map((e) => Product.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> search(String q) async {
    final res = await api.get('/products/search', {'q': q});
    searchResults = (res['products'] as List).map((e) => Product.fromJson(e)).toList();
    notifyListeners();
  }

  Future<Product> fetchProduct(int id) async {
    final res = await api.get('/products/$id');
    return Product.fromJson(res);
  }

  Future<void> addToCart(int productId, {int qty = 1}) async {
    cart = await api.post('/carts/add', {'userId': userId, 'products': [{'id': productId, 'quantity': qty}]});
    notifyListeners();
  }

  Future<void> fetchCart() async {
    try {
      final res = await api.get('/carts/user/$userId');
      final carts = (res is Map && res['carts'] is List) ? (res['carts'] as List) : const [];
      if (carts.isNotEmpty) {
        cart = carts.first; // فقط اگر سرور چیزی داد، آپدیت کن
      }
      // اگر خالی بود، cart موجود رو دست نمی‌زنیم
    } catch (_) {
      // خطا را نادیده بگیر و cart فعلی را نگه دار
    }
    notifyListeners();
  }
  Future<void> fetchProfile() async {
    user = await api.get('/users/$userId');
    notifyListeners();
  }

  void toggleTheme() {
    dark = !dark;
    notifyListeners();
  }

  void checkout() {
    // سبد را خالی نگه می‌داریم اما null نمی‌کنیم تا دوباره از سرور پر نشود
    if (cart == null) {
      cart = {'products': [], 'total': 0};
    } else {
      cart!['products'] = [];
      cart!['total'] = 0;
    }
    notifyListeners();
  }

  void logout() {
    token = null;
    api.token = null;
    user = null;
    products.clear();
    categories.clear();
    categoryProducts.clear();
    searchResults.clear();
    cart = null;
    notifyListeners();
  }
}