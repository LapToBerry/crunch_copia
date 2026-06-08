import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import '../widgets/title_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() =>
      _ExploreScreenState();
}

class _ExploreScreenState
    extends State<ExploreScreen> {

  String search = "";

  @override
  Widget build(BuildContext context) {

    final filtered = sampleTitles.where((anime) {

      return anime.title
          .toLowerCase()
          .contains(
            search.toLowerCase(),
          );

    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explorar"),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText:
                    "Buscar anime ou mangá",
                prefixIcon:
                    const Icon(Icons.search),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.all(12),

              itemCount: filtered.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),

              itemBuilder: (context, index) {

                return TitleCard(
                  title: filtered[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}