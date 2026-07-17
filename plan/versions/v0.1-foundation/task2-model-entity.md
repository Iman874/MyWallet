# Task 2: Model Transaksi Entity

## Deskripsi
Membuat entity class `Transaksi` dengan field dan enum `TransaksiType`.

## Tujuan Teknis
- Class `Transaksi` immutable (pakai `const` constructor + `final` fields)
- Method `toMap()` / `factory fromMap()` untuk SQLite
- Method `copyWith()` untuk immutability

## Scope
File: `lib/domain/entities/transaksi.dart`

## Output yang Diharapkan
```dart
enum TransaksiType { pemasukan, pengeluaran }

class Transaksi {
  final int? id;
  final int jumlah;          // dalam satuan rupiah (sen)
  final DateTime tanggal;
  final String kategori;     // 'Gaji' | 'Makan' | 'Transportasi' | 'Hiburan' | 'Lainnya'
  final String? catatan;
  final TransaksiType tipe;
}
```

## Dependencies
Task 1 (project setup)

## Acceptance Criteria
- [x] Model bisa dikonversi ke Map dan dari Map
- [x] `copyWith()` mengubah field yang dipilih saja
- [x] `flutter analyze` tanpa error baru

## Estimasi
15 menit

## Status: SELESAI
