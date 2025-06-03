import 'dart:io';
import 'buku.dart';

/**
 * Kelas CsvUtils menyediakan utilitas untuk menyimpan dan memuat data buku
 * dalam format CSV (Comma-Separated Values).
 */
class CsvUtils {
  /**
   * Menyimpan daftar buku ke file CSV.
   * 
   * Metode ini menulis header CSV dan data buku ke file yang ditentukan.
   * Format CSV yang digunakan adalah: Judul,Penulis,ISBN,Tahun,Kategori
   * 
   * @param path Path file CSV tempat data akan disimpan
   * @param bukuList Daftar objek Buku yang akan disimpan
   * @return Future<void> yang selesai ketika operasi penyimpanan selesai
   */
  static Future<void> simpanKeCsv(String path, List<Buku> bukuList) async {
    final file = File(path);
    final sink = file.openWrite();
    // Header
    sink.writeln('Judul,Penulis,ISBN,Tahun,Kategori');
    for (var buku in bukuList) {
      sink.writeln(buku.toCsvRow().join(','));
    }
    await sink.flush();
    await sink.close();
  }

  /**
   * Memuat daftar buku dari file CSV.
   * 
   * Metode ini membaca file CSV dan mengkonversi setiap baris menjadi objek Buku.
   * Baris pertama (header) akan dilewati. Baris kosong juga akan dilewati.
   * 
   * @param path Path file CSV yang akan dibaca
   * @return Future<List<Buku>> yang berisi daftar objek Buku yang dimuat dari file
   *         Jika file tidak ada atau kosong, mengembalikan daftar kosong
   */
  static Future<List<Buku>> muatDariCsv(String path) async {
    final file = File(path);
    if (!await file.exists()) return [];
    final lines = await file.readAsLines();
    if (lines.isEmpty) return [];
    // Lewati header
    return lines.skip(1).where((line) => line.trim().isNotEmpty).map((line) {
      final row = line.split(',');
      return Buku.fromCsvRow(row);
    }).toList();
  }
}