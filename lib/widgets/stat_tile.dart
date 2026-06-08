import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onTap;

  const StatTile({super.key, required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              '$value',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
