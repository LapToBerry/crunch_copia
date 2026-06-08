import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final Uint8List? imageBytes;
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({super.key, this.imageUrl, this.imageFile, this.imageBytes, this.radius = 46, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: imageBytes != null
          ? MemoryImage(imageBytes!)
          : imageFile != null
            ? FileImage(imageFile!)
            : (imageUrl != null && imageUrl!.isNotEmpty)
              ? CachedNetworkImageProvider(imageUrl!) as ImageProvider
              : null,
        child: (imageBytes == null && imageFile == null && (imageUrl == null || imageUrl!.isEmpty))
          ? Icon(Icons.person, size: radius)
          : null,
      ),
    );
  }
}
