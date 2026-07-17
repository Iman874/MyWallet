# Task 2: Edit Catatan & Hapus Transaksi

## Deskripsi
Menambahkan fitur edit catatan dan hapus transaksi di halaman riwayat.

## Tujuan Teknis
- **Edit**: tap item → AlertDialog dengan TextField catatan (pre-filled) → simpan → `provider.updateCatatan(id, catatanBaru)` → refresh list & dashboard
- **Hapus**: icon delete di setiap item → AlertDialog konfirmasi "Yakin ingin menghapus transaksi ini?" → Ya → `provider.delete(id)` → refresh list & dashboard
- Saldo real-time update setelah edit/hapus
- Error snackbar jika gagal

## Gambar & Icon
- **Icon Edit**: `Icons.edit` atau `Icons.edit_note`
- **Icon Delete**: `Icons.delete` atau `Icons.delete_outline`
- **Dialog Background**: Gunakan `AppColors.background`

## Palet Warna yang Digunakan
| Komponen | Warna | Source |
|----------|-------|--------|
| Dialog Background | Light Teal | `AppColors.background` |
| Icon Edit | Primary Blue | `AppColors.primary` |
| Icon Delete | Error Red | `AppColors.error` |
| Button Batal | Light Teal | `AppColors.light` |
| Button Hapus | Error Red | `AppColors.error` |
| Text Primary | Dark Blue | `AppColors.primaryDark` |

## Scope
- Update `lib/presentation/screens/riwayat_screen.dart`
- Update provider: `delete(int id)`, `updateCatatan(int id, String catatan)`

## Output yang Diharapkan
- Edit catatan: dialog muncul, simpan → catatan berubah → saldo tetap (karena catatan tidak pengaruh saldo)
- Hapus: dialog konfirmasi → hapus → list hilang → saldo berubah
- Semua dialog menggunakan `AppColors` dan `AppTextStyles` dari folder theme

## Dependencies
Task 1 (Riwayat screen)

## Acceptance Criteria
- [x] Tap item → dialog edit muncul dengan catatan saat ini
- [x] Simpan edit → catatan terupdate
- [x] Icon delete → dialog konfirmasi muncul dengan warna yang benar
- [x] Konfirmasi hapus → transaksi hilang dari list
- [x] Saldo dashboard update setelah hapus
- [x] Batal hapus → tidak ada perubahan
- [x] Semua dialog menggunakan `AppColors` dan `AppTextStyles` dari folder theme
- [x] `flutter analyze` tanpa error baru

## Estimasi
45 menit

## Status: SELESAI
