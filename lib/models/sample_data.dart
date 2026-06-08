class TitleItem {
  final String id;
  final String title;
  final String imageUrl;

  TitleItem({required this.id, required this.title, required this.imageUrl});
}

final List<TitleItem> sampleTitles = [
  TitleItem(
    id: '1',
    title: 'Chainsaw Man',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/0/0e/Chainsaw_Man%2C_volume_1_cover.jpg',
  ),
  TitleItem(
    id: '2',
    title: 'Jujutsu Kaisen',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/4/4b/Jujutsu_Kaisen_volume_1.jpg',
  ),
  TitleItem(
    id: '3',
    title: 'One Piece',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/6/6d/One_Piece_volume_1_cover.jpg',
  ),
  TitleItem(
    id: '4',
    title: 'Demon Slayer',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/0/0b/Demon_Slayer_volume_1.jpg',
  ),
  TitleItem(
    id: '5',
    title: 'Attack on Titan',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/7/7a/Shingeki_no_Kyojin_manga_volume_1.jpg',
  ),
  TitleItem(
    id: '6',
    title: 'My Hero Academia',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/en/5/5f/My_Hero_Academia_volume_1.jpg',
  ),
];
