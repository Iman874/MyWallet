# Plan Design v0.1 — Foundation & Database

## Latar Belakang
Proyek UangKu mulai dari nol. Belum ada Flutter project, database, atau kode apapun. v0.1 adalah fondasi teknis agar v0.2 dan v0.3 bisa dibangun di atasnya.

## Tujuan
- Flutter project UangKu siap build di Android & iOS tanpa error
- SQLite database (sqflite) dengan tabel `transaksi` siap pakai
- Model `Transaksi`, Repository (CRUD), Provider (ChangeNotifier)
- Unit test untuk data layer
- `flutter analyze` & `flutter test` pass

## Scope (Dikerjakan)
- Flutter project init + pubspec dependencies
- Folder structure arsitektur
- Model `Transaksi` + enum `TransaksiType`
- `DatabaseHelper` singleton (init, onCreate, onUpgrade)
- `TransaksiRepository` interface + implementasi
- `TransaksiProvider` ChangeNotifier
- Unit test repository & provider
- flutter analyze & test pass

## Scope (Tidak Dikerjakan)
- ❌ UI apapun (screen, widget, navigation)
- ❌ Routing antar screen
- ❌ Input validasi bisnis (hanya validasi DB level)

## Breakdown Task
| # | Task | File |
|---|------|------|
| 1 | Flutter create + dependency | `pubspec.yaml`, `lib/main.dart` |
| 2 | Model Transaksi entity | `lib/domain/entities/transaksi.dart` |
| 3 | DatabaseHelper sqflite | `lib/data/datasources/local/database_helper.dart` |
| 4 | Repository + Provider | `lib/domain/repositories/`, `lib/data/repositories/`, `lib/presentation/providers/` |
| 5 | Unit test + verify | `test/` |

## Design Teknis

### Struktur Folder
```
lib/
├── main.dart
├── domain/
│   ├── entities/
│   │   └── transaksi.dart
│   └── repositories/
│       └── transaksi_repository.dart
├── data/
│   ├── datasources/local/
│   │   └── database_helper.dart
│   └── repositories/
│       └── transaksi_repository_impl.dart
└── presentation/
    └── providers/
        └── transaksi_provider.dart
test/
├── data/repositories/transaksi_repository_test.dart
└── presentation/providers/transaksi_provider_test.dart
```

### Skema DB
```sql
CREATE TABLE transaksi (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jumlah INTEGER NOT NULL,
  tanggal TEXT NOT NULL,
  kategori TEXT NOT NULL,
  catatan TEXT,
  tipe TEXT NOT NULL CHECK(tipe IN ('pemasukan','pengeluaran'))
);
CREATE INDEX idx_transaksi_tanggal ON transaksi(tanggal);
```

### Flow Data
```
Screen → Provider (ChangeNotifier) → Repository (interface) → DatabaseHelper (sqflite) → SQLite
```

## Dampak ke Sistem
- Database version 1 (migration path untuk Fase 2)
- Tidak ada UI, tidak berdampak ke user experience
- Test coverage data layer > 80%

## Definition of Done
- [ ] `flutter create` sukses, `flutter pub get` bersih
- [ ] `flutter analyze` — 0 error, 0 warning baru
- [ ] `flutter test` — all pass
- [ ] Semua task selesai
