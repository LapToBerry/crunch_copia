import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/profile_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final String? currentBio;
  final String? currentAvatarUrl;

  const EditProfileScreen({super.key, this.currentName, this.currentBio, this.currentAvatarUrl});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _pickedImage;
  Uint8List? _pickedBytes;
  String? _pickedExt;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
    _bioController.text = widget.currentBio ?? '';
  }

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (res != null && res.files.isNotEmpty) {
      final pf = res.files.first;
      setState(() {
        if (pf.bytes != null) {
          _pickedBytes = pf.bytes;
          _pickedExt = pf.extension;
          _pickedImage = null;
        } else if (pf.path != null) {
          _pickedImage = File(pf.path!);
          _pickedBytes = null;
          _pickedExt = pf.extension;
        }
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final userId = user?.id;
      String? url = widget.currentAvatarUrl;
      Map<String, dynamic> payload = {
        'username': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      if (userId == null) {
        // Unauthenticated: save image bytes locally instead of uploading to Supabase
        if (_pickedBytes != null) {
          payload['avatar_bytes'] = base64Encode(_pickedBytes!);
        } else if (_pickedImage != null) {
          try {
            final bytes = await _pickedImage!.readAsBytes();
            payload['avatar_bytes'] = base64Encode(bytes);
          } catch (_) {}
        }
        // Keep avatar_url if it was already provided
        if (url != null) payload['avatar_url'] = url;
      } else {
        // Authenticated: upload to Supabase storage
        if (_pickedBytes != null) {
          final uploaded = await SupabaseService.uploadProfileImageFromBytes(_pickedBytes!, _pickedExt ?? 'png');
          if (uploaded != null) url = uploaded;
        } else if (_pickedImage != null) {
          final uploaded = await SupabaseService.uploadProfileImage(_pickedImage!);
          if (uploaded != null) url = uploaded;
        }
        payload['avatar_url'] = url;
      }

      final success = await SupabaseService.updateProfile(userId, payload);
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao salvar perfil')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileAvatar(imageUrl: widget.currentAvatarUrl, imageFile: _pickedImage, radius: 56),
            const SizedBox(height: 8),
            TextButton.icon(onPressed: _pickImage, icon: const Icon(Icons.photo), label: const Text('Escolher imagem')),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 8),
            TextField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio'), maxLines: 3),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const CircularProgressIndicator.adaptive() : const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
