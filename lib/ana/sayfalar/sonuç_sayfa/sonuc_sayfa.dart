// ana/sayfalar/sonuç_sayfa/sonuc_sayfa.dart
import 'package:flutter/material.dart';
import '../../../model/soru.dart';
import '../kontrol_sayfa/kontrol_sayfa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:html_unescape/html_unescape.dart';

void kaydetSonuc(int dogru, int yanlis, int puan, String kategori) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Test sonuçlarını test_results koleksiyonuna kaydet
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('test_results')
        .add({
      'hits': dogru,
      'fails': yanlis,
      'points': puan,
      'category': kategori,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class FinishedQuizPage extends StatelessWidget {
  final List<Question> sorular;
  final Map<int, dynamic> cevaplar;
  final dynamic kategori;

  const FinishedQuizPage(
      {super.key,
      required this.sorular,
      required this.cevaplar,
      required this.kategori});

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    cevaplar.forEach((index, value) {
      if (sorular[index].dogruCevap == value) correct++;
    });
    final TextStyle titleStyle = TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 16.0,
        fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    kaydetSonuc(
      correct,
      sorular.length - correct,
      (correct * 100 / sorular.length).round(),
      kategori.name,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Sonuç',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        elevation: 0,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0), //iç boşluk
                  title: Text("Toplam Sorular", style: titleStyle),
                  trailing: Text("${sorular.length}", style: trailingStyle),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                //skor sayısı kartı
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Skor", style: titleStyle),
                  trailing: Text(
                      "${(correct / sorular.length * 100).toStringAsFixed(1)}%",
                      style: trailingStyle),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                color: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Doğru Cevaplar",
                      style: titleStyle.copyWith(color: Colors.white)),
                  trailing: Text("$correct/${sorular.length}",
                      style: trailingStyle.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                color: Colors.red.shade900,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Yanlış Cevaplar",
                      style: titleStyle.copyWith(color: Colors.white)),
                  trailing: Text(
                      "${sorular.length - correct}/${sorular.length}",
                      style: trailingStyle.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                //2 butonu yan yana gösterme
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, //butonları sağ sol atar
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context), //öncekisayfa yolla
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text(
                      "Ana Sayfaya Dön",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                            sorular: sorular,
                            cevaplar: cevaplar,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      "Cevapları Kontrol Et",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
