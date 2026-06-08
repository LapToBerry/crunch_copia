import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import 'title_card.dart';

class TitleGrid extends StatelessWidget {
  final List<TitleItem> titles;

  const TitleGrid({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.66,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return TitleCard(item: titles[index]);
      },
    );
  }
}
