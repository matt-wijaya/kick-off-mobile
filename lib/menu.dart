import 'package:flutter/material.dart';

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;       // warna latar tombol
  final String snackText;  // teks snackbar saat ditekan

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
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(item.snackText)),
            );
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

  final String nama = "Matthew Wijaya"; //nama
  final String npm = "2406359203";//npm
  final String kelas = "C"; //kelas
  //  - All Products (biru)
  //  - My Products (hijau)
  //  - Create Product (merah)
  final List<ItemHomepage> items = [
    ItemHomepage(
      name: "All Products",
      icon: Icons.list_alt,
      color: Colors.blue, // biru
      snackText: "Kamu telah menekan tombol All Products",
    ),
    ItemHomepage(
      name: "My Products",
      icon: Icons.inventory_2,
      color: Colors.green, // hijau
      snackText: "Kamu telah menekan tombol My Products",
    ),
    ItemHomepage(
      name: "Create Product",
      icon: Icons.add_box,
      color: Colors.red, // merah
      snackText: "Kamu telah menekan tombol Create Product",
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