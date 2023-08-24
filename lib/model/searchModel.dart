class SearchModel {
  String title;
  String id;
  String? imageUrl;
  String type;

  SearchModel({
    required this.title,
    required this.id,
    this.imageUrl,
    required this.type,
  });
}
