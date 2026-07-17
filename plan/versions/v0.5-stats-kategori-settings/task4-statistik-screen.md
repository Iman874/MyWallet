# Task 4: Update Tab Statistik

## Deskripsi
Mengisi tab Statistik dengan grafik ringkasan keuangan bulanan.

## Tujuan Teknis
- `StatistikScreen` dengan chart pemasukan vs pengeluaran
- Ringkasan total pemasukan, pengeluaran, dan selisih bulan ini
- Filter bulan seperti di Riwayat
- Chart bar atau pie chart sederhana

## Widget Tree
```
StatistikScreen
├── StickyHeader ("Statistik")
├── Filter Bulan/Tahun
├── Ringkasan Card
│   ├── Total Pemasukan
│   ├── Total Pengeluaran
│   └── Selisih
└── Chart Card
    └── Bar Chart (pemasukan vs pengeluaran)
```

## Output yang Diharapkan
- `lib/presentation/screens/statistik_screen.dart`
- Chart menampilkan data dari provider
- Ringkasan perhitungan benar

## Dependencies
- v0.1-v0.4 (provider sudah ada)

## Acceptance Criteria
- [x] Statistik menampilkan total pemasukan/pengeluaran
- [x] Chart bar tampil dengan benar
- [x] Filter bulan berfungsi
- [x] Selisih dihitung benar
- [x] `flutter analyze` tanpa error

## Estimasi
45 menit

## Status: SELESAI
