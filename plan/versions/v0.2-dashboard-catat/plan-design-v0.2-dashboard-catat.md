# Plan Design v0.2 — Dashboard & Catat Transaksi

## Latar Belakang
Fondasi data layer (v0.1) sudah siap. Sekarang bangun UI utama: Dasbor Keuangan dan Form Catat Transaksi.

## Tujuan
- Dasbor menampilkan saldo terkini, ringkasan harian (pemasukan hijau / pengeluaran merah), 5 transaksi terbaru
- Form tambah transaksi dengan validasi (jumlah > 0, kategori dropdown, tanggal, catatan opsional)
- Empty state saat belum ada transaksi
- `flutter analyze` bersih

## Scope (Dikerjakan)
- Dashboard screen dengan Consumer<TransaksiProvider>
- Widget: SaldoCard, RingkasanHarianCard, TransaksiTerbaruList
- Form tambah transaksi (pemasukan & pengeluaran)
- Validasi: jumlah wajib > 0, tanggal tidak boleh kosong
- Submit → simpan DB → balik dashboard → refresh
- Empty state (belum ada transaksi)
- Widget test dashboard & form

## Scope (Tidak Dikerjakan)
- ❌ Riwayat transaksi (v0.3)
- ❌ Edit/hapus transaksi (v0.3)
- ❌ Filter bulanan (v0.3)
- ❌ Routing multi-screen (cukup bottom nav / floating button)

## Breakdown Task
| # | Task | File |
|---|------|------|
| 1 | Dashboard UI | `lib/presentation/screens/dashboard_screen.dart`, widgets |
| 2 | Form tambah transaksi | `lib/presentation/screens/tambah_transaksi_screen.dart` |
| 3 | Widget test & verify | `test/presentation/screens/` |

## Design Teknis

### Theme System
- **Folder**: `lib/core/theme/` (dibuat di v0.1 task 6)
- **Warna**: Menggunakan `AppColors` dengan palet:
  - Primary: `#4274D9` (tombol, accent)
  - Primary Dark: `#293681` (text gelap, header)
  - Light: `#95CCDD` (background sekunder, divider)
  - Background: `#D0E7E6` (background screen)
  - Success: `#4CAF50` (pemasukan, saldo positif)
  - Error: `#F44336` (pengeluaran, saldo negatif)
- **Font**: Poppins (Regular, Medium, SemiBold, Bold) via `google_fonts`
- **Text Style**: Menggunakan `AppTextStyles` dari folder theme
- **Dekorasi**: Menggunakan `AppDecorations` untuk card, button, input

### Gambar & Ilustrasi
- **Empty State**: Gambar ilustrasi SVG/PNG di `assets/images/empty_state.png`
- **Icon Kategori**: Material icons yang sesuai
- **Asset**: Didafarkan di `pubspec.yaml` bagian `flutter: assets:`

### Widget Tree
```
DashboardScreen (Scaffold)
├── SaldoCard (total saldo)
├── RingkasanHarianCard (pemasukan hijau / pengeluaran merah)
└── TransaksiTerbaruList (ListView, max 5)
    └── TransaksiListItem (icon, kategori, jumlah, tanggal)
```

### Form Fields
| Field | Widget | Validasi |
|-------|--------|----------|
| Jumlah | TextFormField (numeric) | > 0, wajib |
| Tanggal | TextFormField + DatePicker | default hari ini, wajib |
| Kategori | DropdownButton | Gaji, Makan, Transportasi, Hiburan, Lainnya |
| Tipe | Radio | Pemasukan / Pengeluaran |
| Catatan | TextFormField (multiline) | opsional |

## Dampak ke Sistem
- Provider perlu method `getRingkasanHarian(DateTime)` dan `getTerbaru(int limit)`
- Dashboard perlu auto-refresh setelah transaksi baru

## Definition of Done
- [ ] Dashboard tampil: saldo, ringkasan, 5 terbaru
- [ ] Form tambah transaksi: semua field + validasi
- [ ] Submit → simpan → balik dashboard → saldo update
- [ ] Empty state saat 0 transaksi
- [ ] `flutter analyze` bersih
- [ ] Widget test pass
