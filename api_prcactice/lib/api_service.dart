import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:api_prcactice/pokemon_model.dart';

class ApiService {
  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0'),
    );

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }
}
