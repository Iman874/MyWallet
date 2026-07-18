# Task 5 - Budget Per Kategori (DB + Entity + Repo)

## Judul
Tambah field batas di kategori (DB migration + entity + repository)

## Deskripsi
Menambahkan kolom `batas` (nullable) di tabel kategori untuk budget spesifik tiap
kategori pengeluaran.

## Tujuan Teknis
- Kontrol anggaran lebih granular dibanding batas global.

## Scope
- `lib/domain/entities/kategori.dart`: tambah `int? batas`.
- `lib/data/datasources/local/database_helper.dart`: ALTER TABLE kategori ADD batas;
  naikkan db version; update create & fromMap/toMap.
- `lib/domain/repositories/kategori_repository.dart` & impl: update upsert/read.
- `lib/presentation/providers/kategori_provider.dart`: expose batas.

## Langkah Implementasi
1. Tambah field `batas` di entity Kategori (+ copyWith).
2. DB: db version +1, onUpgrade ALTER kategori ADD COLUMN batas INTEGER.
3. Update query insert/update/select di database_helper & repository.
4. Provider baca & expose batas per kategori.

## Output yang Diharapkan
- Kategori bisa menyimpan batas (NULL = tanpa batas).

## Dependencies
- Tidak ada (bisa paralel task lain).

## Acceptance Criteria
- db version naik & migration jalan tanpa reset data.
- batas tersimpan & terbaca benar.
- Provider expose batas.

## Estimasi
2 jam
