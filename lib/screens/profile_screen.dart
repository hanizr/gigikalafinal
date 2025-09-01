import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StoreProvider>().fetchProfile();
    });
  }

  String _fullName(Map<String, dynamic> u) {
    final fn = (u['firstName'] ?? '').toString().trim();
    final ln = (u['lastName'] ?? '').toString().trim();
    final name = [fn, ln].where((e) => e.isNotEmpty).join(' ');
    return name.isEmpty ? 'کاربر' : name;
  }

  double _rating(Map<String, dynamic> u) {
    final r = u['rating'] ?? u['rate'] ?? u['score'];
    if (r is num) return r.clamp(0, 5).toDouble();
    return 4.5;
  }

  List<String> _addresses(Map<String, dynamic> u) {

    final list = (u['addresses'] as List?)?.cast<dynamic>() ?? [];
    if (list.isNotEmpty) {
      return list.map((e) {
        final a = (e as Map).cast<String, dynamic>();
        final p = [
          (a['address'] ?? '').toString(),
          (a['city'] ?? '').toString(),
          (a['state'] ?? '').toString(),
          (a['postalCode'] ?? '').toString(),
        ].where((s) => s.trim().isNotEmpty).join('، ');
        return p;
      }).where((s) => s.trim().isNotEmpty).toList();
    }

    final addr = (u['address'] as Map?)?.cast<String, dynamic>() ?? {};
    final single = [
      (addr['address'] ?? '').toString(),
      (addr['city'] ?? '').toString(),
      (addr['state'] ?? '').toString(),
      (addr['postalCode'] ?? '').toString(),
    ].where((s) => s.trim().isNotEmpty).join('، ');
    return single.isNotEmpty ? [single] : [];
  }

  List<Map<String, dynamic>> _orders(Map<String, dynamic> u) {
    final orders = (u['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (orders.isNotEmpty) return orders;

    return [
      {'id': 1001, 'date': '1403/05/12', 'status': 'تحویل شده'},
      {'id': 1002, 'date': '1403/06/01', 'status': 'در حال پردازش'},
      {'id': 1003, 'date': '1403/06/10', 'status': 'لغو شده'},
    ];
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('تحویل') || s.contains('deliver')) return Colors.green;
    if (s.contains('پردازش') || s.contains('process')) return Colors.orange;
    if (s.contains('لغو') || s.contains('cancel')) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<StoreProvider>();
    final u = (prov.user ?? {}) as Map<String, dynamic>;

    if (prov.user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = _fullName(u);
    final email = (u['email'] ?? '').toString();
    final phone = (u['phone'] ?? '').toString();
    final avatar = (u['image'] as String?) ?? 'https://i.pravatar.cc/150?img=1';
    final rating = _rating(u);
    final addresses = _addresses(u);
    final orders = _orders(u);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink[50],
        foregroundColor: Colors.black87,
        title: const Text('پروفایل', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(email, style: TextStyle(color: Colors.grey[700])),
                      ),
                    if (phone.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(phone, style: TextStyle(color: Colors.grey[700])),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 6),
                        Text('${rating.toStringAsFixed(1)} / 5',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),


          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('آدرس‌ها', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          if (addresses.isEmpty)
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text('آدرسی ثبت نشده است'),
              ],
            )
          else
            ...addresses.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(a)),
                ],
              ),
            )),

          const SizedBox(height: 8),
          const Divider(),


          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('تاریخچه سفارش‌ها', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...orders.map((o) {
            final id = (o['id'] ?? '').toString();
            final date = (o['date'] ?? '').toString();
            final status = (o['status'] ?? 'نامشخص').toString();
            final color = _statusColor(status);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.black54),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('سفارش #$id',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('تاریخ: $date', style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}