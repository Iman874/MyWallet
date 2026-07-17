# Task 3: DatabaseHelper sqflite

## Deskripsi
Membuat singleton `DatabaseHelper` untuk inisialisasi SQLite dan migrasi.

## Tujuan Teknis
- Singleton pattern
- `initDatabase()` — buka/create DB versi 1
- `onCreate()` — CREATE TABLE `transaksi` + indexes
- `onUpgrade()` — untuk migrasi versi depan
- Method query dasar: `rawInsert`, `rawQuery`, `rawUpdate`, `rawDelete`

## Scope
File: `lib/data/datasources/local/database_helper.dart`

## Output yang Diharapkan
- Database terinisialisasi saat pertama `DatabaseHelper.instance.database`
- Tabel `transaksi` dengan kolom: id, jumlah, tanggal, kategori, catatan, tipe
- Index pada kolom tanggal

## Dependencies
Task 2 (model Transaksi)

## Acceptance Criteria
- [x] `database_helper_test.dart` — init DB sukses
- [x] Tabel `transaksi` terbentuk (cek via `rawQuery("SELECT name FROM sqlite_master")`)
- [x] `flutter analyze` tanpa error baru

## Estimasi
45 menit

## Status: SELESAI
