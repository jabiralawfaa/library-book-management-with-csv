import '../buku.dart';
import '../csv_utils.dart';
import '../koleksi_buku.dart';
import '../rak_buku.dart';
import '../sorter_searcher.dart';
import '../undo manager.dart';

Duration ukurWaktu(Function() fungsi) {
  final stopwatch = Stopwatch()..start();
  fungsi();
  stopwatch.stop();
  return stopwatch.elapsed;
}

List<Buku> buatDatasetTerurut(int ukuran, {bool terbalik = false}) {
  List<Buku> hasil = [];
  for (int i = 0; i < ukuran; i++) {
    String judul = terbalik ? 'Judul ${ukuran - i}' : 'Judul $i';
    hasil.add(Buku(
      judul: judul,
      penulis: 'Penulis Test',
      isbn: 'ISBN-$i',
      tahun: terbalik ? 2023 - i : 2000 + i,
      kategori: 'Kategori Test',
    ));
  }
  return hasil;
}

List<Buku> buatDatasetAcak(int ukuran) {
  List<Buku> hasil = buatDatasetTerurut(ukuran);
  hasil.shuffle();
  return hasil;
}

void ujiAlgoritmaBubbleSort() {
  print('\n=== PENGUJIAN BUBBLE SORT ===');
  
  // Dataset untuk pengujian
  final ukuranDataset = [10, 50, 100];
  
  for (var ukuran in ukuranDataset) {
    print('\nUkuran dataset: $ukuran buku');
    
    // Kasus terbaik: sudah terurut
    var datasetTerurut = buatDatasetTerurut(ukuran);
    var waktu = ukurWaktu(() {
      Sorter.bubbleSortByJudul(datasetTerurut);
    });
    print('Kasus terbaik (terurut): ${waktu.inMicroseconds} mikrodetik');
    
    // Kasus terburuk: terurut terbalik
    var datasetTerbalik = buatDatasetTerurut(ukuran, terbalik: true);
    waktu = ukurWaktu(() {
      Sorter.bubbleSortByJudul(datasetTerbalik);
    });
    print('Kasus terburuk (terbalik): ${waktu.inMicroseconds} mikrodetik');
    
    // Kasus rata-rata: acak
    var datasetAcak = buatDatasetAcak(ukuran);
    waktu = ukurWaktu(() {
      Sorter.bubbleSortByJudul(datasetAcak);
    });
    print('Kasus rata-rata (acak): ${waktu.inMicroseconds} mikrodetik');
  }
}

void main() {
  ujiAlgoritmaLinkedList();
  ujiAlgoritmaBST();
  ujiAlgoritmaBubbleSort();
  ujiAlgoritmaQuickSort();
  ujiAlgoritmaLinearSearch();
  ujiAlgoritmaBinarySearch();
  ujiAlgoritmaStack();
}