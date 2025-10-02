class Memory {
  final String id;
  final String title;
  final List<String> imagePaths;
  final DateTime createdAt;

  Memory({
    required this.id,
    required this.title,
    required this.imagePaths,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imagePaths': imagePaths,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Memory.fromJson(Map<String, dynamic> json) => Memory(
    id: json['id'],
    title: json['title'],
    imagePaths: List<String>.from(json['imagePaths']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}
