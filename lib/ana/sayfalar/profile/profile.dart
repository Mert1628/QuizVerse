// ana/sayfalar/profile/profile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:QuizVerse/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/kategori.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});

  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      try {
        await Auth().signOut();
        // Auth state change otomatik olarak login sayfasına yönlendirecek
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        }
      } catch (e) {
        // Çıkış sırasında hata oluşursa kullanıcıyı bilgilendir
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Çıkış işlemi başarısız oldu.')),
          );
        }
      }
    }

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  )),
              IconButton(
                  onPressed: signOut,
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  )),
            ],
          ),
          CircleAvatar(
            radius: 130,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: const Icon(Icons.person, size: 130),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(user?.email ?? '',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
          Card(
            color: Theme.of(context).cardTheme.color,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(
                "Son İstatistikler",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(
            height: 20,
            color: Theme.of(context).dividerColor,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .collection('test_results')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Bir hata oluştu",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Her kategorinin son testini tutacak map
              Map<String, Map<String, dynamic>> lastTestsByCategory = {};

              // Tüm testleri döngüye al
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                String category = data['category'] as String;

                // Eğer bu kategori için henüz bir test kaydedilmemişse veya
                // bu test daha yeni ise, güncelle
                if (!lastTestsByCategory.containsKey(category)) {
                  lastTestsByCategory[category] = data;
                }
              }

              if (lastTestsByCategory.isEmpty) {
                return Center(
                  child: Text(
                    'Henüz hiç test çözülmemiş',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18),
                  ),
                );
              }

              return Column(
                children: lastTestsByCategory.entries.map((entry) {
                  String category = entry.key;
                  var testData = entry.value;

                  // Kategori adını bul
                  String categoryName = categories
                      .firstWhere((cat) => cat.key == category,
                          orElse: () => Category(0, category, category))
                      .name;

                  return Card(
                    color: Theme.of(context).cardTheme.color,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'Puan',
                                '${testData['points']}%',
                                Colors.lightGreen,
                              ),
                              _buildStatItem(
                                'Doğru',
                                testData['hits'].toString(),
                                Theme.of(context).textTheme.bodyLarge?.color ??
                                    Colors.white,
                              ),
                              _buildStatItem(
                                'Yanlış',
                                testData['fails'].toString(),
                                Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class FireStoreDataBase {
  Future<List<Map<String, dynamic>>> getData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return [];
    return [doc.data()!];
  }
}
