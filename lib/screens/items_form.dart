import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kickoff/menu.dart';
import 'package:kickoff/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemsFormPage extends StatefulWidget {
  const ItemsFormPage({super.key});

  @override
  State<ItemsFormPage> createState() => _ItemsFormPageState();
}

class _ItemsFormPageState extends State<ItemsFormPage> {
  final _formKey = GlobalKey<FormState>();

  // ====== State untuk input ======
  String _name = "";
  String _description = "";
  String _category = "lainnya";          // default
  String _thumbnail = "";                // opsional
  bool _isFeatured = false;              // default
  String _priceText = "";                // raw text dari field harga
  int _stock = 0; // stock

  final List<String> _categories = [
    'jersey',
    'sepatu',
    'bola',
    'aksesoris',
    'lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    // BARU: Akses CookieRequest
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Product Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // === Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Produk",
                    labelText: "Nama Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() => _name = value ?? "");
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama tidak boleh kosong!";
                    }
                    if (value.trim().length < 3) {
                      return "Minimal 3 karakter.";
                    }
                    if (value.trim().length > 50) {
                      return "Maksimal 50 karakter.";
                    }
                    return null;
                  },
                ),
              ),

              // === Price ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Harga (contoh: 150000 atau 150000.00)",
                    labelText: "Harga",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() => _priceText = value ?? "");
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Harga tidak boleh kosong!";
                    }
                    final parsed = double.tryParse(value.trim().replaceAll(',', ''));
                    if (parsed == null) {
                      return "Harga harus berupa angka yang valid.";
                    }
                    if (parsed < 0) {
                      return "Harga tidak boleh negatif.";
                    }
                    if (parsed > 1e12) {
                      return "Harga terlalu besar.";
                    }
                    return null;
                  },
                ),
              ),
              
              // === Stock ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Stok Produk",
                    labelText: "Stok",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() => _stock = int.tryParse(value ?? '0') ?? 0);
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Stok tidak boleh kosong!";
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null) {
                      return "Stok harus berupa bilangan bulat.";
                    }
                    if (parsed < 0) {
                      return "Stok tidak boleh negatif.";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Produk",
                    labelText: "Deskripsi Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() => _description = value ?? "");
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    if (value.trim().length < 10) {
                      return "Minimal 10 karakter.";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category, // KOREKSI: Mengganti 'value' menjadi 'initialValue'
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat[0].toUpperCase() + cat.substring(1)),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() => _category = newValue ?? "lainnya");
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kategori wajib dipilih.";
                    }
                    return null;
                  },
                ),
              ),

              // === Thumbnail URL (opsional, tetapi jika diisi wajib valid) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Thumbnail (opsional)",
                    labelText: "URL Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() => _thumbnail = value ?? "");
                  },
                  validator: (String? value) {
                    final v = (value ?? "").trim();
                    if (v.isEmpty) return null; // opsional
                    final uri = Uri.tryParse(v);
                    final valid = uri != null && uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
                    if (!valid) return "URL harus http/https yang valid.";
                    if (v.length > 300) return "URL terlalu panjang.";
                    return null;
                  },
                ),
              ),

              // === Is Featured ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: const Text("Tandai sebagai Produk Unggulan"),
                  value: _isFeatured,
                  onChanged: (bool value) {
                    setState(() => _isFeatured = value);
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo), // KOREKSI: Mengganti MaterialStateProperty
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final price = double.parse(_priceText.trim().replaceAll(',', ''));
                        
                        final response = await request.postJson(
                          "http://localhost:8000/create-item-ajax/", 
                          jsonEncode({
                            "name": _name,
                            "price": price,
                            "description": _description,
                            "thumbnail": _thumbnail,
                            "category": _category,
                            "is_featured": _isFeatured,
                            "stock": _stock, // Kirim nilai stock
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Item berhasil ditambahkan!"),
                            ));
                            // Redirect ke Home setelah sukses
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()), 
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Gagal menambahkan item: ${response['message']}"),
                            ));
                          }
                        }
                      }
                    },
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
