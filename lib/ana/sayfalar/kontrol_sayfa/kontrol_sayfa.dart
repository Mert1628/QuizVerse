// ana/sayfalar/kontrol_sayfa/kontrol_sayfa.dart
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../../model/soru.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> sorular;
  final Map<int, dynamic> cevaplar;

  const CheckAnswersPage(
      {super.key, required this.sorular, required this.cevaplar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Cevapları Kontrol Et',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sorular.length + 1,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == sorular.length) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minWidth: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                    ModalRoute.withName(Navigator.defaultRouteName),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  "Bitti",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )));
    }
    Question soru = sorular[index];
    bool correct = soru.dogruCevap == cevaplar[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(soru.soru),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              HtmlUnescape().convert("${cevaplar[index]}"),
              style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: "Cevap: "),
                      TextSpan(
                          text: HtmlUnescape().convert(soru.dogruCevap),
                          style: const TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: const TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
