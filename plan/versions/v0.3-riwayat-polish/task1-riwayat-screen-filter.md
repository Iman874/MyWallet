# Task 1: Riwayat Screen & Filter Bulanan

## Deskripsi
Membangun halaman Riwayat Transaksi dengan ListView dan filter bulanan.

## Tujuan Teknis
- `RiwayatScreen` dengan ListView.builder, urut terbaru dulu
- Setiap item: tanggal, kategori, jumlah (warna hijau `AppColors.success`/merah `AppColors.error` sesuai tipe), icon tipe
- Filter bulanan: `DropdownButton` bulan + tahun, default bulan & tahun saat ini
- Ganti filter → reload data via provider
- Empty state: **gambar ilustrasi** + teks "Belum ada transaksi di bulan ini" saat filter kosong
- Loading indicator saat query

## Gambar & Ilustrasi
- **Empty State**: Gunakan gambar ilustrasi yang sama dengan dashboard (konsisten)
- **Icon Tipe**: Pemasukan (`Icons.arrow_downward` hijau), Pengeluaran (`Icons.arrow_upward` merah)
- **Icon Filter**: `Icons.filter_list` atau `Icons.date_range`

## Palet Warna yang Digunakan
| Komponen | Warna | Source |
|----------|-------|--------|
| Background Screen | Light Teal | `AppColors.background` |
| Filter Dropdown | Primary Blue | `AppColors.primary` |
| Pemasukan Text | Success Green | `AppColors.success` |
| Pengeluaran Text | Error Red | `AppColors.error` |
| Text Primary | Dark Blue | `AppColors.primaryDark` |

## Scope
- `lib/presentation/screens/riwayat_screen.dart`
- Update `TransaksiProvider.loadByMonth(int year, int month)`

## Output yang Diharapkan
- List transaksi dengan warna sesuai tipe
- Filter ganti bulan → list berubah
- Empty state dengan gambar ilustrasi
- Semua widget menggunakan `AppColors` dan `AppTextStyles` dari folder theme

## Dependencies
v0.2 (dashboard & provider)

## Acceptance Criteria
- [x] List tampil dengan data benar
- [x] Filter bulanan bekerja
- [x] Empty state untuk bulan tanpa data dengan gambar ilustrasi
- [x] Loading indicator muncul saat query
- [x] Semua widget menggunakan `AppColors` dan `AppTextStyles` dari folder theme
- [x] `flutter analyze` tanpa error baru

## Estimasi
60 menit

## Status: SELESAI
