# Task 2: Buat Widget Reusable

## Deskripsi
Membuat widget-widget reusable baru untuk design modern: GradientHeader, ModernCard, dan lainnya.

## Tujuan Teknis
- **GradientHeader**: Widget header dengan gradient biru dan lengkungan bawah
- **ModernCard**: Widget card dengan shadow dan border radius modern
- **PillButton**: Widget tombol pill-shaped untuk tipe transaksi
- **IconPrefix**: Widget icon dengan background warna untuk form inputs

## Widget Tree
```
lib/presentation/widgets/
├── gradient_header.dart
├── modern_card.dart
├── pill_button.dart
└── icon_prefix.dart
```

## Output yang Diharapkan
- `gradient_header.dart`: Widget header dengan gradient dan curved bottom
- `modern_card.dart`: Widget card dengan shadow modern
- `pill_button.dart`: Widget tombol pill-shaped
- `icon_prefix.dart`: Widget icon dengan background

## Dependencies
- Task 1 (Update Theme)

## Acceptance Criteria
- [x] Semua widget reusable terbuat
- [x] Widget menggunakan theme dari folder `lib/core/theme/`
- [x] `flutter analyze` tanpa error baru

## Estimasi
45 menit

## Status: SELESAI
