import 'buku.dart';

/**
 * Kelas Sorter menyediakan berbagai algoritma pengurutan (sorting)
 * untuk mengurutkan koleksi buku berdasarkan kriteria tertentu.
 */
class Sorter {
  /**
   * Mengurutkan daftar buku menggunakan algoritma Bubble Sort berdasarkan judul buku.
   * Bubble Sort bekerja dengan membandingkan dua elemen bersebelahan dan menukarnya
   * jika tidak dalam urutan yang benar, proses ini diulang hingga seluruh daftar terurut.
   * 
   * Kompleksitas waktu: O(n²) di mana n adalah jumlah buku dalam daftar.
   * 
   * @param list Daftar buku yang akan diurutkan
   */
  static void bubbleSortByJudul(List<Buku> list) {
    int n = list.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        // Bandingkan judul buku menggunakan metode compareTo
        if (list[j].judul.compareTo(list[j + 1].judul) > 0) {
          // Tukar posisi buku jika tidak dalam urutan yang benar
          var temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
  }

  /**
   * Mengurutkan daftar buku menggunakan algoritma Quick Sort berdasarkan tahun terbit.
   * Quick Sort adalah algoritma pengurutan yang efisien dengan pendekatan divide-and-conquer.
   * 
   * Kompleksitas waktu rata-rata: O(n log n) di mana n adalah jumlah buku dalam daftar.
   * 
   * @param list Daftar buku yang akan diurutkan
   * @param low Indeks bawah dari bagian daftar yang akan diurutkan
   * @param high Indeks atas dari bagian daftar yang akan diurutkan
   */
  static void quickSortByTahun(List<Buku> list, int low, int high) {
    if (low < high) {
      // Partisi daftar dan dapatkan indeks pivot
      int pi = _partition(list, low, high);

      // Urutkan elemen sebelum dan sesudah pivot secara rekursif
      quickSortByTahun(list, low, pi - 1);
      quickSortByTahun(list, pi + 1, high);
    }
  }

  /**
   * Metode pembantu untuk algoritma Quick Sort yang mempartisi daftar
   * dan mengembalikan indeks pivot.
   * 
   * @param list Daftar buku yang akan dipartisi
   * @param low Indeks bawah dari bagian daftar yang akan dipartisi
   * @param high Indeks atas dari bagian daftar yang akan dipartisi
   * @return Indeks pivot setelah partisi
   */
  static int _partition(List<Buku> list, int low, int high) {
    // Pilih elemen terakhir sebagai pivot
    int pivot = list[high].tahun;
    int i = low - 1;

    // Bandingkan setiap elemen dengan pivot
    for (int j = low; j < high; j++) {
      if (list[j].tahun < pivot) {
        i++;
        // Tukar elemen jika lebih kecil dari pivot
        var temp = list[i];
        list[i] = list[j];
        list[j] = temp;
      }
    }

    // Tempatkan pivot di posisi yang benar
    var temp = list[i + 1];
    list[i + 1] = list[high];
    list[high] = temp;
    return i + 1;
  }
}

/**
 * Kelas Searcher menyediakan berbagai algoritma pencarian (searching)
 * untuk mencari buku dalam koleksi berdasarkan kriteria tertentu.
 */
class Searcher {
  /**
   * Mencari buku berdasarkan judul menggunakan algoritma Linear Search.
   * Linear Search memeriksa setiap elemen dalam daftar satu per satu.
   * Pencarian ini mencari kecocokan persis (case-insensitive).
   * 
   * Kompleksitas waktu: O(n) di mana n adalah jumlah buku dalam daftar.
   * 
   * @param list Daftar buku yang akan dicari
   * @param judul Judul buku yang dicari
   * @return Objek Buku jika ditemukan, null jika tidak ditemukan
   */
  static Buku? linearSearchByJudul(List<Buku> list, String judul) {
    for (var buku in list) {
      // Bandingkan judul buku dengan judul yang dicari (case-insensitive)
      if (buku.judul.toLowerCase() == judul.toLowerCase()) {
        return buku;
      }
    }
    return null; // Buku tidak ditemukan
  }

  /**
   * Mencari buku berdasarkan kata kunci dalam judul.
   * Pencarian ini mencari kecocokan parsial (substring) dalam judul buku.
   * 
   * Kompleksitas waktu: O(n) di mana n adalah jumlah buku dalam daftar.
   * 
   * @param list Daftar buku yang akan dicari
   * @param keyword Kata kunci yang dicari dalam judul buku
   * @return Daftar buku yang judulnya mengandung kata kunci
   */
  static List<Buku> searchByKeyword(List<Buku> list, String keyword) {
    if (keyword.isEmpty) return [];

    List<Buku> results = [];
    String lowercaseKeyword = keyword.toLowerCase();

    for (var buku in list) {
      // Periksa apakah judul buku mengandung kata kunci (case-insensitive)
      if (buku.judul.toLowerCase().contains(lowercaseKeyword)) {
        results.add(buku);
      }
    }

    return results;
  }

  /**
   * Mencari buku berdasarkan ISBN menggunakan algoritma Binary Search.
   * Binary Search bekerja pada daftar yang sudah terurut dengan membagi daftar menjadi dua
   * dan memeriksa apakah elemen yang dicari berada di bagian kiri atau kanan.
   * 
   * Kompleksitas waktu: O(log n) di mana n adalah jumlah buku dalam daftar.
   * 
   * @param list Daftar buku yang sudah diurutkan berdasarkan ISBN
   * @param isbn ISBN buku yang dicari
   * @return Objek Buku jika ditemukan, null jika tidak ditemukan
   */
  static Buku? binarySearchByIsbn(List<Buku> list, String isbn) {
    int left = 0;
    int right = list.length - 1;

    while (left <= right) {
      // Hitung indeks tengah dengan cara yang aman dari integer overflow
      int mid = left + ((right - left) >> 1);

      if (list[mid].isbn == isbn) {
        return list[mid]; // Buku ditemukan
      } else if (list[mid].isbn.compareTo(isbn) < 0) {
        left = mid + 1; // Cari di bagian kanan
      } else {
        right = mid - 1; // Cari di bagian kiri
      }
    }

    return null; // Buku tidak ditemukan
  }
}
