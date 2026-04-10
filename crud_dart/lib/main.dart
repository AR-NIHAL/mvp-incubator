import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final dio = Dio();

    try {
      final response = await dio.get("https://dummyjson.com/products");
      final data = response.data;
      final fetchedProducts = data['products'];

      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });

      // print("Total products fetched: ${products.length}");
      // print("First product title ${products [0] ['title']}");
    } catch (e) {
      print('Error  :$e');
      // setState(() {
      //   productTitle = "Error: $e";
      //   isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Api Fetch")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ListTile(
                    title: Text(product['title']),
                    subtitle: Text("price: ${product["price"]}"),
                  );
                },
              ),
      ),
    );
  }
}
