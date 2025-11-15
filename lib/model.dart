class TODOModel {
  int? id;
  String title;
  String? description;
  bool isCompleted;

  TODOModel({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TODOModel.fromMap(Map<String, dynamic> map) {
    return TODOModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
