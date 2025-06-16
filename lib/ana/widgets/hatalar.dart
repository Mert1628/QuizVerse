// ana/widgets/hatalar.dart
// ana/widgets/hatalar.dart
import 'package:flutter/material.dart';

// Hata durumlarında gösterilecek basit bir sayfa
class ErrorPage extends StatelessWidget {
  final String message;

  // Varsayılan hata mesajı tanımlı, istersek dışarıdan da gönderebiliriz
  const ErrorPage({super.key, this.message = "Bilinmeyen hata."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hata'), // Sayfa başlığı
        elevation: 0, // Gölgeyi kaldırdık, düz görünüm
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity, // Tüm ekranı kaplasın
        decoration: BoxDecoration(
          color: Colors.grey[200], // Açık gri arka plan
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Kenarlardan boşluk
          child: Center(
            child: Card( // Ortada kart şeklinde kutu
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Kart içi boşluk
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Yalnızca içeriğe göre yükseklik
                  children: <Widget>[
                    Text(
                      message, // Gösterilecek hata mesajı
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.red), // Kırmızı yazı
                    ),
                    const SizedBox(height: 20.0), // Alt boşluk
                    ButtonTheme(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Yuvarlatılmış köşe
                        ),
                        minWidth: MediaQuery.of(context).size.width, // Ekranı tam kaplasın
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Kırmızı buton
                          ), // Geri dön
                          child: const Text(
                            "Tekrar Dene", // Buton metni
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
