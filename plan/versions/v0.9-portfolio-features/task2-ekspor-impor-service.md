# Task 2 - Ekspor / Impor Data Service

## Judul
Buat DataExportService untuk ekspor & impor (CSV + JSON)

## Deskripsi
Service di domain layer yang mengubah list transaksi + kategori menjadi file CSV/JSON
dan sebaliknya, dengan validasi dan upsert berdasarkan id.

## Tujuan Teknis
- Melindungi data pengguna dari kehilangan saat uninstall.
- Format mudah dibaca (CSV) dan lengkap (JSON).

## Scope
- Buat `lib/domain/services/data_export_service.dart`.
- Fungsi: `exportCsv()`, `exportJson()`, `importCsv()`, `importJson()`.
- Validasi: jumlah > 0, tipe valid (pemasukan/pengeluaran), tanggal valid.
- Upsert: jika id sudah ada -> update, jika baru -> insert (via repository).

## Langkah Implementasi
1. Buat class DataExportService dengan dependency TransaksiRepository & KategoriRepository.
2. Build CSV string (header + row) untuk transaksi & kategori.
3. Build JSON map {transaksi:[...], kategori:[...]}.
4. Parse CSV/JSON saat impor, validasi tiap baris, lalu panggil repository upsert.
5. Return hasil (jumlah sukses/gagal).

## Output yang Diharapkan
- Service siap dipakai provider, dengan fungsi ekspor & impor.

## Dependencies
- Task 1 (file_picker).

## Acceptance Criteria
- Ekspor CSV menghasilkan string dengan header benar.
- Ekspor JSON berisi transaksi + kategori.
- Impor tidak buat duplikat (upsert by id).
- Data invalid dilewati / dilaporkan.

## Estimasi
3 jam
