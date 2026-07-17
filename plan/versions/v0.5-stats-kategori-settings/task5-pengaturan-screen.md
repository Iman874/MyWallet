# Task 5: Update Tab Pengaturan (Theme)

## Deskripsi
Mengisi tab Pengaturan dengan toggle light/dark mode.

## Tujuan Teknis
- `PengaturanScreen` dengan list pengaturan
- Theme toggle: Light / Dark / System
- Simpan preference ke SharedPreferences
- Update theme secara real-time

## Widget Tree
```
PengaturanScreen
├── StickyHeader ("Pengaturan")
├── List Pengaturan
│   ├── Theme (Light/Dark/System)
│   ├── Tentang Aplikasi
│   └── Versi
└── Footer
```

## Output yang Diharapkan
- `lib/presentation/screens/pengaturan_screen.dart`
- Theme toggle berfungsi
- Preference tersimpan

## Dependencies
- v0.1-v0.4 (theme system)

## Acceptance Criteria
- [x] Theme toggle berfungsi (Light/Dark/System)
- [x] Preference tersimpan di SharedPreferences
- [x] Theme berubah real-time
- [x] Info versi aplikasi tampil
- [x] `flutter analyze` tanpa error

## Estimasi
30 menit

## Status: SELESAI
