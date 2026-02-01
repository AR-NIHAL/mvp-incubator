import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/storage/cart_hive_models.dart';
import 'features/cart/ui/cart_page.dart';
import 'features/products/ui/product_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HiveCartItemAdapter());
  await Hive.openBox<HiveCartItem>('cartBox');

  await Hive.openBox<int>('favoritesBox');
  await Hive.openBox<String>('productsCacheBox');

  runApp(const ProviderScope(child: ShopLiteApp()));
}

class ShopLiteApp extends StatelessWidget {
  const ShopLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopLite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.products,
      routes: {
        AppRoutes.products: (_) => const ProductListPage(),
        AppRoutes.cart: (_) => const CartPage(),
      },
    );
  }
}
