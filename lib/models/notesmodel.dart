
class Notesmodel {
  int? id;
  String title;
  String description;
  bool isCompleted;

  Notesmodel({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false, // Default value is false
  });

  // Other existing constructor and methods...

  Notesmodel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        isCompleted = res['isCompleted'] == 1; // Assuming 1 represents true and 0 represents false

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
