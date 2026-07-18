# Plan Design v0.9 - Fitur Portofolio (Ekspor/Impor, Pie Chart, Budget Kategori)

## Latar Belakang
UangKu sudah melewati scope MVP (dasbor, catat, riwayat) dengan tambahan statistik,
kategori custom, batas pemakaian, notifikasi, dark mode, dan splash screen. Untuk
memperkuat nilai portofolio, diperlukan fitur yang (1) melindungi data pengguna,
(2) memperkaya visualisasi, dan (3) memberi kontrol anggaran yang lebih granular.

## Tujuan
- Ekspor/Impor data transaksi & kategori (CSV + JSON) agar data aman saat uninstall.
- Pie chart komposisi pengeluaran per kategori di halaman Statistik (pakai fl_chart).
- Budget per kategori: batas spesifik tiap kategori pengeluaran + progress bar + notifikasi.

## Scope (Dikerjakan)
1. **Ekspor / Impor Data**
   - Entity helper `DataExportService` (domain/services)
   - Ekspor ke CSV dan JSON (transaksi + kategori) via file picker
   - Impor dari CSV/JSON dengan validasi & upsert (hindari duplikat by id)
   - UI di PengaturanScreen (section "Data")

2. **Pie Chart Statistik**
   - Tambah dependency `fl_chart`
   - Widget `PieKategoriWidget` di statistik_screen (komposisi pengeluaran per kategori)
   - Legend kategori + total di tengah

3. **Budget Per Kategori**
   - Kolom `batas` di tabel `kategori` (NULL = tanpa batas)
   - Edit batas di KategoriScreen
   - Progress bar pemakaian bulan ini per kategori di Dashboard/Statistik
   - Notifikasi saat batas kategori tercapai (extend NotifikasiService)

## Scope (Tidak Dikerjakan)
- X Backup otomatis ke cloud / Google Drive
- X Ekspor PDF
- X Multi-wallet / akun
- X Recurring transaction
- X PIN / biometric lock

## File Terdampak
| Layer | File |
|-------|------|
| Service | `lib/domain/services/data_export_service.dart` (baru) |
| Dependency | `pubspec.yaml` (tambah fl_chart, file_picker) |
| Widget | `lib/presentation/widgets/pie_kategori_widget.dart` (baru) |
| Screen | `lib/presentation/screens/statistik_screen.dart` (update) |
| Screen | `lib/presentation/screens/pengaturan_screen.dart` (update) |
| Screen | `lib/presentation/screens/kategori_screen.dart` (update) |
| Screen | `lib/presentation/screens/dashboard_screen.dart` (update) |
| Entity | `lib/domain/entities/kategori.dart` (tambah field batas) |
| Database | `lib/data/datasources/local/database_helper.dart` (alter kategori) |
| Repo | `lib/domain/repositories/kategori_repository.dart` (update) |
| Repo Impl | `lib/data/repositories/kategori_repository_impl.dart` (update) |
| Provider | `lib/presentation/providers/kategori_provider.dart` (update) |
| Service | `lib/domain/services/notifikasi_service.dart` (update cek budget kategori) |

## Design Teknis

### Skema Database
```sql
-- kategori: tambah kolom batas (NULL = tanpa batas)
ALTER TABLE kategori ADD COLUMN batas INTEGER; -- default NULL
```
Database version naik (cek current di database_helper, +1).

### Ekspor (CSV)
- File: `uangku_transaksi_YYYYMMDD.csv` dan `uangku_kategori_YYYYMMDD.csv`
- JSON: `uangku_backup_YYYYMMDD.json` (berisi transaksi + kategori)
- Impor: parse, validasi tipe/jumlah > 0, upsert by id (update jika id ada, insert jika baru).

### Pie Chart
- `fl_chart` PieChart dengan section per kategori pengeluaran (bulan terpilih).
- Warna ambil dari `kategori.warna`.
- Center: total pengeluaran bulan tersebut.

### Budget Kategori
- `Kategori.batas` (int?, nullable).
- Progress = totalPengeluaranKategoriBulanIni / batas.
- Jika >= 1.0 dan belum ada notifikasi kategori bulan ini -> buat notifikasi tipe 'kategori'.

## Dampak ke Sistem
- Dependency baru: fl_chart, file_picker (perhatikan izin storage di Android/iOS).
- Database version naik -> migration alter kategori.
- NotifikasiService cek tambahan untuk budget kategori.

## Definition of Done
- [ ] Ekspor CSV + JSON berhasil & file valid
- [ ] Impor CSV/JSON restore data tanpa duplikat
- [ ] Pie chart tampil di Statistik dengan legend & total tengah
- [ ] Kategori bisa di-set batasnya
- [ ] Progress bar budget kategori di Dashboard/Statistik
- [ ] Notifikasi saat batas kategori tercapai
- [ ] `flutter analyze` bersih
- [ ] Test relevan pass (export/import service, budget calc)
