class Kategori {
  final int? id;
  final String nama;
  final String icon;
  final String warna;
  final bool isDefault;

  const Kategori({
    this.id,
    required this.nama,
    required this.icon,
    required this.warna,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'icon': icon,
      'warna': warna,
      'isDefault': isDefault ? 1 : 0,
    };
  }

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      icon: map['icon'] as String,
      warna: map['warna'] as String,
      isDefault: (map['isDefault'] as int) == 1,
    );
  }

  Kategori copyWith({
    int? id,
    String? nama,
    String? icon,
    String? warna,
    bool? isDefault,
  }) {
    return Kategori(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      icon: icon ?? this.icon,
      warna: warna ?? this.warna,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
