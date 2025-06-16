// ana/sayfalar/ana_sayfa/ana_sayfa.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/kategori.dart';
import '../../../services/theme_service.dart';
import '../../widgets/sınav_özellik.dart';
import '../profile/profile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('QuizVerse',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Tema değiştirme butonu
          IconButton(
            icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              themeService.toggleTheme();
            },
            tooltip: themeService.isDarkMode ? 'Açık Tema' : 'Karanlık Tema',
          ),
          IconButton(
            icon: Icon(Icons.person,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Container(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 40.0),
                child: Text(
                  "Sınav için kategori seçiniz",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                      fontSize: 30.0),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 1000
                          ? 7
                          : MediaQuery.of(context).size.width > 600
                              ? 5
                              : 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0),
                  delegate: SliverChildBuilderDelegate(
                    _buildCategoryItem,
                    childCount: categories.length,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 0.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).cardTheme.color,
      textColor: Theme.of(context).textTheme.bodyLarge?.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null)
            Icon(category.icon, color: Theme.of(context).iconTheme.color),
          if (category.icon != null) const SizedBox(height: 5.0),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(.7),
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (sheetContext) => Dialog(
        child: QuizOptionsDialog(
          kategori: category,
        ),
      ),
    );
  }
}
