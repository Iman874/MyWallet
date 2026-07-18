class Kategori {
  final int? id;
  final String nama;
  final String icon;
  final String warna;
  final bool isDefault;
  final String tipe; // 'pemasukan' atau 'pengeluaran'

  const Kategori({
    this.id,
    required this.nama,
    required this.icon,
    required this.warna,
    this.isDefault = false,
    this.tipe = 'pengeluaran',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'icon': icon,
      'warna': warna,
      'isDefault': isDefault ? 1 : 0,
      'tipe': tipe,
    };
  }

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      icon: map['icon'] as String,
      warna: map['warna'] as String,
      isDefault: (map['isDefault'] as int) == 1,
      tipe: (map['tipe'] as String?) ?? 'pengeluaran',
    );
  }

  Kategori copyWith({
    int? id,
    String? nama,
    String? icon,
    String? warna,
    bool? isDefault,
    String? tipe,
  }) {
    return Kategori(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      icon: icon ?? this.icon,
      warna: warna ?? this.warna,
      isDefault: isDefault ?? this.isDefault,
      tipe: tipe ?? this.tipe,
    );
  }
}
