import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Map<String, dynamic>> releases = [
    {
      "title": "Solo Leveling",
      "image":
          "https://m.media-amazon.com/images/M/MV5BYjQ0OTVkZTktNzQ4Ny00NmYwLWFlNmYtN2IzZjA5YjI4MTBhXkEyXkFqcGc@._V1_.jpg"
    },
    {
      "title": "Kaiju No. 8",
      "image":
          "https://upload.wikimedia.org/wikipedia/en/5/58/Kaiju_No._8%2C_volume_1_cover.jpg"
    },
    {
      "title": "Blue Lock",
      "image":
          "https://upload.wikimedia.org/wikipedia/en/f/fd/Blue_Lock_volume_1.png"
    },
  ];

  final List<Map<String, dynamic>> episodes = [
    {
      "anime": "Solo Leveling",
      "episode": 12,
      "description": "O despertar do caçador mais forte.",
      "likes": 120,
      "favorite": false
    },
    {
      "anime": "One Piece",
      "episode": 1110,
      "description": "Luffy enfrenta novos desafios.",
      "likes": 89,
      "favorite": false
    },
    {
      "anime": "Jujutsu Kaisen",
      "episode": 24,
      "description": "A batalha final começa.",
      "likes": 55,
      "favorite": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crunchyroll"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications),
          )
        ],
      ),
      body: ListView(
        children: [

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Lançamentos da Temporada",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: releases.length,
              itemBuilder: (context, index) {

                final anime = releases[index];

                return Container(
                  width: 150,
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12),
                          child: Image.network(
                            anime["image"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        anime["title"],
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Episódios Recentes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ...episodes.asMap().entries.map((entry) {

            int index = entry.key;
            var ep = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                title: Text(ep["anime"]),
                subtitle: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text("Episódio ${ep["episode"]}"),
                    Text(ep["description"]),
                  ],
                ),
                trailing: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        ep["favorite"]
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {

                          ep["favorite"] =
                              !ep["favorite"];

                          if (ep["favorite"]) {
                            ep["likes"]++;
                          } else {
                            ep["likes"]--;
                          }
                        });
                      },
                    ),
                    Text(
                      ep["likes"].toString(),
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}