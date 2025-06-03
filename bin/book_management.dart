import 'buku.dart';
import 'koleksi_buku.dart';
import 'undo_manager.dart';
import 'sorter_searcher.dart';
import 'csv_utils.dart';
import 'dart:io';
import 'package:colorize/colorize.dart';

/**
 * Fungsi utama aplikasi Sistem Manajemen Buku.
 * 
 * Fungsi ini menginisialisasi aplikasi, memuat data dari file CSV,
 * dan menjalankan loop utama aplikasi yang menangani interaksi pengguna.
 */
void main() async {
  // Tampilkan header aplikasi
  tampilkanHeader();

  KoleksiBuku koleksi = KoleksiBuku();
  UndoManager undoManager = UndoManager();
  Map<String, List<Buku>> kategoriMap = {};
  String csvPath = 'koleksi_buku.csv';

  // Muat data dari CSV
  Colorize loadingMsg = Colorize('Memuat data buku...');
  loadingMsg.blue().bold();
  print(loadingMsg);

  List<Buku> bukuList = await CsvUtils.muatDariCsv(csvPath);
  koleksi.fromList(bukuList);
  updateKategoriMap(koleksi, kategoriMap);

  Colorize successMsg = Colorize('✓ ${bukuList.length} buku berhasil dimuat!');
  successMsg.green().bold();
  print(successMsg);

  while (true) {
    tampilkanMenu();
    String? pilihan = stdin.readLineSync();
    if (pilihan == '1') {
      Colorize header = Colorize('\n📚 DAFTAR KOLEKSI BUKU 📚');
      header.green().bold();
      print(header);
      print(garisPemisah());
      tampilkanKoleksi(koleksi);
    } else if (pilihan == '2') {
      stdout.write('Judul: ');
      String judul = stdin.readLineSync() ?? '';
      stdout.write('Penulis: ');
      String penulis = stdin.readLineSync() ?? '';
      stdout.write('ISBN: ');
      String isbn = stdin.readLineSync() ?? '';
      stdout.write('Tahun: ');
      int tahun = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
      stdout.write('Kategori: ');
      String kategori = stdin.readLineSync() ?? '';
      Buku bukuBaru = Buku(
          judul: judul,
          penulis: penulis,
          isbn: isbn,
          tahun: tahun,
          kategori: kategori);
      koleksi.tambah(bukuBaru);
      undoManager.push(UndoAction('tambah', bukuBaru));
      updateKategoriMap(koleksi, kategoriMap);
      Colorize successMsg = Colorize('✓ Buku berhasil ditambahkan!');
      successMsg.green().bold();
      print(successMsg);
    } else if (pilihan == '3') {
      stdout.write('Masukkan ISBN buku yang ingin dihapus: ');
      String isbn = stdin.readLineSync() ?? '';
      Buku? bukuDihapus = koleksi.cariByIsbn(isbn);
      if (bukuDihapus != null && koleksi.hapus(isbn)) {
        undoManager.push(UndoAction('hapus', bukuDihapus));
        updateKategoriMap(koleksi, kategoriMap);
        Colorize successMsg = Colorize('✓ Buku berhasil dihapus!');
        successMsg.green().bold();
        print(successMsg);
      } else {
        Colorize errorMsg = Colorize('✗ Buku tidak ditemukan!');
        errorMsg.red().bold();
        print(errorMsg);
      }
    } else if (pilihan == '4') {
      Colorize searchHeader = Colorize('\n🔍 PENCARIAN BUKU 🔍');
      searchHeader.cyan().bold();
      print(searchHeader);
      print(garisPemisah());

      Colorize promptMsg = Colorize('Masukkan kata kunci judul buku: ');
      promptMsg.yellow();
      stdout.write(promptMsg);

      String keyword = stdin.readLineSync() ?? '';

      if (keyword.isEmpty) {
        Colorize errorMsg = Colorize('✗ Kata kunci tidak boleh kosong!');
        errorMsg.red().bold();
        print(errorMsg);
        continue;
      }

      // Coba pencarian persis terlebih dahulu
      Buku? hasilCariPersis =
          Searcher.linearSearchByJudul(koleksi.toList(), keyword);

      // Jika ditemukan kecocokan persis, tampilkan detail buku
      if (hasilCariPersis != null) {
        Colorize foundMsg = Colorize('✓ Ditemukan kecocokan persis:');
        foundMsg.green().bold();
        print(foundMsg);
        tampilkanDetailBuku(hasilCariPersis);
      } else {
        // Jika tidak ada kecocokan persis, cari dengan kata kunci
        List<Buku> hasilCariKeyword =
            Searcher.searchByKeyword(koleksi.toList(), keyword);

        if (hasilCariKeyword.isNotEmpty) {
          Colorize foundMsg = Colorize(
              '✓ Ditemukan ${hasilCariKeyword.length} buku dengan kata kunci "$keyword":');
          foundMsg.green().bold();
          print(foundMsg);
          print(garisPemisah());

          // Header tabel
          Colorize headerNo = Colorize('NO'.padRight(5));
          Colorize headerJudul = Colorize('JUDUL'.padRight(30));
          Colorize headerPenulis = Colorize('PENULIS'.padRight(20));
          Colorize headerTahun = Colorize('TAHUN');

          headerNo.bold().yellow();
          headerJudul.bold().yellow();
          headerPenulis.bold().yellow();
          headerTahun.bold().yellow();

          print(
              '${headerNo} | ${headerJudul} | ${headerPenulis} | ${headerTahun}');
          print(garisPemisah());

          // Tampilkan hasil pencarian
          for (int i = 0; i < hasilCariKeyword.length; i++) {
            Buku buku = hasilCariKeyword[i];
            Colorize nomorStr =
                Colorize('${(i + 1).toString().padLeft(2, '0')}');
            nomorStr.yellow();

            String judul = buku.judul.length > 28
                ? '${buku.judul.substring(0, 25)}...'
                : buku.judul.padRight(30);
            String penulis = buku.penulis.length > 18
                ? '${buku.penulis.substring(0, 15)}...'
                : buku.penulis.padRight(20);
            String tahun = buku.tahun.toString().padRight(5);

            print('${nomorStr}   | $judul | $penulis | $tahun');
          }

          print(garisPemisah());

          // Opsi untuk melihat detail buku
          Colorize detailPrompt = Colorize(
              'Pilih nomor buku untuk melihat detail (0 untuk kembali): ');
          detailPrompt.yellow();
          stdout.write(detailPrompt);

          String? pilihanDetail = stdin.readLineSync();
          int nomorBuku = int.tryParse(pilihanDetail ?? '') ?? 0;

          if (nomorBuku > 0 && nomorBuku <= hasilCariKeyword.length) {
            tampilkanDetailBuku(hasilCariKeyword[nomorBuku - 1]);
          }
        } else {
          Colorize errorMsg =
              Colorize('✗ Tidak ditemukan buku dengan kata kunci "$keyword"!');
          errorMsg.red().bold();
          print(errorMsg);
        }
      }
    } else if (pilihan == '5') {
      List<Buku> listUrut = koleksi.toList();
      Sorter.bubbleSortByJudul(listUrut);
      Colorize header = Colorize('\n📋 KOLEKSI DIURUTKAN BERDASARKAN JUDUL 📋');
      header.cyan().bold();
      print(header);
      print(garisPemisah());
      int nomor = 1;
      for (var b in listUrut) {
        Colorize nomorStr = Colorize('${nomor.toString().padLeft(3, '0')}');
        nomorStr.yellow();
        print('${nomorStr} | ${formatBukuInfo(b)}');
        nomor++;
      }
    } else if (pilihan == '6') {
      UndoAction? last = undoManager.pop();
      if (last != null) {
        if (last.type == 'tambah') {
          koleksi.hapus((last.data as Buku).isbn);
          Colorize undoMsg = Colorize('↩ Undo tambah buku berhasil!');
          undoMsg.magenta().bold();
          print(undoMsg);
        } else if (last.type == 'hapus') {
          koleksi.tambah(last.data as Buku);
          Colorize undoMsg = Colorize('↩ Undo hapus buku berhasil!');
          undoMsg.magenta().bold();
          print(undoMsg);
        }
        updateKategoriMap(koleksi, kategoriMap);
      } else {
        Colorize errorMsg = Colorize('✗ Tidak ada aksi untuk di-undo!');
        errorMsg.red().bold();
        print(errorMsg);
      }
    } else if (pilihan == '7') {
      await CsvUtils.simpanKeCsv(csvPath, koleksi.toList());
      Colorize exitMsg = Colorize(
          '💾 Data disimpan. Terima kasih telah menggunakan aplikasi ini!');
      exitMsg.green().bold();
      print(exitMsg);
      break;
    } else {
      Colorize errorMsg = Colorize('✗ Pilihan tidak valid!');
      errorMsg.red().bold();
      print(errorMsg);
    }
  }
}

