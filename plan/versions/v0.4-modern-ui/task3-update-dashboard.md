# Task 3: Update Dashboard Screen

## Deskripsi
Redesign DashboardScreen dengan design modern sesuai referensi: header gradient, saldo card modern, ringkasan harian card, transaksi terbaru dengan empty state.

## Tujuan Teknis
- Header: Gradient biru dengan lengkungan bawah, title "UangKu", icon notifikasi
- SaldoCard: Card gradient biru dengan ilustrasi wallet, tombol "Lihat Detail"
- RingkasanHarianCard: Card putih dengan shadow, pemasukan hijau & pengeluaran merah
- EmptyState: Ilustrasi 3D wallet + teks "Belum ada transaksi"
- FAB: Tombol bulat biru dengan icon +

## Widget Tree (Updated)
```
DashboardScreen (Scaffold)
├── GradientHeader
│   ├── Title "UangKu"
│   └── Icon Notifikasi
├── SaldoCard (gradient, wallet icon, "Lihat Detail")
├── RingkasanHarianCard (pemasukan hijau, pengeluaran merah)
└── TransaksiTerbaruList
    └── EmptyState (3D wallet illustration)
```

## Output yang Diharapkan
- Dashboard dengan header gradient modern
- Saldo card dengan gradient dan ilustrasi
- Ringkasan harian dengan warna modern
- Empty state dengan ilustrasi 3D
- FAB button biru

## Dependencies
- Task 1 (Update Theme)
- Task 2 (Create Widgets)

## Acceptance Criteria
- [x] Header gradient dengan lengkungan bawah
- [x] Saldo card modern dengan gradient
- [x] Ringkasan harian card modern
- [x] Empty state dengan ilustrasi 3D
- [x] FAB button biru
- [x] `flutter analyze` tanpa error baru

## Estimasi
60 menit

## Status: SELESAI
