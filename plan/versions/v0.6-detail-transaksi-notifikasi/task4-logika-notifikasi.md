# Task 4 — Logika Notifikasi Otomatis

## Judul
Implementasi Deteksi & Buat Notifikasi Otomatis

## Deskripsi
Ketika user tambah transaksi pengeluaran, hitung total pemakaian dan buat notifikasi jika melebihi batas.

## Tujuan Teknis
- Otomatis cek batas saat tambah transaksi
- Buat notifikasi jika melebihi
- Cek harian, mingguan, bulanan

## Scope
- Update `transaksi_provider.dart` → tambah logic notifikasi
- atau buat `notifikasi_service.dart` (lebih clean)

## Langkah Implementasi
1. Buat `lib/domain/services/notifikasi_service.dart`:
   - Method `cekDanBuatNotifikasi(Transaksi transaksi)`:
     - Jika tipe == pengeluaran:
       - Hitung total hari ini
       - Hitung total minggu ini
       - Hitung total bulan ini
       - Bandingkan dengan batas dari BatasProvider
       - Jika melebihi → buat notifikasi via NotifikasiProvider
2. Panggil service di `TransaksiProvider.add()` setelah transaksi berhasil ditambah
3. Format pesan notifikasi:
   - "Pengeluaran harian Anda sudah mencapai Rp X (Batas: Rp Y)"
   - "Pengeluaran mingguan Anda sudah mencapai Rp X (Batas: Rp Y)"
   - "Pengeluaran bulanan Anda sudah mencapai Rp X (Batas: Rp Y)"

## Output yang Diharapkan
- Tambah pengeluaran → notifikasi muncul jika melebihi batas
- 3 jenis notifikasi: harian, mingguan, bulanan

## Dependencies
- Task 1 (NotifikasiProvider)
- Task 3 (BatasProvider)

## Acceptance Criteria
- [ ] Tambah pengeluaran → cek batas
- [ ] Notifikasi dibuat jika melebihi
- [ ] 3 jenis notifikasi berfungsi

## Estimasi
2-3 jam