/**
 * Menampilkan koleksi buku dalam bentuk tabel.
 * 
 * Fungsi ini menampilkan semua buku dalam koleksi dengan format tabel
 * yang berisi judul, penulis, ISBN, tahun, dan kategori buku.
 * Jika koleksi kosong, akan ditampilkan pesan "Koleksi kosong".
 * 
 * @param koleksi Objek KoleksiBuku yang berisi daftar buku yang akan ditampilkan
 */
void tampilkanKoleksi(KoleksiBuku koleksi) {
  Node? current = koleksi.head;
  if (current == null) {
    Colorize emptyMsg = Colorize('Koleksi kosong.');
    emptyMsg.italic().yellow();
    print(emptyMsg);
    return;
  }

  // Header tabel
  Colorize headerJudul = Colorize('JUDUL'.padRight(30));
  Colorize headerPenulis = Colorize('PENULIS'.padRight(20));
  Colorize headerISBN = Colorize('ISBN'.padRight(15));
  Colorize headerTahun = Colorize('TAHUN');
  Colorize headerKategori = Colorize('KATEGORI'.padRight(20));

  headerJudul.bold().yellow();
  headerPenulis.bold().yellow();
  headerISBN.bold().yellow();
  headerTahun.bold().yellow();
  headerKategori.bold().yellow();

  print(
      '${headerJudul} | ${headerPenulis} | ${headerISBN} | ${headerTahun} | ${headerKategori}');
  print(garisPemisah());

  int nomor = 1;
  while (current != null) {
    Buku b = current.data;
    Colorize nomorStr = Colorize('${nomor.toString().padLeft(3, '0')}');
    nomorStr.yellow();
    print('${nomorStr} | ${formatBukuInfo(b)}');
    current = current.next;
    nomor++;
  }
}

