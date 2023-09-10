class Models {
  final String id;
  final int created;
  final String root;
  Models({required this.id, required this.created, required this.root});


  factory Models.fromJson(Map<String, dynamic> json) => Models(
        id: json["id"],
        created: json["created"],
        root: json["root"],
      );


  static List<Models> modelsFromSnapshot(List models)
  {
    return models.map((data) => Models.fromJson(data)).toList();
  }
}
