# Task 5: Update Riwayat Screen

## Deskripsi
Redesign RiwayatScreen dengan design modern: header gradient, filter card modern, empty state dengan ilustrasi 3D.

## Tujuan Teknis
- Header: Gradient biru dengan title "Riwayat Transaksi" dan icon kalender
- Filter: Card putih dengan shadow, dropdown bulan & tahun modern
- EmptyState: Ilustrasi 3D receipt + teks "Belum ada transaksi di bulan ini"
- List: Card transaksi modern dengan shadow

## Widget Tree (Updated)
```
RiwayatScreen (Scaffold)
├── GradientHeader
│   ├── Title "Riwayat Transaksi"
│   └── Icon Kalender
├── FilterCard
│   ├── Dropdown Bulan (icon kalender)
│   └── Dropdown Tahun (icon kalender)
└── ListView
    ├── TransaksiListItem (modern card)
    └── EmptyState (3D receipt illustration)
```

## Output yang Diharapkan
- Riwayat dengan header gradient
- Filter card modern dengan shadow
- Empty state dengan ilustrasi 3D
- List transaksi modern

## Dependencies
- Task 1 (Update Theme)
- Task 2 (Create Widgets)

## Acceptance Criteria
- [x] Header gradient dengan icon kalender
- [x] Filter card modern
- [x] Empty state dengan ilustrasi 3D
- [x] List transaksi modern
- [x] `flutter analyze` tanpa error baru

## Estimasi
60 menit

## Status: SELESAI
