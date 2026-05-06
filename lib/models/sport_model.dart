class SportModel {
  final String id;
  final String name;
  final String? description;
  final String? iconPath;

  SportModel({
    required this.id,
    required this.name,
    this.description,
    this.iconPath,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconPath: json['iconPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
    };
  }
}
