// ana/widgets/sınav_özellik.dart
import 'package:flutter/material.dart';
import '../../model/kategori.dart';
import '../../services/question_service.dart';
import '../sayfalar/soru_seçme/soru_seçme.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Category kategori;

  const QuizOptionsDialog({super.key, required this.kategori});

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  late int _noOfQuestions;
  late String _difficulty;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "kolay";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surface,
            child: Text(
              widget.kategori.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Text("Soru sayısı seç",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 0.0),
                ActionChip(
                  label: Text("10",
                      style: TextStyle(
                          color: _noOfQuestions == 10
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _noOfQuestions == 10
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectNumberOfQuestions(10),
                ),
                ActionChip(
                  label: Text("20",
                      style: TextStyle(
                          color: _noOfQuestions == 20
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _noOfQuestions == 20
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: Text("30",
                      style: TextStyle(
                          color: _noOfQuestions == 30
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _noOfQuestions == 30
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: Text("40",
                      style: TextStyle(
                          color: _noOfQuestions == 40
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _noOfQuestions == 40
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: Text("50",
                      style: TextStyle(
                          color: _noOfQuestions == 50
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _noOfQuestions == 50
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Text("Zorluk Seç",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 0.0),
                ActionChip(
                  label: Text("Kolay",
                      style: TextStyle(
                          color: _difficulty == "kolay"
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _difficulty == "kolay"
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectDifficulty("kolay"),
                ),
                ActionChip(
                  label: Text("Orta",
                      style: TextStyle(
                          color: _difficulty == "orta"
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _difficulty == "orta"
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectDifficulty("orta"),
                ),
                ActionChip(
                  label: Text("Zor",
                      style: TextStyle(
                          color: _difficulty == "zor"
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color)),
                  backgroundColor: _difficulty == "zor"
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  onPressed: () => _selectDifficulty("zor"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          processing
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    height: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minWidth: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0.0,
                      ),
                      onPressed: _startQuiz,
                      child: const Text(
                        "Sınavı Başlat",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });

    try {
      final sorular = await QuestionService.loadQuestions(
        widget.kategori.key,
        _difficulty,
      );

      if (sorular.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bu kategoride soru bulunamadı.'),
            ),
          );
        }
        return;
      }

      // Her sorunun şıklarını karıştır
      for (var soru in sorular) {
        soru.secenekler.shuffle();
      }

      // Soruları karıştır
      sorular.shuffle();

      // Eğer gelen soru sayısı istenenden fazla ise kes
      final secilmissorular = sorular.length > _noOfQuestions
          ? sorular.sublist(0, _noOfQuestions)
          : sorular;

      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizPage(
              sorular: secilmissorular,
              kategori: widget.kategori,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sorular yüklenirken bir hata oluştu: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          processing = false;
        });
      }
    }
  }
}
