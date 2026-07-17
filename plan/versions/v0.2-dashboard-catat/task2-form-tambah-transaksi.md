# Task 2: Form Tambah Transaksi

## Deskripsi
Membangun halaman form untuk menambahkan transaksi pemasukan atau pengeluaran.

## Tujuan Teknis
- Field jumlah: `TextFormField` numeric keyboard, validasi > 0 dan wajib
- Field tanggal: `TextFormField` read-only + `showDatePicker`, default DateTime.now()
- Field kategori: `DropdownButtonFormField` dengan opsi: Gaji, Makan, Transportasi, Hiburan, Lainnya
- Field tipe: `Radio` button Pemasukan / Pengeluaran, default Pemasukan
- Field catatan: `TextFormField` multiline, opsional
- Tombol Simpan: validasi semua field → panggil `provider.add()` → pop back ke dashboard
- Loading state saat simpan (CircularProgressIndicator)
- Error snackbar jika gagal simpan

## Gambar & Icon
- **Icon Kategori**: Gunakan icon material yang sesuai:
  - Gaji: `Icons.attach_money`
  - Makan: `Icons.restaurant`
  - Transportasi: `Icons.directions_car`
  - Hiburan: `Icons.sports_esports`
  - Lainnya: `Icons.category`
- **Icon Tipe**: Pemasukan (`Icons.arrow_downward` hijau), Pengeluaran (`Icons.arrow_upward` merah)
- **Background**: Gunakan `AppColors.background` untuk screen

## Palet Warna yang Digunakan
| Komponen | Warna | Source |
|----------|-------|--------|
| Primary Button (Simpan) | Primary Blue | `AppColors.primary` |
| Input Border | Light Teal | `AppColors.light` |
| Background Screen | Light Teal | `AppColors.background` |
| Text Primary | Dark Blue | `AppColors.primaryDark` |
| Pemasukan Radio | Success Green | `AppColors.success` |
| Pengeluaran Radio | Error Red | `AppColors.error` |

## Scope
- `lib/presentation/screens/tambah_transaksi_screen.dart`

## Output yang Diharapkan
- Form lengkap dengan validasi
- Simpan sukses → balik dashboard → saldo update
- Validasi error muncul jika jumlah kosong / <= 0
- Semua input menggunakan decoration dari `AppDecorations`
- Semua text menggunakan `AppTextStyles` dari folder theme

## Dependencies
Task 1 (Dashboard screen)

## Acceptance Criteria
- [ ] Semua field berfungsi
- [ ] Validasi jumlah > 0, tanggal tidak null
- [ ] Simpan → provider.add() dipanggil → pop
- [ ] Error state & loading state terhandle
- [ ] Semua input menggunakan `AppDecorations.inputDecoration()`
- [ ] Semua text menggunakan `AppTextStyles` dari folder theme
- [ ] Icon kategori sesuai dengan material icons
- [ ] `flutter analyze` tanpa error baru

## Estimasi
60 menit
