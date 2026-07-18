# Task 1: Lihat Detail & Edit Transaksi Penuh

## Deskripsi
Membuat tombol "Lihat Detail" di saldo card berfungsi, dan mengubah tombol Edit di detail transaksi menjadi navigasi ke form transaksi penuh (bukan hanya dialog edit catatan).

## Tujuan Teknis
- "Lihat Detail" navigasi ke halaman Riwayat
- Form transaksi bisa menerima data existing untuk mode edit
- Setelah simpan edit, kembali ke detail screen

## Scope
- DashboardScreen: "Lihat Detail" di saldo card → switch ke tab Riwayat
- HomeScreen: tambah method untuk switch tab dari child via callback/GlobalKey
- DetailTransaksiScreen: tombol Edit → navigasi ke form edit
- TambahTransaksiScreen: terima optional `Transaksi` parameter
- Form: judul dinamis, pre-populate data, submit panggil update() jika mode edit

## Langkah Implementasi
1. HomeScreen: buat `switchToTab(int index)` via GlobalKey
2. DashboardScreen: panggil `HomeScreen.switchToTab(1)` saat "Lihat Detail" di-tap
3. TambahTransaksiScreen: tambah optional `Transaksi? transaksi` parameter
4. Form: deteksi mode edit dari `widget.transaksi`, ubah judul jadi "Edit Transaksi"
5. Form: pre-populate jumlah, tanggal, kategori, tipe, catatan
6. Form: submit panggil `update()` jika mode edit, `add()` jika tambah baru
7. DetailTransaksiScreen: tombol Edit → navigasi ke form edit
8. DetailTransaksiScreen: setelah back dari form edit, refresh data

## Output yang Diharapkan
- "Lihat Detail" pindah ke tab Riwayat
- Edit transaksi buka form penuh dengan data terisi
- Simpan edit berhasil, kembali ke detail

## Dependencies
- None

## Acceptance Criteria
- [ ] "Lihat Detail" di saldo card navigasi ke Riwayat
- [ ] Tombol Edit di detail screen buka form dengan judul "Edit Transaksi"
- [ ] Form terisi data transaksi yang diedit
- [ ] Simpan edit panggil update() bukan add()
- [ ] Setelah simpan, kembali ke detail screen dengan data baru
- [ ] flutter analyze tidak ada error baru

## Estimasi
1.5 jam
