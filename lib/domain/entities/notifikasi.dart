class Notifikasi {
  final int? id;
  final String judul;
  final String pesan;
  final String tipe; // 'harian', 'mingguan', 'bulanan'
  final int jumlahPengeluaran;
  final int batas;
  final bool isRead;
  final DateTime createdAt;

  const Notifikasi({
    this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.jumlahPengeluaran,
    required this.batas,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'pesan': pesan,
      'tipe': tipe,
      'jumlah_pengeluaran': jumlahPengeluaran,
      'batas': batas,
      'isRead': isRead ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Notifikasi.fromMap(Map<String, dynamic> map) {
    return Notifikasi(
      id: map['id'] as int?,
      judul: map['judul'] as String,
      pesan: map['pesan'] as String,
      tipe: map['tipe'] as String,
      jumlahPengeluaran: map['jumlah_pengeluaran'] as int,
      batas: map['batas'] as int,
      isRead: (map['isRead'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Notifikasi copyWith({
    int? id,
    String? judul,
    String? pesan,
    String? tipe,
    int? jumlahPengeluaran,
    int? batas,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notifikasi(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      pesan: pesan ?? this.pesan,
      tipe: tipe ?? this.tipe,
      jumlahPengeluaran: jumlahPengeluaran ?? this.jumlahPengeluaran,
      batas: batas ?? this.batas,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
