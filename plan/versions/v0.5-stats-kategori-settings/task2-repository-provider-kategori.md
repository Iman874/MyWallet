# Task 2: Repository & Provider Kategori

## Deskripsi
Membuat repository dan provider untuk mengelola kategori.

## Tujuan Teknis
- `KategoriRepository` abstract class
- `KategoriRepositoryImpl` implementasi dengan `DatabaseHelper`
- Method: `getAll`, `insert`, `update`, `delete`
- `KategoriProvider` ChangeNotifier

## Output yang Diharapkan
- `lib/domain/repositories/kategori_repository.dart`
- `lib/data/repositories/kategori_repository_impl.dart`
- `lib/presentation/providers/kategori_provider.dart`

## Dependencies
- Task 1 (Database & Model)

## Acceptance Criteria
- [x] Semua method repository berfungsi
- [x] Provider notify listeners saat data berubah
- [x] `flutter analyze` tanpa error

## Estimasi
30 menit

## Status: SELESAI
