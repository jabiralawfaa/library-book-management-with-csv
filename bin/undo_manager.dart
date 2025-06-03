/**
 * Kelas UndoAction merepresentasikan sebuah aksi yang dapat di-undo (dibatalkan).
 * Kelas ini menyimpan tipe aksi dan data yang terkait dengan aksi tersebut.
 */
class UndoAction {
  /// Tipe aksi yang dilakukan, bisa berupa 'tambah', 'hapus', atau 'edit'
  final String type;

  /// Data yang terkait dengan aksi, biasanya berupa objek Buku
  final dynamic data;

  /**
   * Konstruktor untuk membuat objek UndoAction baru.
   * 
   * @param type Tipe aksi ('tambah', 'hapus', 'edit')
   * @param data Data yang terkait dengan aksi (biasanya objek Buku)
   */
  UndoAction(this.type, this.data);
}

/**
 * Kelas UndoManager mengimplementasikan fungsionalitas undo (pembatalan aksi)
 * menggunakan struktur data stack (tumpukan). Kelas ini menyimpan riwayat aksi
 * yang dilakukan pengguna dan memungkinkan pembatalan aksi terakhir.
 */
class UndoManager {
  /// Stack (tumpukan) untuk menyimpan riwayat aksi yang dapat di-undo
  final List<UndoAction> _stack = [];

  /**
   * Menambahkan aksi baru ke dalam stack undo.
   * 
   * @param action Objek UndoAction yang merepresentasikan aksi yang dilakukan
   */
  void push(UndoAction action) {
    _stack.add(action);
  }

  /**
   * Mengambil dan menghapus aksi terakhir dari stack undo.
   * 
   * @return Objek UndoAction terakhir jika stack tidak kosong, null jika stack kosong
   */
  UndoAction? pop() {
    if (_stack.isEmpty) return null;
    return _stack.removeLast();
  }

  /// Memeriksa apakah stack undo kosong
  bool get isEmpty => _stack.isEmpty;

  /// Menghapus semua aksi dari stack undo
  void clear() => _stack.clear();
}
