// model/soru.dart
enum Type { multiple }

enum Difficulty { kolay, orta, zor }

class Question {
  final String categoryName;
  final Type type;
  final Difficulty difficulty;
  final String soru;
  final String dogruCevap;
  final List<String> secenekler;
  final List<String> tumCevaplar;

  Question({
    required this.categoryName,
    required this.type,
    required this.difficulty,
    required this.soru,
    required this.dogruCevap,
    required this.secenekler,
    required this.tumCevaplar,
  });

  Question.fromMap(Map<String, dynamic> data, String category)
      : categoryName = category,
        type = Type.multiple,
        difficulty = data["zorluk"] == "kolay"
            ? Difficulty.kolay
            : data["zorluk"] == "orta"
                ? Difficulty.orta
                : Difficulty.zor,
        soru = data["soru"] ?? "",
        dogruCevap = data["dogruCevap"] ?? "",
        secenekler = List<String>.from(data["secenekler"] ?? []),
        tumCevaplar = List<String>.from(data["secenekler"] ?? []);

  static List<Question> fromData(
      List<Map<String, dynamic>> data, String category) {
    return data.map((soru) => Question.fromMap(soru, category)).toList();
  }
}
