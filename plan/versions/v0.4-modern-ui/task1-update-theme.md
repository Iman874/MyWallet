# Task 1: Update Theme System

## Deskripsi
Update seluruh file theme (`app_colors.dart`, `app_text_styles.dart`, `app_theme.dart`, `app_decorations.dart`) dengan palet warna dan style baru sesuai referensi design modern.

## Tujuan Teknis
- **app_colors.dart**: Update palet warna dengan gradient blue (#3B82F6, #60A5FA), background (#F8FAFC), border (#E2E8F0)
- **app_text_styles.dart**: Update text styles dengan ukuran dan weight baru
- **app_theme.dart**: Update ThemeData dengan color scheme baru, NavigationBar theme, Card theme
- **app_decorations.dart**: Tambahkan dekorasi baru (gradient header, modern card, pill button)

## Palet Warna Baru
```dart
static const Color primary = Color(0xFF3B82F6);
static const Color primaryLight = Color(0xFF60A5FA);
static const Color primaryDark = Color(0xFF1D4ED8);
static const Color background = Color(0xFFF8FAFC);
static const Color card = Color(0xFFFFFFFF);
static const Color border = Color(0xFFE2E8F0);
static const Color textPrimary = Color(0xFF1E293B);
static const Color textSecondary = Color(0xFF64748B);
static const Color success = Color(0xFF22C55E);
static const Color error = Color(0xFFEF4444);
```

## Output yang Diharapkan
- Semua file theme ter-update
- Gradient available untuk header
- Modern card decoration
- Pill button decoration

## Dependencies
- Task sebelumnya (v0.1-v0.3)

## Acceptance Criteria
- [x] `app_colors.dart` ter-update dengan palet baru
- [x] `app_text_styles.dart` ter-update
- [x] `app_theme.dart` ter-update dengan ThemeData baru
- [x] `app_decorations.dart` ter-update dengan dekorasi baru
- [x] `flutter analyze` tanpa error baru

## Estimasi
30 menit

## Status: SELESAI
