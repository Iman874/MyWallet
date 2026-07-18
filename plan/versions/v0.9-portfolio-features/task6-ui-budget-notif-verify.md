# Task 6 - UI Budget Kategori + Notifikasi + Verifikasi

## Judul
Edit batas di KategoriScreen, progress bar di Dashboard/Statistik, notifikasi budget, lalu verify

## Deskripsi
Melengkapi budget per kategori: set batas dari UI, tampilkan progress pemakaian
bulan ini, dan notifikasi saat tercapai. Ditutup dengan flutter analyze + test.

## Tujuan Teknis
- Budget kategori terasa di UI & terintegrasi dengan sistem notifikasi.

## Scope
- `kategori_screen.dart`: form edit batas (nullable).
- `dashboard_screen.dart` / `statistik_screen.dart`: progress bar per kategori (bulan ini).
- `notifikasi_service.dart`: cek budget kategori -> buat notifikasi tipe 'kategori'.
- `flutter analyze` + `flutter test` + unit test service export/budget.

## Langkah Implementasi
1. KategoriScreen: tambah input batas (kosong = tanpa batas).
2. Dashboard/Statistik: kartu progress bar (terpakai/batas) per kategori pengeluaran aktif.
3. NotifikasiService.cekDanBuatNotifikasi: tambah _cekKategori (jika tipe pengeluaran &
   kategori punya batas & total bulan ini >= batas -> notifikasi sekali per bulan).
4. Tulis unit test: DataExportService (csv/json roundtrip), kalkulasi budget.
5. Jalankan `flutter analyze` & `flutter test`.

## Output yang Diharapkan
- Fitur budget kategori lengkap & teruji.

## Dependencies
- Task 5.

## Acceptance Criteria
- Bisa set/edit/hapus batas kategori.
- Progress bar akurat.
- Notifikasi muncul saat batas kategori tercapai.
- `flutter analyze` bersih, test pass.

## Estimasi
4 jam
