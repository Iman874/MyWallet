# Task 3 - UI Ekspor / Impor di Pengaturan

## Judul
Tambah section "Data" (Ekspor/Impor) di PengaturanScreen

## Deskripsi
Menambahkan tombol Ekspor CSV, Ekspor JSON, dan Impor di PengaturanScreen,
menggunakan file_picker dan DataExportService, dengan feedback toast.

## Tujuan Teknis
- Pengguna bisa backup & restore data dari UI.

## Scope
- Update `lib/presentation/screens/pengaturan_screen.dart`.
- Tambah section "Data" dengan 3 aksi.
- Panggil file_picker (save / open) + DataExportService.
- Tampilkan ToastProvider untuk sukses/gagal.

## Langkah Implementasi
1. Tambah `_buildDataSection` di PengaturanScreen.
2. Ekspor: generate string via service, simpan via file_picker (save).
3. Impor: pilih file via file_picker (open), parse via service, upsert.
4. Toast hasil (jumlah item, pesan error).
5. Handle iOS/Android path & permission error gracefully.

## Output yang Diharapkan
- Pengaturan punya alur ekspor/impor yang berfungsi.

## Dependencies
- Task 1, Task 2.

## Acceptance Criteria
- Tombol ekspor menyimpan file.
- Tombol impor memulihkan data & update provider.
- Toast informatif muncul.
- Error (file rusak) tidak crash app.

## Estimasi
2 jam
