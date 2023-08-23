class SqlModel {
  String? title;
  int? id;
  String? explainKor;
  String? explainEng;
  String? example;
  String? syntax;
  String? creatDt;

  SqlModel({
    this.title,
    this.id,
    this.explainKor,
    this.explainEng,
    this.example,
    this.syntax,
    this.creatDt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'creatDt': creatDt,
    };
  }

  static SqlModel? fromMap(List<Map<String, Object?>> result) {
    if (result.isEmpty) {
      return null;
    }
    final row = result.first;
    return SqlModel(
      title: row['title'] as String?,
      id: row['id'] as int?,
      explainKor: row['explain_kor'] as String?,
      explainEng: row['explain_eng'] as String?,
      example: row['example'] as String?,
      syntax: row['syntax'] as String?,
      creatDt: row['creatDt'] as String?,
    );
  }
}

