# Task 1: Flutter Create & Dependencies

## Deskripsi
Membuat project Flutter baru dan menambahkan dependency yang dibutuhkan.

## Tujuan Teknis
- `flutter create` sukses
- `pubspec.yaml` berisi dependency: `sqflite`, `path`, `provider`, `intl`, `google_fonts`
- `flutter pub get` sukses tanpa error
- Membuat folder struktur awal termasuk `lib/core/theme/`

## Struktur Folder yang Dibuat
```
lib/
├── core/
│   └── theme/ (dibuat kosong, diisi di task6)
├── data/
│   └── models/
├── presentation/
│   ├── screens/
│   └── widgets/
├── providers/
└── main.dart
assets/
└── images/ (untuk ilustrasi empty state)
```

## Scope
- `flutter create` project bernama `uangku` di root `MyWallet/`
- Edit `pubspec.yaml` tambah dependencies
- Buat folder struktur: `lib/core/theme/`, `lib/data/`, `lib/presentation/`, `lib/providers/`, `assets/images/`
- `flutter pub get`

## Output yang Diharapkan
- Folder `lib/`, `test/`, `android/`, `ios/`, `web/` terbentuk
- Folder `lib/core/theme/`, `assets/images/` terbuat
- `flutter analyze` bersih (hanya boilerplate bawaan)

## Dependencies
Tidak ada (task pertama)

## Acceptance Criteria
- [x] `flutter create` menghasilkan folder `lib/` dengan `main.dart`
- [x] `pubspec.yaml` memiliki `sqflite`, `path`, `provider`, `intl`, `google_fonts`
- [x] Folder `lib/core/theme/`, `lib/data/`, `lib/presentation/`, `lib/providers/`, `assets/images/` terbuat
- [x] `flutter pub get` tanpa error
- [x] `flutter analyze` tanpa error

## Estimasi
30 menit

## Status: SELESAI
