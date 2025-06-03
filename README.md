# Sistem Manajemen Buku

## Deskripsi

Sistem Manajemen Buku adalah aplikasi berbasis command-line yang dibangun dengan bahasa pemrograman Dart. Aplikasi ini dirancang untuk membantu pengguna mengelola koleksi buku dengan fitur-fitur seperti menambah, menghapus, mencari, dan mengurutkan buku. Data buku disimpan dalam format CSV untuk memudahkan penyimpanan dan pengambilan data.

## Fitur Utama

- Menampilkan koleksi buku dalam format tabel
- Menambahkan buku baru ke koleksi
- Menghapus buku dari koleksi berdasarkan ISBN
- Mencari buku berdasarkan judul atau kata kunci
- Mengurutkan buku berdasarkan judul
- Fitur undo untuk membatalkan aksi terakhir
- Menyimpan dan memuat data dari file CSV

## Struktur Proyek

- `bin/`: Direktori utama yang berisi kode sumber aplikasi
  - `book_management.dart`: File utama yang berisi logika aplikasi dan fungsi main
  - `buku.dart`: Mendefinisikan kelas Buku yang merepresentasikan entitas buku
  - `koleksi_buku.dart`: Implementasi struktur data linked list untuk menyimpan koleksi buku
  - `undo_manager.dart`: Mengelola fitur undo untuk membatalkan aksi
  - `sorter_searcher.dart`: Berisi algoritma pengurutan dan pencarian buku
  - `csv_utils.dart`: Utilitas untuk menyimpan dan memuat data dari/ke file CSV
- `koleksi_buku.csv`: File CSV yang menyimpan data buku
- `pubspec.yaml`: File konfigurasi dependensi proyek

## Teknologi yang Digunakan

- Bahasa Pemrograman: Dart
- Struktur Data: Linked List untuk menyimpan koleksi buku
- Algoritma Pengurutan: Bubble Sort dan Quick Sort
- Algoritma Pencarian: Linear Search dan Binary Search
- Format Penyimpanan Data: CSV (Comma-Separated Values)
- Paket Eksternal: colorize (untuk tampilan berwarna di terminal)

## Cara Menggunakan

1. Pastikan Dart SDK telah terinstal di sistem Anda
2. Clone repositori ini
3. Buka terminal dan navigasikan ke direktori proyek
4. Jalankan perintah `dart run bin/book_management.dart`
5. Ikuti menu yang ditampilkan untuk menggunakan fitur-fitur aplikasi

## Menu Aplikasi

1. Tampilkan Koleksi Buku: Menampilkan semua buku dalam koleksi
2. Tambah Buku: Menambahkan buku baru ke koleksi
3. Hapus Buku: Menghapus buku dari koleksi berdasarkan ISBN
4. Cari Buku: Mencari buku berdasarkan judul atau kata kunci
5. Urutkan Buku: Mengurutkan dan menampilkan buku berdasarkan judul
6. Undo Aksi Terakhir: Membatalkan aksi terakhir (tambah/hapus buku)
7. Simpan & Keluar: Menyimpan data ke file CSV dan keluar dari aplikasi

## Implementasi Struktur Data dan Algoritma

- **Linked List**: Digunakan untuk menyimpan koleksi buku, memungkinkan operasi tambah dan hapus yang efisien
- **Bubble Sort**: Algoritma pengurutan sederhana untuk mengurutkan buku berdasarkan judul
- **Quick Sort**: Algoritma pengurutan yang lebih efisien untuk mengurutkan buku berdasarkan tahun
- **Linear Search**: Algoritma pencarian sekuensial untuk mencari buku berdasarkan judul
- **Binary Search**: Algoritma pencarian yang lebih efisien untuk mencari buku berdasarkan ISBN (memerlukan data terurut)

## Pengembangan Lebih Lanjut

Beberapa ide untuk pengembangan lebih lanjut:

- Menambahkan fitur filter buku berdasarkan kategori
- Implementasi fitur redo untuk mengembalikan aksi yang telah di-undo
- Menambahkan fitur ekspor data ke format lain seperti JSON atau PDF
- Membuat antarmuka grafis (GUI) untuk aplikasi
- Menambahkan fitur peminjaman dan pengembalian buku
