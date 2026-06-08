import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String username;
  final String bio;

  const ProfileHeader({
    super.key,
    this.imageUrl,
    this.imageBytes,
    required this.username,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundColor: Colors.grey[200],
          child: ClipOval(
            child: imageBytes != null
              ? Image.memory(imageBytes!, fit: BoxFit.cover, width: 92, height: 92)
              : (imageUrl != null && imageUrl!.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    width: 92,
                    height: 92,
                    placeholder: (c, s) => Container(color: Colors.grey[200]),
                    errorWidget: (c, s, e) => Icon(Icons.person, size: 46, color: Colors.grey[600]),
                  )
                : Icon(Icons.person, size: 46, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                bio,
                style: const TextStyle(color: Colors.black54),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
