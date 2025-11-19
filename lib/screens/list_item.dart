// File: list_item.dart

import 'package:flutter/material.dart';
import 'package:kickoff/models/item.dart';
import 'package:kickoff/widgets/left_drawer.dart';
import 'package:kickoff/widgets/item_card.dart'; // BARU: Import Card khusus
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// UBAH: Tambahkan parameter filter untuk mendukung All/My Items
class ItemListPage extends StatefulWidget {
  final String filter; // 'all' atau 'my'
  const ItemListPage({super.key, this.filter = 'all'});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  Future<List<Item>> fetchItems(CookieRequest request) async {
    String url = 'http://localhost:8000/get-items-json/';
    
    // Terapkan filter berdasarkan parameter widget
    if (widget.filter == 'my') {
      url += '?filter=my';
    } 

    final response = await request.get(url);
    
    List<Item> listItems = [];
    for (var d in response) {
      if (d != null) {
        listItems.add(Item.fromJson(d));
      }
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filter == 'my' ? 'My Items' : 'All Items'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItems(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.data!.isEmpty) { 
            return const Center(child: Text('Belum ada item.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                var item = snapshot.data![index];
                return ItemCard(item: item);
              },
            );
          }
        },
      ),
    );
  }
}