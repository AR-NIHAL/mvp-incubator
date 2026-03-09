import 'package:flutter/foundation.dart';

class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  // URL থেকে পকেমনের আইডি বের করার জন্য (ইমেজ দেখানোর কাজে লাগবে)
  String get id => url.split('/')[url.split('/').length - 2];

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
