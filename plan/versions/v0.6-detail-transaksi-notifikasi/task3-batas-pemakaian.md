# Task 3 — Pengaturan Batas Pemakaian

## Judul
Buat Pengaturan Batas Pemakaian

## Deskripsi
Buat UI dan logic untuk mengatur batas pemakaian harian, mingguan, dan bulanan di halaman Pengaturan.

## Tujuan Teknis
- SharedPreferences menyimpan batas
- UI pengaturan batas di PengaturanScreen
- Default batas sudah terisi

## Scope
- Buat `lib/presentation/providers/batas_provider.dart`
- Update `pengaturan_screen.dart` → tambah section "Batas Pemakaian"

## Langkah Implementasi
1. Buat `batas_provider.dart`:
   - Load/save dari SharedPreferences
   - Keys: `batas_harian`, `batas_mingguan`, `batas_bulanan`
   - Default: 200000, 1500000, 5000000
   - Method: getBatasHarian, getBatasMingguan, getBatasBulanan, setBatas
2. Update `pengaturan_screen.dart`:
   - Tambah section "Batas Pemakaian"
   - 3 field input: Harian, Mingguan, Bulanan
   - Format Rupiah
   - Tombol Simpan

## Output yang Diharapkan
- Batas tersimpan di SharedPreferences
- UI pengaturan berfungsi
- Default batas sudah ada

## Dependencies
- SharedPreferences package sudah ada

## Acceptance Criteria
- [ ] Batas tersimpan
- [ ] UI pengaturan tampil
- [ ] Default batas benar

## Estimasi
1-2 jam
