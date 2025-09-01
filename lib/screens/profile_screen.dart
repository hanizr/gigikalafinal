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
    context.read<StoreProvider>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<StoreProvider>();
    final u = prov.user;
    return Scaffold(
      appBar: AppBar(title: const Text('پروفایل')),
      body: u == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(u['image'] ?? 'https://i.pravatar.cc/150?img=1')),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '${u['firstName'] ?? ''} ${u['lastName'] ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(leading: const Icon(Icons.email), title: Text(u['email'] ?? '')),
          ListTile(leading: const Icon(Icons.phone), title: Text(u['phone'] ?? '')),
          ListTile(leading: const Icon(Icons.location_on), title: Text(u['address']?['address']?.toString() ?? '')),
        ],
      ),
    );
  }
}