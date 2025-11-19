# 📱 KickOff— Flutter PBP 25/26

## Overview
- **Student**: Matthew Wijaya
- **NPM**: _2406359203_  
- **Repository**: _[link-to-repo](https://github.com/matt-wijaya/kick-off-mobile.git)_  
---

## Tugas 9

### 1. Peran Model Dart dalam Data JSON

Kita perlu membuat model Dart (`Item`) saat mengambil atau mengirim data JSON karena alasan berikut,

* **Validasi Tipe dan Null-Safety:** Model Dart memungkinkan pengecekan tipe data pada saat kompilasi. Jika kita tidak menggunakan model, kita akan menggunakan `Map<String, dynamic>`, yang memaksa kita menggunakan operator `!` atau `as T` yang sangat mungkin menghasilkan terhadap *runtime errors* jika struktur JSON dari backend berubah (misalnya, jika `price` tiba-tiba bernilai `null` atau `String` alih-alih `int`). Model memastikan konsistensi di struktur sesuai apa yang kita mau.
* **Maintainability dan Readability:** Model menyediakan representasi data yang jelas dan terstruktur. Pakai `item.fields.name` jauh lebih mudah dibaca dan dimaintain daripada `item['fields']['name']`.

### 2. Fungsi Package `http` vs `CookieRequest`

* **Package `http`:** adalah *library* dasar yang digunakan untuk melakukan semua operasi HTTP (GET, POST, dll.) di Dart. `http` bertanggung jawab untuk mengirimkan permintaan dan menerima respons yang nantinya akan diformat dari server.
* **Package `pbp_django_auth` (`CookieRequest`):** adalah *wrapper* yang dibangun di atas `http`. Perannya antara lain,
    * **Session Management:** Secara otomatis menangani pengiriman dan penerimaan *cookies* (`sessionid` dan `csrftoken`) yang diperlukan Django untuk melacak kondisi session dan autentikasi pengguna.
    * **Kemudahan Penggunaan:** Menyediakan method khusus (`login`, `logout`, `postJson`) dan memastikan *header* CSRF selalu diinclude dalam request POST.

### 3. Pentingnya Berbagi Instance `CookieRequest`

Instance `CookieRequest` perlu dibagikan ke seluruh komponen aplikasi Flutter karena berguna dalam,

* **Mempertahankan Sesi:** Setelah pengguna berhasil login, objek `CookieRequest` akan menyimpan *session cookie* dan *CSRF token*. Semua permintaan HTTP berikutnya (seperti mengambil daftar item milik pengguna atau menambah item baru) harus menggunakan *cookies* ini untuk membuktikan bahwa pengguna masih terautentikasi dan otorized.
* **State Management:** Setelah dibagi, setiap widget di *widget tree* bisa mengakses *state* login (`request.loggedIn`) dan menggunakan *instance* yang sama untuk melakukan transaksi, sehingga sesi autentikasi tetap hidup (pengguna ga harus login berulang kali)

### 4. Konfigurasi Konektivitas (Penting!)

| Konfigurasi | Tujuan | Konsekuensi Jika Salah |
| :--- | :--- | :--- |
| **`10.0.2.2`** di `ALLOWED_HOSTS` | `10.0.2.2` adalah alias untuk Android Emulator yang merujuk ke mesin *host* tempat Django berjalan. | Koneksi ditolak (Connection refused) saat mencoba mengakses Django dari Emulator. |
| **Aktivasi CORS** (`django-cors-headers`) | Membuat permintaan *cross-origin* dari Flutter/Emulator ke Django jadi mungkin. | Permintaan diblokir oleh Django, menghasilkan *CORS policy error* (misalnya, data gak terambil). |
| **Pengaturan SameSite/Secure Cookie** | Memastikan Django mengirim *cookies* (session dan CSRF) meskipun permintaan datang dari domain yang dianggap *cross-site* (Flutter). | Autentikasi gagal (Flutter tidak dapat menyimpan *session*), dan *request* POST/PUT diblokir oleh Django karena CSRF token hilang. |
| **Izin Internet (Android Manifest)** | Memberi izin pada aplikasi Android (Flutter) untuk mengakses Internet atau API. | Aplikasi gak dapat terhubung ke URL manapun, termasuk URL Django. |

### 5. Mekanisme Pengiriman Data (Input Form)

Mekanisme pengiriman data item baru dari Flutter ke Django,

1.  **Input & Validasi (Flutter):** Pengguna mengisi form (`items_form.dart`). Data disimpan dalam variabel *state* (`_name`, `_priceText`, dsb.).
2.  **Encoding (Flutter):** Setelah form divalidasi, data *state* dikumpulkan menjadi objek Dart (`Map`), lalu diubah menjadi format **JSON String** menggunakan `jsonEncode`.
3.  **Pengiriman (Flutter):** `request.postJson(url, jsonString)` dari `pbp_django_auth` mengirimkan JSON String sebagai *body* dari request POST, sambil secara otomatis menyertakan *header* berupa **CSRF token**.
4.  **Penerimaan & Decoding (Django):** Fungsi `create_item_ajax` (`main/views.py`) menerima request POST. Karena ada dekorator `@csrf_exempt`, Django memproses `request.body` (yang berisi JSON String) dan mengonversinya kembali menjadi *Python Dictionary* pakai `json.loads()`.
5.  **Penyimpanan (Django):** Data dari *dictionary* disuntikkan ke `ItemForm`, divalidasi, dan disimpan ke database, sesuai dengan `request.user`.
6.  **Respons (Django):** Django mengirim `JsonResponse` (`{"status": "success", ...}`) kembali ke Flutter.
7.  **Konfirmasi (Flutter):** Flutter membaca `response['status']`, menampilkan `AlertDialog` sukses, dan mengarahkan pengguna ke halaman utama.

### 6. Mekanisme Autentikasi

Mekanisme autentikasi dari Flutter ke Django diotomatisasi oleh `CookieRequest`:

1.  **Register (Flutter):** Data username/password diencode ke JSON dan dikirimkan melalui `request.postJson()` ke endpoint Django `auth/register/`. Django membuat objek `User` baru dan merespons dengan status sukses/gagal.
2.  **Login (Flutter):** Data username/password dikirim melalui `request.login()` ke endpoint Django `auth/login/`.
3.  **Otentikasi (Django):** Django menggunakan `authenticate(username, password)`. Jika berhasil, Django memanggil `auth_login(request, user)`, yang secara internal **membuat ID sesi baru dan mengirimkannya kembali ke Flutter** melalui *cookie*.
4.  **Penyimpanan Sesi (Flutter):** `CookieRequest` menerima *cookie* sesi dan menyimpannya. Pengguna dianggap `request.loggedIn = true`.
5.  **Logout (Flutter):** `request.logout()` dipanggil ke endpoint Django `auth/logout/`. Django memanggil `auth_logout(request)`, yang **menghapus data sesi** di server dan memberi sinyal ke Flutter untuk menghapus *cookie* sesi yang tersimpan. Flutter kemudian diarahkan ke `LoginPage`.

---

## 7. Ringkasan Implementasi Step-by-Step

Berikut adalah ringkasan langkah-langkah implementasi yang Anda lakukan:

1.  **Backend Setup (Django):**
    * Menginstal `django-cors-headers` dan menambahkannya ke `requirements.txt`.
    * Mengkonfigurasi `settings.py` (menambahkan `corsheaders` ke `MIDDLEWARE`, mengatur `CORS_ALLOW_ALL_ORIGINS`, dan menambahkan `10.0.2.2` ke `ALLOWED_HOSTS`).
    * Membuat aplikasi `authentication` dan mendefinisikan `views.py` untuk menangani `login`, `register`, dan `logout` dengan respons `JsonResponse`.
    * Memperbarui `kick_off/urls.py` untuk menyertakan `path('auth/', include('authentication.urls'))`.
2.  **Model Flutter:**
    * Mendefinisikan model `Item` dan `Fields` di Dart untuk memetakan struktur JSON dari *Django Serializer*.
3.  **Flutter Setup & Autentikasi:**
    * Menambahkan `provider` dan `pbp_django_auth` ke `pubspec.yaml`.
    * Memodifikasi `lib/main.dart` untuk membungkus `MaterialApp` dengan `Provider` dan menginisialisasi `CookieRequest`.
    * Mengimplementasikan `LoginPage` dan `RegisterPage` (`lib/screens/login.dart`, `lib/screens/register.dart`) yang menggunakan `request.login()` dan `request.postJson()`.
4.  **Fitur Data dan Navigasi:**
    * Mengimplementasikan `ItemListPage` (`list_item.dart`) dengan `FutureBuilder` untuk memanggil `http://localhost:8000/get-items-json/`.
    * Menambahkan *check* `snapshot.data!.isEmpty` di `ItemListPage` untuk menampilkan pesan "Belum ada item." saat daftar kosong.
    * Memperbarui `lib/menu.dart` agar tombol-tombolnya (All Products, My Products, Logout) menavigasi ke halaman yang benar dengan parameter filter yang sesuai, dan menggunakan `request.logout()`.
    * Mengimplementasikan `ItemDetailPage` (`item_detail.dart`) dengan `SingleChildScrollView` dan *layout* yang ditingkatkan.
5.  **Form Submission Fix:**
    * Memperbarui `lib/screens/items_form.dart` untuk menggunakan `request.postJson()` ke `create-item-ajax/` alih-alih `showDialog` lokal.
    * Menambahkan kembali `AlertDialog` detail item di blok sukses `postJson` sebelum menavigasi kembali ke `MyHomePage`.

---
# Tugas 8

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

# Tugas 7

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