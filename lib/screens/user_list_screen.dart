import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/profile_avatar.dart';

class UserListScreen extends StatefulWidget {
  final String userId;
  final bool showFollowers;
  final String title;

  const UserListScreen({super.key, required this.userId, required this.showFollowers, required this.title});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await SupabaseService.getFollowers(widget.userId, followers: widget.showFollowers);
    setState(() {
      _items = res;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: _items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final row = _items[index];
              // row may contain nested 'follower' or 'following' maps depending on query
              final profile = (row['follower'] ?? row['following'] ?? row) as Map<String, dynamic>;
              return ListTile(
                leading: ProfileAvatar(imageUrl: profile['avatar_url'] ?? '' , radius: 22),
                title: Text(profile['username'] ?? 'Usuário'),
                subtitle: Text(profile['id'] ?? ''),
              );
            },
          ),
    );
  }
}
