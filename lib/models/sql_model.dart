class SqlModel {
  String? title;
  int? id;
  String? simpleKor;
  String? simpleEng;
  String? explainKor;
  String? explainEng;
  String? example;
  String? syntax;
  String? creatDt;

  SqlModel({
    this.title,
    this.id,
    this.simpleKor,
    this.simpleEng,
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
      'simple_kor': simpleKor,
      'simple_eng': simpleEng,
      'explain_kor': explainKor,
      'explain_eng': explainEng,
      'example': example,
      'syntax': syntax,
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
      simpleKor: row['simple_kor'] as String?,
      simpleEng: row['simple_eng'] as String?,
      explainKor: row['explain_kor'] as String?,
      explainEng: row['explain_eng'] as String?,
      example: row['example'] as String?,
      syntax: row['syntax'] as String?,
      creatDt: row['creatDt'] as String?,
    );
  }
}

