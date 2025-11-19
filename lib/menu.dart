import 'package:flutter/material.dart';
import 'package:kickoff/widgets/left_drawer.dart';
import 'package:kickoff/screens/items_form.dart';
import 'package:kickoff/screens/list_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:kickoff/screens/login.dart';

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final String snackText;

  ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
    required this.snackText,
  });
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
            );

          if (item.name == "Create Product" || item.name == "Tambah Produk" || item.name == "Add Product") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemsFormPage()),
            );
          }
          else if (item.name == "All Products") {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemListPage()),
            );
          }
          else if (item.name == "Logout") {
              final response = await request.logout(
                  "http://localhost:8000/auth/logout/");
              
              String message = response["message"];
              if (context.mounted) {
                  if (response['status']) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message See you again, $uname."),
                      ));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                  } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(message),
                          ),
                      );
                  }
              }
          }
        },
        
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String nama = "Matthew Wijaya";
  final String npm = "2406359203";
  final String kelas = "C";

  final List<ItemHomepage> items = [
    ItemHomepage(
      name: "All Products",
      icon: Icons.list_alt,
      color: Colors.blue,
      snackText: "Kamu telah menekan tombol All Products",
    ),
    ItemHomepage(
      name: "Create Product",
      icon: Icons.add_box,
      color: Colors.green, 
      snackText: "Kamu telah menekan tombol Create Product",
    ),
    ItemHomepage(
      name: "Logout",
      icon: Icons.logout,
      color: Colors.red,
      snackText: "Logout",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KickOff',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(8),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          crossAxisCount: 3,
          shrinkWrap: true,
          children: items.map((item) => ItemCard(item)).toList(),
        ),
      ),
    );
  }
}