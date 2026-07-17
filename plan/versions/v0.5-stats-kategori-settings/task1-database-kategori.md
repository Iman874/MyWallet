# Task 1: Update Database & Model Kategori

## Deskripsi
Menambahkan tabel `kategori` di database dan membuat model `Kategori` baru.

## Tujuan Teknis
- Tambah tabel `kategori` di database (id, nama, icon, warna, isDefault)
- Buat model `Kategori` dengan field: id, nama, icon, warna, isDefault
- Update `DatabaseHelper` untuk migrasi versi 2
- Insert kategori default: Gaji, Makan, Transportasi, Hiburan, Lainnya

## Database Schema
```sql
CREATE TABLE kategori (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  icon TEXT NOT NULL,
  warna TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
);
```

## Output yang Diharapkan
- Model `Kategori` di `lib/domain/entities/kategori.dart`
- Database ter-migrasi ke versi 2
- Kategori default ter-insert

## Dependencies
- v0.1-v0.4 (foundation)

## Acceptance Criteria
- [x] Tabel `kategori` terbentuk
- [x] Model `Kategori` bisa dikonversi ke/from Map
- [x] Kategori default ter-insert (5 item)
- [x] `flutter analyze` tanpa error

## Estimasi
30 menit

## Status: SELESAI
