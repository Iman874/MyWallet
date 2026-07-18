# Task 2 — Detail Transaksi Screen

## Judul
Buat Halaman Detail Transaksi

## Deskripsi
Buat layar baru yang menampilkan detail lengkap sebuah transaksi ketika user tap di dashboard atau riwayat.

## Tujuan Teknis
- `DetailTransaksiScreen` berfungsi
- Tampilkan semua info transaksi
- Tombol edit dan hapus tersedia

## Scope
- Buat `lib/presentation/screens/detail_transaksi_screen.dart`
- Update `dashboard_screen.dart` → tap transaksi navigasi ke detail
- Update `riwayat_screen.dart` → tap transaksi navigasi ke detail

## Langkah Implementasi
1. Buat `detail_transaksi_screen.dart`:
   - Terima `Transaksi` sebagai parameter
   - Tampilkan: jumlah, tanggal, kategori, catatan, tipe (dengan icon & warna)
   - Header gradient sesuai tipe (hijau pemasukan, merah pengeluaran)
   - Tombol Edit → navigasi ke form edit
   - Tombol Hapus → dialog konfirmasi → hapus → kembali
2. Update `dashboard_screen.dart`:
   - `TransaksiListItem` onTap → navigasi ke `DetailTransaksiScreen`
3. Update `riwayat_screen.dart`:
   - `TransaksiListItem` onTap → navigasi ke `DetailTransaksiScreen`

## Output yang Diharapkan
- Tap transaksi di dashboard → buka detail
- Detail tampilkan semua info
- Edit & hapus berfungsi

## Dependencies
- Task 1 selesai (model Transaksi sudah ada)

## Acceptance Criteria
- [ ] Tap transaksi → buka detail screen
- [ ] Semua info transaksi terlihat
- [ ] Tombol edit berfungsi
- [ ] Tombol hapus dengan konfirmasi

## Estimasi
2-3 jam
