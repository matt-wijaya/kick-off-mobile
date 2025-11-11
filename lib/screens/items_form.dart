import 'package:flutter/material.dart';
import 'package:kickoff/widgets/left_drawer.dart';

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

  final List<String> _categories = [
    'jersey',
    'sepatu',
    'bola',
    'aksesoris',
    'lainnya',
  ];

  @override
  Widget build(BuildContext context) {
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
                  value: _category,
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
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final price = double.parse(_priceText.trim().replaceAll(',', ''));
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Produk berhasil tersimpan'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama: $_name'),
                                    Text('Harga: $price'),
                                    Text('Deskripsi: $_description'),
                                    Text('Kategori: $_category'),
                                    Text('Thumbnail: ${_thumbnail.isEmpty ? "-" : _thumbnail}'),
                                    Text('Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context); // tutup dialog
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _name = "";
                                      _priceText = "";
                                      _description = "";
                                      _thumbnail = "";
                                      _isFeatured = false;
                                      _category = "lainnya";
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