/**
 * Memperbarui peta kategori buku.
 * 
 * Fungsi ini memperbarui peta yang mengelompokkan buku berdasarkan kategorinya.
 * Peta ini dapat digunakan untuk mengakses buku-buku berdasarkan kategori dengan cepat.
 * 
 * @param koleksi Objek KoleksiBuku yang berisi daftar buku
 * @param kategoriMap Peta yang akan diperbarui, dengan kunci berupa nama kategori dan nilai berupa daftar buku
 */
void updateKategoriMap(
    KoleksiBuku koleksi, Map<String, List<Buku>> kategoriMap) {
  kategoriMap.clear();
  for (var buku in koleksi.toList()) {
    kategoriMap.putIfAbsent(buku.kategori, () => []).add(buku);
  }
}

/**
 * Menampilkan header aplikasi.
 * 
 * Fungsi ini menampilkan header dekoratif dengan judul dan subtitle aplikasi.
 * Header ini ditampilkan saat aplikasi pertama kali dijalankan.
 */
void tampilkanHeader() {
  print('\n');
  Colorize header =
      Colorize('╔═══════════════════════════════════════════════╗');
  header.cyan();
  print(header);

  Colorize title = Colorize('║           SISTEM MANAJEMEN BUKU             ║');
  title.cyan().bold();
  print(title);

  Colorize subtitle =
      Colorize('║      Aplikasi Pengelolaan Koleksi Buku      ║');
  subtitle.cyan();
  print(subtitle);

  Colorize footer =
      Colorize('╚═══════════════════════════════════════════════╝');
  footer.cyan();
  print(footer);
  print('\n');
}

/**
 * Menampilkan menu utama aplikasi.
 * 
 * Fungsi ini menampilkan daftar opsi menu yang tersedia untuk pengguna.
 * Menu ini ditampilkan setiap kali pengguna perlu memilih operasi yang akan dilakukan.
 */
