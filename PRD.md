# Product Requirements Document (PRD)
# UangKu — Aplikasi Pencatatan Keuangan Pribadi

Status: Perencanaan (Draft) | Fase: 1 (MVP) | Platform: Mobile Android & iOS | Framework: Flutter (Dart)

## Ringkasan
UangKu = aplikasi pencatatan keuangan pribadi. Fase 1: (1) Dasbor Keuangan, (2) Catat Transaksi, (3) Riwayat Transaksi.

## Fase 1 — Scope
- Dasbor Keuangan: Saldo Terkini, Ringkasan Harian, Transaksi Terbaru (5 terakhir)
- Catat Transaksi: Tambah Pemasukan, Tambah Pengeluaran
  - Field: jumlah (positif, wajib), tanggal (default hari ini), kategori (dropdown: Gaji, Makan, Transportasi, Hiburan, Lainnya), catatan (opsional)
- Riwayat Transaksi: Daftar Semua Transaksi, Filter Bulanan, Edit Catatan, Hapus Catatan

## Kebutuhan Teknis
- Flutter + Dart, SQLite lokal (sqflite/Hive) untuk offline-first
- State management: Provider/Riverpod/Bloc
- Dasbor load < 2 detik; cold start < 3 detik; crash < 1%
- Validasi: jumlah tidak boleh 0/negatif
- Edit/Hapus langsung update saldo

## Acceptance Criteria
- Saldo terkini real-time update tiap transaksi baru/edit/hapus
- Ringkasan harian: pemasukan (hijau) & pengeluaran (merah) terpisah
- Transaksi terbaru max 5 item, terbaru dulu
- Empty state kalau belum ada transaksi
- List riwayat: tanggal, kategori, jumlah, tipe dgn indikator warna
- Hapus perlu dialog konfirmasi
