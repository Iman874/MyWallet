# Task 1 - Setup Dependency (fl_chart & file_picker)

## Judul
Tambah dependency fl_chart dan file_picker ke pubspec.yaml

## Deskripsi
Menambahkan package charting dan file picker yang dibutuhkan untuk pie chart dan
ekspor/impor data.

## Tujuan Teknis
- fl_chart: render pie chart komposisi kategori di Statistik.
- file_picker: pilih lokasi simpan (ekspor) & pilih file (impor).

## Scope
- Edit `pubspec.yaml`: tambah `fl_chart: ^0.69.0`, `file_picker: ^8.0.0`.
- `flutter pub get`.
- Cek permission storage Android (android/app/src/main/AndroidManifest.xml) untuk
  akses file (file_picker menangani sebagian besar via SAF).

## Langkah Implementasi
1. Tambah dependency di pubspec.yaml (section dependencies).
2. Jalankan `flutter pub get`.
3. Pastikan AndroidManifest sudah ada permission WRITE/READ external storage
   (atau gunakan SAF tanpa permission khusus).

## Output yang Diharapkan
- pubspec.yaml ter-update, `flutter pub get` sukses, tidak ada conflict versi.

## Dependencies
- Tidak ada (task pertama).

## Acceptance Criteria
- `flutter pub get` tanpa error.
- `flutter analyze` tetap bersih.
- Package fl_chart & file_picker bisa di-import.

## Estimasi
1 jam
