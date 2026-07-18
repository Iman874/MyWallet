# Task 1 — Database & Model Notifikasi

## Judul
Setup Database dan Model Notifikasi

## Deskripsi
Buat tabel notifikasi di database, model Notifikasi entity, dan repository untuk CRUD notifikasi.

## Tujuan Teknis
- Tabel `notifikasi` terbuat di database
- Entity `Notifikasi` lengkap dengan semua field
- Repository dan Provider untuk notifikasi berfungsi

## Scope
- Update `database_helper.dart` → version 4, add tabel notifikasi
- Buat `lib/domain/entities/notifikasi.dart`
- Buat `lib/domain/repositories/notifikasi_repository.dart`
- Buat `lib/data/repositories/notifikasi_repository_impl.dart`
- Buat `lib/presentation/providers/notifikasi_provider.dart`

## Langkah Implementasi
1. Update `database_helper.dart`:
   - Version 2 → 4
   - Tambah tabel notifikasi di `_createDB`
   - Tambah `_onUpgrade` untuk version 3→4
2. Buat `notifikasi.dart` dengan field: id, judul, pesan, tipe, jumlah_pengeluaran, batas, isRead, createdAt
3. Buat `notifikasi_repository.dart` (abstract)
4. Buat `notifikasi_repository_impl.dart` dengan CRUD + getBelumDibaca + tandaiSudahDibaca
5. Buat `notifikasi_provider.dart` dengan loadAll, tambah, hapus, tandaiDibaca

## Output yang Diharapkan
- Tabel notifikasi ada di database
- NotifikasiProvider bisa CRUD
- flutter analyze bersih

## Dependencies
- DatabaseHelper sudah ada

## Acceptance Criteria
- [ ] Tabel notifikasi terbuat
- [ ] Model Notifikasi lengkap
- [ ] Provider berfungsi

## Estimasi
1-2 jam
