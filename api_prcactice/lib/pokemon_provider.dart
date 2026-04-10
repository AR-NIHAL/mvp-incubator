import 'package:api_prcactice/api_service.dart';
import 'package:api_prcactice/pokemon_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final apiServiceProvider = Provider((ref) => ApiService());

final pokemonListProvider = FutureProvider<List<Pokemon>>((ref) async {
  return ref.read(apiServiceProvider).fetchPokemonList();
});