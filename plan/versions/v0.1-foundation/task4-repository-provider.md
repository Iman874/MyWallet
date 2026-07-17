# Task 4: Repository & Provider

## Deskripsi
Membuat repository interface, implementasi, dan Provider (state management).

## Tujuan Teknis
- `TransaksiRepository` abstract class
- `TransaksiRepositoryImpl` implementasi dengan `DatabaseHelper`
- Method: `insert`, `getAll`, `getById`, `getByMonth`, `getTerbaru`, `update`, `delete`, `getSaldo`, `getRingkasanHarian`
- `TransaksiProvider` ChangeNotifier: state list transaksi, loading, error
- Method provider: `loadAll()`, `loadByMonth()`, `add()`, `update()`, `delete()`

## Scope
- `lib/domain/repositories/transaksi_repository.dart`
- `lib/data/repositories/transaksi_repository_impl.dart`
- `lib/presentation/providers/transaksi_provider.dart`

## Output yang Diharapkan
- Repository bisa CRUD transaksi
- Provider notify listeners saat data berubah
- Saldo dihitung dari SUM SQL

## Dependencies
Task 3 (DatabaseHelper)

## Acceptance Criteria
- [x] Semua method repository berfungsi (insert, getAll, update, delete, getSaldo, getTerbaru)
- [x] Provider.state.list terisi setelah load
- [x] `flutter analyze` tanpa error baru

## Estimasi
60 menit

## Status: SELESAI
