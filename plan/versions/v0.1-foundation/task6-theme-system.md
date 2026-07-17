# Task 6: Theme & Style System

## Deskripsi
Membuat folder `lib/core/theme/` untuk standarisasi warna, font, text style, dan dekorasi seluruh aplikasi.

## Tujuan Teknis
- **Folder**: `lib/core/theme/`
- **File yang dibuat**:
  - `app_colors.dart` — palet warna aplikasi
  - `app_text_styles.dart` — text style dengan font Poppins
  - `app_theme.dart` — ThemeData utama
  - `app_decorations.dart` — dekorasi card, button, dll

## Palet Warna (Harus Digunakan)
| Nama | Hex | Kegunaan |
|------|-----|----------|
| Primary | `#4274D9` | Tombol utama, app bar, accent |
| Primary Dark | `#293681` | Status bar, text gelap, header |
| Light | `#95CCDD` | Background sekunder, divider, hint |
| Background | `#D0E7E6` | Background screen utama |
| Success | `#4CAF50` | Pemasukan, saldo positif |
| Error | `#F44336` | Pengeluaran, saldo negatif, error |

## Font
- **Font family**: Poppins
- **Import**: `google_fonts` package
- **Variants**: Regular (400), Medium (500), SemiBold (600), Bold (700)

## Struktur Folder
```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       └── app_decorations.dart
├── presentation/
│   ├── screens/
│   └── widgets/
├── data/
│   └── models/
├── providers/
└── main.dart
```

## Output yang Diharapkan
- `app_colors.dart`: class `AppColors` dengan static const untuk semua warna
- `app_text_styles.dart`: class `AppTextStyles` dengan method untuk setiap text style (heading, body, caption, dll)
- `app_theme.dart`: `ThemeData` yang menggunakan AppColors dan AppTextStyles
- `app_decorations.dart`: class `AppDecorations` untuk card, button, input decoration

## Dependencies
- `google_fonts` package (ditambahkan di v0.1 task 1)

## Acceptance Criteria
- [x] Folder `lib/core/theme/` terbuat
- [x] Semua file theme terbuat (app_colors, app_text_styles, app_theme, app_decorations)
- [x] Palet warna sesuai spesifikasi
- [x] Font Poppins terintegrasi
- [x] `flutter analyze` tanpa error baru

## Estimasi
30 menit

## Status: SELESAI
