// File: lib/widgets/item_card.dart

import 'package:flutter/material.dart';
import 'package:kickoff/models/item.dart';
import 'package:kickoff/screens/item_detail.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailPage(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Thumbnail (Jika ada)
              if (item.fields.thumbnail != null && item.fields.thumbnail!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(
                    item.fields.thumbnail!,
                    height: 100, 
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, _) => const Icon(Icons.broken_image),
                  ),
                ),
              Text(
                item.fields.name,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Price and Category (Sesuai dengan yang ditampilkan di web)
              Text("Category: ${item.fields.category}"),
              Text("Price: Rp ${item.fields.price}"),
              Text(item.fields.description),
              Text("Stock: ${item.fields.stock}"),
            ],
          ),
        ),
      ),
    );
  }
}