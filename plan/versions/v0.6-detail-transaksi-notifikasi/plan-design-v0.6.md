# Plan Design v0.6 — Detail Transaksi & Notifikasi

## Latar Belakang
Pengguna membutuhkan cara untuk melihat detail transaksi secara lengkap dari halaman beranda, serta notifikasi otomatis ketika pemakaian harian/mingguan/bulanan sudah mencapai batas yang ditentukan.

## Tujuan
- Detail Transaksi: Ketika user tap transaksi di dashboard, tampilkan layar detail lengkap
- Notifikasi: Sistem notifikasi yang mendeteksi ketika pemakaian mencapai batas
- Pengaturan Batas: User bisa atur batas pemakaian harian, mingguan, bulanan

## Scope (Dikerjakan)
1. **Detail Transaksi Screen**
   - Layar baru `DetailTransaksiScreen`
   - Tampilkan: jumlah, tanggal, kategori, catatan, tipe
   - Tombol edit & hapus

2. **Sistem Notifikasi**
   - Model `Notifikasi` entity
   - Database tabel `notifikasi`
   - Deteksi otomatis saat tambah transaksi pengeluaran
   - Cek apakah melebihi batas harian/mingguan/bulanan

3. **Pengaturan Batas Pemakaian**
   - Simpan batas di `SharedPreferences`
   - Default: Harian Rp 200.000, Mingguan Rp 1.500.000, Bulanan Rp 5.000.000
   - UI di PengaturanScreen

4. **Halaman Notifikasi**
   - Tab/ikon notifikasi di dashboard
   - List notifikasi yang sudah diterima
   - Tandai sudah dibaca

## Scope (Tidak Dikerjakan)
- ❌ Push notification ke device ( hanya in-app )
- ❌ Notifikasi via email/SMS
- ❌ Export notifikasi
- ❌ Filter notifikasi

## File Terdampak
| Layer | File |
|-------|------|
| Entity | `lib/domain/entities/notifikasi.dart` |
| Repository | `lib/domain/repositories/notifikasi_repository.dart` |
| Repository Impl | `lib/data/repositories/notifikasi_repository_impl.dart` |
| Database | `lib/data/datasources/local/database_helper.dart` |
| Provider | `lib/presentation/providers/notifikasi_provider.dart` |
| Provider | `lib/presentation/providers/batas_provider.dart` |
| Screen | `lib/presentation/screens/detail_transaksi_screen.dart` |
| Screen | `lib/presentation/screens/notifikasi_screen.dart` |
| Widget | `lib/presentation/widgets/notifikasi_badge.dart` |
| Screen | `lib/presentation/screens/dashboard_screen.dart` (update) |
| Screen | `lib/presentation/screens/pengaturan_screen.dart` (update) |

## Design Teknis

### Skema Database (Notifikasi)
```sql
CREATE TABLE notifikasi (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  judul TEXT NOT NULL,
  pesan TEXT NOT NULL,
  tipe TEXT NOT NULL, -- 'harian', 'mingguan', 'bulanan'
  jumlah_pengeluaran INTEGER NOT NULL,
  batas INTEGER NOT NULL,
  isRead INTEGER NOT NULL DEFAULT 0,
  createdAt INTEGER NOT NULL
);
```

### Flow Notifikasi
1. User tambah transaksi pengeluaran
2. Hitung total pengeluaran (hari ini / minggu ini / bulan ini)
3. Bandingkan dengan batas dari SharedPreferences
4. Jika melebihi → buat notifikasi baru
5. Tampilkan badge di dashboard

### SharedPreferences Keys
- `batas_harian`: Default 200000
- `batas_mingguan`: Default 1500000
- `batas_bulanan`: Default 5000000

## Dampak ke Sistem
- Database version naik ke 4 (add tabel notifikasi)
- Dashboard ada ikon notifikasi dengan badge
- PengaturanScreen ada section "Batas Pemakaian"

## Definition of Done
- [ ] Tap transaksi di dashboard → buka DetailTransaksiScreen
- [ ] DetailTransaksiScreen tampilkan semua info transaksi
- [ ] Tambah transaksi pengeluaran → cek batas & buat notifikasi jika melebihi
- [ ] Ikon notifikasi di dashboard tampilkan badge jumlah belum dibaca
- [ ] Halaman notifikasi tampilkan list notifikasi
- [ ] Pengaturan bisa atur batas harian/mingguan/bulanan
- [ ] Default batas sudah terisi
- [ ] `flutter analyze` bersih
- [ ] Semua test pass