void tampilkanMenu() {
  print('\n');
  Colorize menuHeader = Colorize('📋 MENU UTAMA 📋');
  menuHeader.green().bold();
  print(menuHeader);

  print(garisPemisah());

  Colorize menu1 = Colorize('1. Tampilkan Koleksi Buku');
  menu1.white();
  print(menu1);

  Colorize menu2 = Colorize('2. Tambah Buku');
  menu2.white();
  print(menu2);

  Colorize menu3 = Colorize('3. Hapus Buku');
  menu3.white();
  print(menu3);

  Colorize menu4 = Colorize('4. Cari Buku');
  menu4.white();
  print(menu4);

  Colorize menu5 = Colorize('5. Urutkan Buku');
  menu5.white();
  print(menu5);

  Colorize menu6 = Colorize('6. Undo Aksi Terakhir');
  menu6.white();
  print(menu6);

  Colorize menu7 = Colorize('7. Simpan & Keluar');
  menu7.white();
  print(menu7);

  print(garisPemisah());

  Colorize prompt = Colorize('Pilih menu (1-7): ');
  prompt.yellow();
  stdout.write(prompt);
}

/**
 * Membuat garis pemisah horizontal.
 * 
 * Fungsi ini membuat garis pemisah yang digunakan untuk memisahkan
 * bagian-bagian dalam tampilan aplikasi, seperti header dan konten.
 * 
 * @return String berupa garis pemisah horizontal
 */
String garisPemisah() {
  return '─' * 50;
}

/**
 * Memformat informasi buku untuk ditampilkan.
 * 
 * Fungsi ini memformat informasi buku (judul, penulis, ISBN, tahun, kategori)
 * agar sesuai dengan lebar kolom yang telah ditentukan. Jika teks terlalu panjang,
 * akan dipotong dan ditambahkan elipsis (...).
 * 
 * @param b Objek Buku yang informasinya akan diformat
 * @return String berupa informasi buku yang telah diformat
 */
String formatBukuInfo(Buku b) {
  String judul = b.judul.length > 28
      ? '${b.judul.substring(0, 25)}...'
      : b.judul.padRight(30);
  String penulis = b.penulis.length > 18
      ? '${b.penulis.substring(0, 15)}...'
      : b.penulis.padRight(20);
  String isbn = b.isbn.padRight(15);
  String tahun = b.tahun.toString().padRight(5);
  String kategori = b.kategori.length > 18
      ? '${b.kategori.substring(0, 15)}...'
      : b.kategori.padRight(20);

  return '$judul | $penulis | $isbn | $tahun | $kategori';
}

/**
 * Menampilkan detail lengkap sebuah buku.
 * 
 * Fungsi ini menampilkan semua informasi detail tentang sebuah buku,
 * termasuk judul, penulis, ISBN, tahun terbit, dan kategori.
 * Informasi ditampilkan dengan format yang lebih rapi dan berwarna.
 * 
 * @param buku Objek Buku yang detailnya akan ditampilkan
 */
void tampilkanDetailBuku(Buku buku) {
  print(garisPemisah());

  Colorize judulLabel = Colorize('Judul    : ');
  judulLabel.cyan().bold();
  Colorize judulValue = Colorize(buku.judul);
  judulValue.white();
  print('${judulLabel}${judulValue}');

  Colorize penulisLabel = Colorize('Penulis  : ');
  penulisLabel.cyan().bold();
  Colorize penulisValue = Colorize(buku.penulis);
  penulisValue.white();
  print('${penulisLabel}${penulisValue}');

  Colorize isbnLabel = Colorize('ISBN     : ');
  isbnLabel.cyan().bold();
  Colorize isbnValue = Colorize(buku.isbn);
  isbnValue.white();
  print('${isbnLabel}${isbnValue}');

  Colorize tahunLabel = Colorize('Tahun    : ');
  tahunLabel.cyan().bold();
  Colorize tahunValue = Colorize(buku.tahun.toString());
  tahunValue.white();
  print('${tahunLabel}${tahunValue}');

  Colorize kategoriLabel = Colorize('Kategori : ');
  kategoriLabel.cyan().bold();
  Colorize kategoriValue = Colorize(buku.kategori);
  kategoriValue.white();
  print('${kategoriLabel}${kategoriValue}');

  print(garisPemisah());
}
