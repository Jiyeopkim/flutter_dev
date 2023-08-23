class ExamModel {
  String? title;
  int? id;


  ExamModel({
    this.title,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
    };
  }

  static ExamModel? fromMap(List<Map<String, Object?>> result) {
    if (result.isEmpty) {
      return null;
    }
    final row = result.first;
    return ExamModel(
      title: row['title'] as String?,
      id: row['id'] as int?,
    );
  }
}

