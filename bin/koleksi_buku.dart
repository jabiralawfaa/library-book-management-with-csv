import 'buku.dart';

/**
 * Kelas Node merepresentasikan sebuah simpul (node) dalam struktur data Linked List.
 * Setiap node menyimpan data berupa objek Buku dan referensi ke node berikutnya.
 */
class Node {
  /// Data buku yang disimpan dalam node
  Buku data;

  /// Referensi ke node berikutnya dalam linked list, null jika node ini adalah node terakhir
  Node? next;

  /**
   * Konstruktor untuk membuat node baru dengan data buku tertentu.
   * 
   * @param data Objek Buku yang akan disimpan dalam node
   */
  Node(this.data);
}

/**
 * Kelas KoleksiBuku mengimplementasikan struktur data Linked List untuk menyimpan
 * koleksi buku. Kelas ini menyediakan operasi-operasi dasar seperti menambah, menghapus,
 * dan mencari buku dalam koleksi.
 */
class KoleksiBuku {
  /// Referensi ke node pertama (head) dalam linked list
  Node? head;

  /// Jumlah buku dalam koleksi, disimpan sebagai variabel privat
  int _length = 0;

  /// Getter untuk mendapatkan jumlah buku dalam koleksi
  int get length => _length;

  /**
   * Menambahkan buku baru ke akhir koleksi (linked list).
   * 
   * @param buku Objek Buku yang akan ditambahkan ke koleksi
   */
  void tambah(Buku buku) {
    Node newNode = Node(buku);
    if (head == null) {
      // Jika koleksi kosong, node baru menjadi head
      head = newNode;
    } else {
      // Jika koleksi tidak kosong, tambahkan node baru di akhir linked list
      Node? current = head;
      while (current!.next != null) {
        current = current.next;
      }
      current.next = newNode;
    }
    _length++;
  }

  /**
   * Menghapus buku dari koleksi berdasarkan ISBN.
   * 
   * @param isbn ISBN buku yang akan dihapus
   * @return true jika buku berhasil dihapus, false jika buku tidak ditemukan
   */
  bool hapus(String isbn) {
    if (head == null) return false; // Koleksi kosong

    // Jika buku yang akan dihapus adalah head
    if (head!.data.isbn == isbn) {
      head = head!.next;
      _length--;
      return true;
    }

    // Mencari buku di posisi lain dalam linked list
    Node? current = head;
    while (current!.next != null) {
      if (current.next!.data.isbn == isbn) {
        current.next =
            current.next!.next; // Hapus node dengan mengubah referensi
        _length--;
        return true;
      }
      current = current.next;
    }
    return false; // Buku tidak ditemukan
  }

  /**
   * Mencari buku dalam koleksi berdasarkan ISBN.
   * 
   * @param isbn ISBN buku yang dicari
   * @return Objek Buku jika ditemukan, null jika tidak ditemukan
   */
  Buku? cariByIsbn(String isbn) {
    Node? current = head;
    while (current != null) {
      if (current.data.isbn == isbn) return current.data;
      current = current.next;
    }
    return null; // Buku tidak ditemukan
  }

  /**
   * Mengkonversi koleksi buku (linked list) menjadi List<Buku>.
   * 
   * @return List<Buku> yang berisi semua buku dalam koleksi
   */
  List<Buku> toList() {
    List<Buku> list = [];
    Node? current = head;
    while (current != null) {
      list.add(current.data);
      current = current.next;
    }
    return list;
  }

  /**
   * Mengisi koleksi buku dari List<Buku>.
   * Menghapus semua buku yang ada sebelumnya dan menggantinya dengan buku-buku dari list.
   * 
   * @param bukuList List<Buku> yang berisi buku-buku yang akan dimasukkan ke koleksi
   */
  void fromList(List<Buku> bukuList) {
    head = null; // Hapus semua buku yang ada sebelumnya
    _length = 0;
    for (var buku in bukuList) {
      tambah(buku); // Tambahkan buku satu per satu
    }
  }
}
