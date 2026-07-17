# Task 4: Update Form Tambah Transaksi

## Deskripsi
Redesign TambahTransaksiScreen dengan design modern: header gradient, form inputs modern, tipe transaksi pill-shaped buttons.

## Tujuan Teknis
- Header: Gradient biru dengan back arrow dan title "Tambah Transaksi"
- Form inputs: Modern dengan icon prefix (Rp, calendar, category icon)
- Tipe Transaksi: Pill-shaped buttons (Pemasukan hijau, Pengeluaran merah)
- Catatan: Textarea modern dengan placeholder
- Tombol Simpan: Full-width biru dengan icon save

## Form Fields (Updated)
| Field | Widget | Style |
|-------|--------|-------|
| Jumlah | TextFormField | Icon "Rp" prefix, large text |
| Tanggal | DropdownButton | Calendar icon, modern style |
| Kategori | DropdownButton | Category icon, modern style |
| Tipe | PillButton | Pemasukan hijau, Pengeluaran merah |
| Catatan | TextFormField | Multiline, placeholder modern |

## Output yang Diharapkan
- Form dengan header gradient
- Input fields modern dengan icon prefix
- Tombol tipe transaksi pill-shaped
- Tombol simpan full-width biru

## Dependencies
- Task 1 (Update Theme)
- Task 2 (Create Widgets)

## Acceptance Criteria
- [x] Header gradient dengan back arrow
- [x] Input fields modern dengan icon prefix
- [x] Tipe transaksi pill-shaped buttons
- [x] Tombol simpan full-width biru
- [x] `flutter analyze` tanpa error baru

## Estimasi
60 menit

## Status: SELESAI
