import 'package:flutter/material.dart';
import 'package:kickoff/menu.dart';
import 'package:kickoff/screens/items_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              children: [
                Text(
                  'KickOff',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Discover premium sportswear where performance meets peak style.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          // Home
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          // Tambah Produk
          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Tambah Produk'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ItemsFormPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
