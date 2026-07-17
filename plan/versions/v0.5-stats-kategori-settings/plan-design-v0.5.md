# Plan Design v0.5 — Statistik, Kategori CRUD, Pengaturan

## Latar Belakang
Tab Statistik, Kategori, dan Pengaturan sudah tersedia di navbar tapi masih placeholder. Sekarang perlu diisi dengan konten yang berfungsi.

## Tujuan
- Tab Statistik: Menampilkan grafik ringkasan keuangan (pemasukan vs pengeluaran bulanan)
- Tab Kategori: CRUD kategori transaksi (tambah, edit, hapus)
- Tab Pengaturan: Theme settings (light/dark mode)

## Scope (Dikerjakan)
- Update `StatistikScreen` dengan chart dan ringkasan
- Update `KategoriScreen` dengan list + CRUD
- Update `PengaturanScreen` dengan theme toggle
- Buat model `Kategori` baru
- Update database untuk tabel kategori
- Update provider untuk kategori

## Scope (Tidak Dikerjakan)
- ❌ Export data
- ❌ Backup/restore
- ❌ Notifikasi
- ❌ Profile user

## Definition of Done
- [ ] Statistik menampilkan chart pemasukan vs pengeluaran
- [ ] Kategori bisa CRUD (tambah, edit, hapus)
- [ ] Pengaturan bisa toggle light/dark mode
- [ ] `flutter analyze` bersih
- [ ] Semua test pass
