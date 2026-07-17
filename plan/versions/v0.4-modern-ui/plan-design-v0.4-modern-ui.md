# Plan Design v0.4 — Modern UI Redesign

## Latar Belakang
Fase 1 MVP sudah selesai dengan fungsi dasar. Sekarang perlu redesign UI agar tampil lebih modern dan profesional sesuai referensi desain yang diberikan.

## Referensi Design
- Dashboard: Header biru gradient dengan ilustrasi wallet, saldo card modern, ringkasan harian card
- Form Transaksi: Input fields modern dengan icon prefix, tombol tipe transaksi pill-shaped
- Riwayat: Header biru gradient, filter card modern, empty state dengan ilustrasi 3D

## Tujuan
- Modernisasi seluruh UI aplikasi sesuai referensi desain
- Menambahkan ilustrasi 3D untuk empty states
- Membuat header biru gradient dengan lengkungan bawah
- Modernisasi form inputs dengan icon prefix
- Membuat tombol tipe transaksi pill-shaped

## Palet Warna (Diperbarui)
| Nama | Hex | Kegunaan |
|------|-----|----------|
| Primary | `#3B82F6` | Gradient header, tombol utama |
| Primary Light | `#60A5FA` | Gradient header (lighter) |
| Primary Dark | `#1D4ED8` | Status bar, text gelap |
| Background | `#F8FAFC` | Background screen utama |
| Card | `#FFFFFF` | Background card |
| Success | `#22C55E` | Pemasukan, hijau |
| Error | `#EF4444` | Pengeluaran, merah |
| Text Primary | `#1E293B` | Text utama |
| Text Secondary | `#64748B` | Text sekunder, caption |
| Border | `#E2E8F0` | Border input |

## Design Elements

### 1. Header Gradient
- Gradient: Primary → Primary Light
- Bentuk: Lengkungan bawah (curved bottom)
- Title: Poppins SemiBold, putih

### 2. Cards
- Background: White
- Shadow: BoxShadow ringan (elevation 2)
- Border radius: 16px
- Padding: 20px

### 3. Form Inputs
- Border radius: 12px
- Border: 1px solid Border
- Icon prefix: Background warna, border radius 8px
- Focus state: Border biru

### 4. Tipe Transaksi Buttons
- Pill-shaped (border radius 25px)
- Pemasukan: Green outline + icon hijau
- Pengeluaran: Red outline + icon merah
- Selected: Filled dengan warna

### 5. Bottom Navigation
- Background: White dengan shadow
- Selected: Blue pill background
- Unselected: Grey

### 6. Empty State
- Ilustrasi 3D (SVG/PNG)
- Teks utama: Poppins SemiBold
- Teks sekunder: Poppins Regular, grey

## Scope (Dikerjakan)
- Update `app_colors.dart` dengan palet warna baru
- Update `app_text_styles.dart` dengan text styles baru
- Update `app_theme.dart` dengan ThemeData baru
- Update `app_decorations.dart` dengan dekorasi baru
- Buat widget `GradientHeader` untuk header biru gradient
- Buat widget `ModernCard` untuk card modern
- Update `DashboardScreen` dengan design baru
- Update `TambahTransaksiScreen` dengan form modern
- Update `RiwayatScreen` dengan design baru
- Update `HomeScreen` dengan bottom navigation modern
- Tambahkan ilustrasi 3D untuk empty states
- Update semua widgets dengan design baru

## Scope (Tidak Dikerjakan)
- ❌ Fitur baru (hanya redesign UI)
- ❌ Perubahan logika bisnis
- ❌ Perubahan database schema
- ❌ Authentication

## Definition of Done
- [ ] Semua screen menggunakan design baru
- [ ] Header gradient dengan lengkungan bawah
- [ ] Cards dengan shadow dan border radius
- [ ] Form inputs dengan icon prefix modern
- [ ] Tipe transaksi pill-shaped buttons
- [ ] Bottom navigation dengan pill indicator
- [ ] Empty state dengan ilustrasi 3D
- [ ] `flutter analyze` bersih
- [ ] Semua test pass
