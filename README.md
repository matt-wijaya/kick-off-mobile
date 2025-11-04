# 📱 KickOff— Flutter PBP 25/26

## Overview
- **Student**: Matthew Wijaya
- **NPM**: _2406359203_  
- **Repository**: _[link-to-repo](https://github.com/matt-wijaya/kick-off-mobile.git)_  
---
# Tugas 1

## 1) Apa itu widget tree pada Flutter dan bagaimana hubungan parent–child bekerja?
Widget tree pada flutter adalah struktur hierarkis yang merepresentasikan UI dari suatu aplikasi. Setiap elemen di dalam UI adalah sebuah widget dan memiliki posisinya masing-masing di dalam tree yang ada. MaterialApp biasanaya berperan sebagai root, dan Scaffold akan menjadi parent untuk area screen. Hubungan parent dan child menentukan bagaimana ukuran, posisi, tema, dan perilaku dari parent di inherit ke childnya sehingga adanya constraints yang berlaku untuk semua. 
## 2) Semua widget yang saya gunakan & fungsinya
Dalam project ini, saya menggunakan MaterialApp sebagai wrapper dari app, kemudian Scaffold digunakan sebagai blueprint template dari lapangan yang memprovide appBar, Body, dan Snackbar), AppBar menampilkan judul dia tas. Di dalam body, ada padding yang memberi jarak ke sisi, dan GridView.count yang tiga buah tombol yang sudah dibuat ke dalam tiga kolom. Setiap tombol adalah kombinasi material, InkWell, dan Container yang mewrap isinya. Tombol menggunakan Collumn dan Center untuk memposisikan Icon dan Text. 

## 3) Fungsi `MaterialApp` & alasan sering jadi widget root
MaterialApp berperan sebagai dasar dari Material Design yang meliputi navigator, global theme, default text direction, scaffoldMessenger, dan sebagainya. Widget Material mengandalkan hal-hal tersebut. Maka, jika kita meng-add MaterialApp sebagai root, kita bisa memastikan seluruh subtree memperoleh semua kebutuhan mereka. 

## 4) Perbedaan `StatelessWidget` vs `StatefulWidget` & kapan memilih
Stateless Widget dimanfaatkan untuk UI yang ditentukan oleh input saat ini dan tidak berubah seiring waktu (immutable) dan hanya berubah jika dependensinya berubah. Contoh dalam konteks ini adalah tombol yang labelnya tetap.

Stateful Widget di sisi lain digunakan untuk UI yang harus menyimpan dan mengelola state yang ada selama dia berlaku, contohnya seperti form validation, animasi, data baru, dan sebagainya. 

StatelessWidget digunakan ketika tampilan tidak berubah dan hanya bergantung pada argumen. Sementara StatefulWidget digunakan ketika membutuhkan penyimpanan nilai yang berubah-ubah selama widget ada.

## 5) Apa itu `BuildContext`, pentingnya, & penggunaannya di `build()`
BuildContext adalah lokasi sebuah widget dalam widget tree. Dari adanya itu, widget bisa mengakses parentnya, parent dari parentnya, dan seterusnya serta atribut-atribut yang dimiliki parent tersebut. Contohnya adalah tema, ukuran layar, navigator, dan widget yang diwariskan.

Harus ada konteks dalam pemanggilan build(BuildContext context), konteks yang diterima harus digunakan untuk membuat subtree baru. Context terlink dengan posisi widget, maka mencall of(context) harus menggunakan konteks yang juga berada di bawah ancestor yang terkait. 

## 6) Konsep "hot reload" vs "hot restart"
Hot reload adalah merebuild widget tree tanpa mengulang proses app start, sehingga state yang tersimpan di memori tetap dipertahankan. Perubahan UI dapat berjalan dengan lebih cepat dan pengaturan layout dapat dipertahankan. Di sisi lain, hot restart akan merebuild ulang aplikasi dari awal tanpa menghentikan engine, tetapi menghapus state yang sudah disimpan sehingga kembali ke kondisi awal. Hot restart umumnya diterapkan jika perubahan yang terjadi di hot reload tidak mengcover perubahan tertentu yang kita inginkan.