// ana/sayfalar/soru_seçme/soru_seçme.dart
import 'package:flutter/material.dart';
import '../../../model/kategori.dart';
import '../../../model/soru.dart';
import '../sonuç_sayfa/sonuc_sayfa.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  final List<Question> sorular;
  final Category kategori;

  const QuizPage({super.key, required this.sorular, required this.kategori});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Artık const olamaz çünkü context'e ihtiyacımız var
  TextStyle _questionStyle(BuildContext context) => TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodyLarge?.color);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Question soru = widget.sorular[_currentIndex];
    // Sadece boş olmayan şıkları al
    final List<dynamic> secenekler = soru.secenekler
        .where((option) => option.toString().trim().isNotEmpty)
        .toList();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            bool? exitQuiz = await showDialog<bool>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: const Text(
                      "Testten çıkmak istediğine emin misin? Tüm ilerlemen kaybolacaktır."),
                  title: const Text("Hata!"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Evet"),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    TextButton(
                      child: const Text("Hayır"),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                );
              },
            );
            if (exitQuiz == true) {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(widget.kategori.name,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Soru ${_currentIndex + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    HtmlUnescape().convert(
                                        widget.sorular[_currentIndex].soru),
                                    softWrap: true,
                                    style:
                                        MediaQuery.of(context).size.width > 800
                                            ? _questionStyle(context)
                                                .copyWith(fontSize: 30.0)
                                            : _questionStyle(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ...secenekler.map((secenek) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: RadioListTile<String>(
                                          title: Text(
                                            HtmlUnescape().convert("$secenek"),
                                            style: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    800
                                                ? const TextStyle(
                                                    fontSize: 30.0)
                                                : const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          groupValue: _answers[_currentIndex]
                                              as String?,
                                          value: secenek as String,
                                          onChanged: (value) {
                                            setState(() {
                                              _answers[_currentIndex] = value;
                                            });
                                          },
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed bottom buttons
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            "Geri",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentIndex--;
                            });
                          },
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: _currentIndex > 0 ? 8.0 : 0.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: _nextSubmit,
                        child: Text(
                          _currentIndex == (widget.sorular.length - 1)
                              ? "Gönder"
                              : "İleri",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Devam etmek için cevap seçmelisin."),
        ),
      );
      return;
    }
    if (_currentIndex < (widget.sorular.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => FinishedQuizPage(
          sorular: widget.sorular,
          cevaplar: _answers,
          kategori: widget.kategori,
        ),
      ));
    }
  }
}
