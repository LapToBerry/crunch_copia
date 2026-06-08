import 'dart:typed_data';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sample_data.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class TitleCard extends StatefulWidget {
  final TitleItem item;
  final VoidCallback? onTap;

  const TitleCard({super.key, required this.item, this.onTap});

  @override
  State<TitleCard> createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {
  Uint8List? _localBytes;

  @override
  void initState() {
    super.initState();
    _loadLocalImage();
  }

  Future<void> _loadLocalImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'title_image_${widget.item.id}';
      final encoded = prefs.getString(key);
      if (encoded != null && encoded.isNotEmpty) {
        setState(() {
          _localBytes = base64Decode(encoded);
        });
      }
    } catch (_) {}
  }

  Future<void> _pickImage() async {
    try {
      final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
      if (res != null && res.files.isNotEmpty) {
        final pf = res.files.first;
        Uint8List? bytes;
        if (pf.bytes != null) {
          bytes = pf.bytes;
        } else if (pf.path != null) {
          bytes = await File(pf.path!).readAsBytes();
        }
        if (bytes != null) {
          final prefs = await SharedPreferences.getInstance();
          final key = 'title_image_${widget.item.id}';
          await prefs.setString(key, base64Encode(bytes));
          setState(() => _localBytes = bytes);
        }
      }
    } catch (e) {
      // ignore errors
    }
  }

  Future<void> _removeImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'title_image_${widget.item.id}';
      await prefs.remove(key);
      setState(() => _localBytes = null);
    } catch (_) {}
  }

  Future<void> _showOptions() async {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Escolher imagem'),
              onTap: () async {
                Navigator.of(ctx).pop();
                await _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Remover imagem'),
              onTap: () async {
                Navigator.of(ctx).pop();
                await _removeImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Fechar'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: _showOptions,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GridTile(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _localBytes != null
                ? Image.memory(_localBytes!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: widget.item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (c, s) => Container(color: Colors.grey[300]),
                    errorWidget: (c, s, e) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
              // Long-press the card to open image options (Escolher / Remover)
            ],
          ),
          footer: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            color: Colors.black54,
            child: Text(
              widget.item.title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
