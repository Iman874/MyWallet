# Plan Design v0.3 — Riwayat Transaksi & Final Polish

## Latar Belakang
Dasbor dan form catat transaksi sudah jadi (v0.2). Sekarang butuh halaman Riwayat untuk melihat, mengedit, dan menghapus transaksi. Juga final polish untuk seluruh app.

## Tujuan
- Halaman riwayat: ListView semua transaksi (terbaru dulu)
- Filter bulanan (dropdown/picker pilih bulan & tahun)
- Edit catatan transaksi (bottom sheet / dialog)
- Hapus transaksi dengan AlertDialog konfirmasi
- Loading indicator, empty state, error snackbar
- Saldo real-time update setelah edit/hapus
- `flutter analyze` & integration test pass

## Scope (Dikerjakan)
- RiwayatScreen dengan ListView.builder
- Filter bulanan (Dropdown month + year, default bulan ini)
- Edit catatan (tap → dialog → update → refresh)
- Hapus (icon delete / swipe → AlertDialog konfirmasi → hapus → refresh)
- Loading state (CircularProgressIndicator)
- Empty state (belum ada transaksi di bulan tersebut)
- Integration test flow penuh (catat → lihat riwayat → edit → hapus)

## Scope (Tidak Dikerjakan)
- ❌ Kategori custom (Fase 2)
- ❌ Export CSV/PDF (Fase 2)
- ❌ Grafik/chart (Fase 2)
- ❌ Dark mode (Fase 2)

## Breakdown Task
| # | Task | File |
|---|------|------|
| 1 | Riwayat list + filter bulanan | `lib/presentation/screens/riwayat_screen.dart` |
| 2 | Edit & hapus transaksi | update riwayat screen + provider |
| 3 | Final polish + integration test | `test/` |

## Design Teknis

### Theme System
- **Folder**: `lib/core/theme/` (dibuat di v0.1 task 6)
- **Warna**: Menggunakan `AppColors` dengan palet:
  - Primary: `#4274D9` (tombol, accent)
  - Primary Dark: `#293681` (text gelap, header)
  - Light: `#95CCDD` (background sekunder, divider)
  - Background: `#D0E7E6` (background screen)
  - Success: `#4CAF50` (pemasukan, saldo positif)
  - Error: `#F44336` (pengeluaran, saldo negatif)
- **Font**: Poppins (Regular, Medium, SemiBold, Bold) via `google_fonts`
- **Text Style**: Menggunakan `AppTextStyles` dari folder theme
- **Dekorasi**: Menggunakan `AppDecorations` untuk card, button, input

### Gambar & Ilustrasi
- **Empty State**: Gambar ilustrasi SVG/PNG di `assets/images/empty_state.png` (konsisten dengan dashboard)
- **Icon Tipe**: Pemasukan (`Icons.arrow_downward` hijau), Pengeluaran (`Icons.arrow_upward` merah)
- **Icon Filter**: `Icons.filter_list` atau `Icons.date_range`
- **Icon Edit/Delete**: `Icons.edit`, `Icons.delete`

### Filter Bulanan
```dart
// Query SQL
SELECT * FROM transaksi 
WHERE strftime('%Y-%m', tanggal / 1000, 'unixepoch') = '2026-07'
ORDER BY tanggal DESC;
```

### Edit Flow
```
User tap item → showDialog (Edit Catatan) → TextField pre-filled → 
Save → provider.update() → refresh list & dashboard
```

### Hapus Flow
```
User tap icon delete → AlertDialog ("Yakin hapus?") → 
Ya → provider.delete() → refresh list & dashboard
```

## Dampak ke Sistem
- Provider perlu method `delete(int id)` dan `updateCatatan(int id, String catatan)`
- Setiap edit/hapus → saldo dashboard auto-update
- Filter bulanan tidak mengganggu data lain

## Definition of Done
- [ ] Riwayat list tampil dengan data real
- [ ] Filter bulanan berfungsi
- [ ] Edit catatan sukses
- [ ] Hapus dengan konfirmasi
- [ ] Loading & empty state rapi
- [ ] `flutter analyze` bersih
- [ ] Integration test flow penuh pass
