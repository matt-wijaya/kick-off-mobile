# 📱 KickOff— Flutter PBP 25/26

## Overview
- **Student**: Matthew Wijaya
- **NPM**: _2406359203_  
- **Repository**: _[link-to-repo](https://github.com/matt-wijaya/kick-off-mobile.git)_  
---
# Tugas 2

## 1) Perbedaan antara Navigator.push() dan Navigator.pushReplacement()
Perbedaan antara Navigator.push dan Navigator.pushReplacement adalah bagaimana tombol back bisa digunakan. Pada push(), route sekarang akan dipush ke stack, jadi halaman sebelumnya posisinya tetap berada di bawah halaman kita saat ini dan kita dapat menekan tombol back untuk kembali. Sedangkan, pada pushReplacement() route sekarang akan mengganti route teratas (halaman sebelumnya). maka, tombol back tidak akan mengembalikan kita ke halaman sebelumnya. push() dalam aplikasi ini bisa digunakan saat berpindah dari tombol grid ke halaman form. Di sisi lain, ketika mengakses form dari drawer, pushReplacement() digunakan karena hanya berpidah antar dua halaman inti yang bisa diakses dengan drawer.

## 2) Pemanfaatan hierarchy widget untuk membangun struktur halaman yang konsisten
Untuk mengimplementasikan struktur yang konsisten, setiap halaman utama dibuat mengembalikan Scaffold yang berisi AppBar (judul dan warna sesuai theme), Drawer (LeftDrawer yang dipakai di semua page), dan body (yang bisa berubah-ubah). Dengan menerapkan template tersebut, AppBar dan Drawer ditempatkan di semua halaman dan hanya body yang diganti.

## 3) Kelebihan menggunakan layout widget saat menampilkan elemen-elemen form
Padding digunakan untuk memberi jarak antar objek atau widget, sehingga dapat lebih mudah dibaca dan adanya whitespace membuat pembaca tidak kewalahan. SingleChildScrollView digunakan untuk mencwgah overflow saat layar mengecil dan membuat form bisa discroll. Selain itu, ListView digunakan untuk menampilkan elemen yang banyak dan berulang supaya lebih efisien dan satu sama lainnya memiliki jarak yang konsisten. Saya menerapkan SingleChildScrollView dan Padding di Form pada bagian berikut 

<pre>
child: SingleChildScrollView(       
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(                      
          padding: const EdgeInsets.all(8.0),
</pre>

## 4) Menyesuaikan warna tema agar identitas visual konsisten
Untuk menyesuaikan warna tema agar identitas visual konsisten, kita dapat menentukan warna brand seperti primary dan secondary color yang kemudian di set di MaterialApp.theme dan menggunakannya dengan Theme.of(context).colorScheme di komponen-komponen yang ada supaya konsisten. Penggunaan ini juga sudah saya terapkan melalui MaterialApp di main.dart

<pre>
 theme: ThemeData(
         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.blueAccent),
</pre>

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