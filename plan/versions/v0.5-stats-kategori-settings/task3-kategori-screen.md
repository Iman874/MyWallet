# Task 3: Update Tab Kategori (CRUD)

## Deskripsi
Mengisi tab Kategori dengan list kategori dan fitur CRUD (tambah, edit, hapus).

## Tujuan Teknis
- `KategoriScreen` dengan ListView kategori
- Setiap item: icon, nama kategori, tombol edit/hapus
- FAB untuk tambah kategori baru
- Dialog/form untuk tambah/edit kategori
- Dialog konfirmasi untuk hapus kategori
- Kategori default tidak bisa dihapus (hanya bisa edit nama)

## Widget Tree
```
KategoriScreen
├── StickyHeader ("Kategori")
├── ListView Kategori
│   └── KategoriItem (icon, nama, edit, delete)
├── FAB (tambah kategori)
└── DialogTambah/Edit
```

## Output yang Diharapkan
- `lib/presentation/screens/kategori_screen.dart`
- CRUD berfungsi
- Kategori default terlindungi

## Dependencies
- Task 2 (Repository & Provider)

## Acceptance Criteria
- [x] List kategori tampil dengan benar
- [x] Tambah kategori baru berfungsi
- [x] Edit kategori berfungsi
- [x] Hapus kategori dengan konfirmasi
- [x] Kategori default tidak bisa dihapus
- [x] `flutter analyze` tanpa error

## Estimasi
45 menit

## Status: SELESAI
