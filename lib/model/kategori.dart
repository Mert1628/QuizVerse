// model/kategori.dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final int id;
  final String name;
  final String key; // JSON dosya adı için key
  final dynamic icon;
  Category(this.id, this.name, this.key, {this.icon});
}

final List<Category> categories = [
  Category(
    9,
    "Genel Kültür",
    "genel_kultur",
    icon: FontAwesomeIcons.globeAsia,
  ),
  Category(
    10,
    "Kitaplar",
    "kitaplar",
    icon: FontAwesomeIcons.bookOpen,
  ),
  Category(
    11,
    "Filmler",
    "filmler",
    icon: FontAwesomeIcons.video,
  ),
  Category(
    12,
    "Müzik",
    "müzik",
    icon: FontAwesomeIcons.music,
  ),
  Category(
    14,
    "Televizyon",
    "tv",
    icon: FontAwesomeIcons.tv,
  ),
  Category(
    15,
    "Video Oyunları",
    "vg",
    icon: FontAwesomeIcons.gamepad,
  ),
  Category(
    17,
    "Bilim & Doğa",
    "bd",
    icon: FontAwesomeIcons.microscope,
  ),
  Category(
    18,
    "Bilgisayar",
    "pc",
    icon: FontAwesomeIcons.laptopCode,
  ),
  Category(
    19,
    "Matematik",
    "mat",
    icon: FontAwesomeIcons.sortNumericDown,
  ),
  Category(
    21,
    "Sporlar",
    "spor",
    icon: FontAwesomeIcons.footballBall,
  ),
  Category(
    22,
    "Coğrafya",
    "cografya",
    icon: FontAwesomeIcons.mountain,
  ),
  Category(
    23,
    "Tarih",
    "tarih",
    icon: FontAwesomeIcons.monument,
  ),
  Category(
    25,
    "Sanat",
    "sanat",
    icon: FontAwesomeIcons.paintBrush,
  ),
  Category(
    27,
    "Hayvanlar",
    "hayvan",
    icon: FontAwesomeIcons.dog,
  ),
];
