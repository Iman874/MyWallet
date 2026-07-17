enum TransaksiType { pemasukan, pengeluaran }

class Transaksi {
  final int? id;
  final int jumlah;
  final DateTime tanggal;
  final String kategori;
  final String? catatan;
  final TransaksiType tipe;

  const Transaksi({
    this.id,
    required this.jumlah,
    required this.tanggal,
    required this.kategori,
    this.catatan,
    required this.tipe,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jumlah': jumlah,
      'tanggal': tanggal.millisecondsSinceEpoch,
      'kategori': kategori,
      'catatan': catatan,
      'tipe': tipe.name,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'] as int?,
      jumlah: map['jumlah'] as int,
      tanggal: DateTime.fromMillisecondsSinceEpoch(map['tanggal'] as int),
      kategori: map['kategori'] as String,
      catatan: map['catatan'] as String?,
      tipe: TransaksiType.values.firstWhere(
        (e) => e.name == map['tipe'] as String,
      ),
    );
  }

  Transaksi copyWith({
    int? id,
    int? jumlah,
    DateTime? tanggal,
    String? kategori,
    String? catatan,
    TransaksiType? tipe,
  }) {
    return Transaksi(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      tanggal: tanggal ?? this.tanggal,
      kategori: kategori ?? this.kategori,
      catatan: catatan ?? this.catatan,
      tipe: tipe ?? this.tipe,
    );
  }
}
