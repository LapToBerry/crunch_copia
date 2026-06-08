import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/profile_header.dart';
import '../widgets/stat_tile.dart';
import '../widgets/title_grid.dart';
import '../models/sample_data.dart';
import 'edit_profile_screen.dart';
import 'user_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _avatar;
  Uint8List? _localAvatarBytes;
  String _username = 'OtakuUser';
  String _bio = 'Fã de animes e mangás. Acompanhando lançamentos e colecionando volumes.';
  int _titles = 128;
  int _followers = 912;
  int _following = 54;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
      // Try to load a locally saved profile when unauthenticated
      try {
        final prefs = await SharedPreferences.getInstance();
        final json = prefs.getString('local_profile_data');
        if (json != null && json.isNotEmpty) {
          final data = jsonDecode(json) as Map<String, dynamic>;
          setState(() {
            _username = data['username'] ?? _username;
            _bio = data['bio'] ?? _bio;
            _avatar = data['avatar_url'];
            // load avatar bytes if present
            final avb = data['avatar_bytes'] as String?;
            if (avb != null && avb.isNotEmpty) {
              try {
                _localAvatarBytes = base64Decode(avb);
              } catch (_) {
                _localAvatarBytes = null;
              }
            }
          });
          return;
        }
      } catch (_) {}
      return;
    }
    // Try to read profile row from Supabase when authenticated
    try {
      final res = await Supabase.instance.client.from('profiles').select('username,bio,avatar_url').eq('id', user.id).single().execute();
      final data = res.data;
      if (data != null) {
        setState(() {
          _username = data['username'] ?? _username;
          _bio = data['bio'] ?? _bio;
          _avatar = data['avatar_url'];
        });
      }
    } catch (_) {}
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(currentName: _username, currentBio: _bio, currentAvatarUrl: _avatar),
      ),
    );
    if (updated == true) {
      await _loadProfile();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
                      imageUrl: _avatar ?? 'https://avatars.githubusercontent.com/u/9919?s=280&v=4',
                      imageBytes: _localAvatarBytes,
              username: _username,
              bio: _bio,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatTile(label: 'Títulos', value: _titles),
                StatTile(label: 'Seguidores', value: _followers, onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserListScreen(userId: userId, showFollowers: true, title: 'Seguidores')));
                }),
                StatTile(label: 'Seguindo', value: _following, onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserListScreen(userId: userId, showFollowers: false, title: 'Seguindo')));
                }),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _openEdit,
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Minha Lista', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TitleGrid(titles: sampleTitles),
          ],
        ),
      ),
    );
  }
}
