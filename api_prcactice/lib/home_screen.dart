import 'package:api_prcactice/pokemon_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Pokedex')),
      body: pokemonAsync.when(
        data: (pokemonList) => ListView.builder(
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonList[index];
            return ListTile(
              leading: Image.network(pokemon.imageUrl, width: 50),
              title: Text(pokemon.name.toUpperCase()),
              subtitle: Text("#${pokemon.id}"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // পরবর্তী মডিউলে আমরা ডিটেইলস পেজ যোগ করব
              },
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}