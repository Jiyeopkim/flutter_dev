class ExamModel {
  String? title;
  int? id;
  String? content;


  ExamModel({
    this.title,
    this.id,
    this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'content': content,
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
      content: row['content'] as String?,
    );
  }
}

