/**
 * Kelas Buku merepresentasikan entitas buku dalam sistem manajemen buku.
 * Kelas ini menyimpan informasi dasar tentang sebuah buku seperti judul, penulis,
 * ISBN (International Standard Book Number), tahun terbit, dan kategori buku.
 */
class Buku {
  /// Judul buku
  String judul;
  
  /// Nama penulis buku
  String penulis;
  
  /// ISBN (International Standard Book Number) buku, berfungsi sebagai identifikasi unik
  String isbn;
  
  /// Tahun terbit buku
  int tahun;
  
  /// Kategori atau genre buku (misalnya: Fiksi, Non-fiksi, Pendidikan, dll)
  String kategori;

  /**
   * Konstruktor untuk membuat objek Buku baru.
   * 
   * @param judul Judul buku
   * @param penulis Nama penulis buku
   * @param isbn ISBN buku (identifikasi unik)
   * @param tahun Tahun terbit buku
   * @param kategori Kategori/genre buku
   */
  Buku({
    required this.judul,
    required this.penulis,
    required this.isbn,
    required this.tahun,
    required this.kategori,
  });

  /**
   * Mengkonversi objek Buku menjadi List<String> untuk penyimpanan dalam format CSV.
   * 
   * @return List<String> yang berisi atribut-atribut buku dalam urutan: judul, penulis, isbn, tahun, kategori
   */
  List<String> toCsvRow() {
    return [judul, penulis, isbn, tahun.toString(), kategori];
  }

  /**
   * Factory constructor untuk membuat objek Buku dari data CSV (List<String>).
   * 
   * @param row List<String> yang berisi data buku dari file CSV
   * @return Objek Buku baru yang dibuat dari data CSV
   */
  factory Buku.fromCsvRow(List<String> row) {
    return Buku(
      judul: row[0],
      penulis: row[1],
      isbn: row[2],
      tahun: int.parse(row[3]),
      kategori: row[4],
    );
  }
}
