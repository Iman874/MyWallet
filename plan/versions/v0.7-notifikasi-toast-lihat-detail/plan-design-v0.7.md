# Plan Design v0.7 — Toast Notifikasi, Edit Transaksi Penuh, Lihat Detail

## Latar Belakang
- Tombol "Lihat Detail" di saldo card dashboard tidak berfungsi (hanya dekorasi)
- Tombol "Edit" di detail transaksi hanya edit catatan lewat dialog, tidak bisa ubah jumlah/kategori/dll
- Belum ada sistem notifikasi toast/feedback visual setelah aksi (simpan, hapus, edit)

## Tujuan
1. Tombol "Lihat Detail" → navigasi ke halaman riwayat (tab 1)
2. Tombol "Edit" → buka form transaksi penuh dengan data terisi, judul "Edit Transaksi"
3. Sistem toast notifikasi modern (pojok kanan atas, max 3, sesuai theme)

## Scope (dikerjakan)
- DashboardScreen: "Lihat Detail" → pindah ke tab Riwayat
- DetailTransaksiScreen: tombol Edit → navigasi ke form edit dengan data pre-filled
- Form transaksi (`TambahTransaksiScreen`): refactor jadi bisa menerima optional `Transaksi` parameter untuk mode edit
- Widget baru: `ToastNotification` — overlay widget di pojok kanan atas
- `ToastService` / Provider untuk manage antrian toast (max 3)
- Semua screen: trigger toast setelah add/update/delete transaksi

## Scope (tidak dikerjakan)
- Animasi toast yang kompleks (slide + fade cukup)
- Sound effect notifikasi

## Breakdown Task

### Task 1: Lihat Detail & Edit Transaksi Penuh
- Buat "Lihat Detail" di saldo card navigasi ke tab Riwayat
- Refactor TambahTransaksiScreen jadi bisa mode edit (terima optional `Transaksi`)
- Judul dinamis: "Tambah Transaksi" / "Edit Transaksi"
- Pre-populate form dengan data transaksi existing
- Submit: panggil `update()` bukan `add()` saat mode edit
- DetailTransaksiScreen: tombol Edit → navigasi ke form edit, setelah simpan back ke detail
- Trigger notifikasi habis simpan/hapus

### Task 2: Toast Notification System
- Buat `ToastProvider` (ChangeNotifier) dengan antrian max 3
- Tipe: success (hijau), error (merah), warning (kuning), info (biru)
- Durasi: 3 detik auto-dismiss, bisa di-tap untuk dismiss manual
- Posisi: top-right overlay, stacked

### Task 3: Integrasi Toast & Final Verify
- Integrasi toast ke semua screen (dashboard, detail, riwayat, form)
- Hapus dialog edit catatan lama (diganti form penuh)
- flutter analyze & test

## Design Teknis

### File Terdampak

| File | Perubahan |
|------|-----------|
| `lib/presentation/screens/dashboard_screen.dart` | "Lihat Detail" → navigasi ke tab Riwayat via callback/home |
| `lib/presentation/screens/detail_transaksi_screen.dart` | Edit → form penuh, hapus dialog edit catatan lama |
| `lib/presentation/screens/tambah_transaksi_screen.dart` | Terima optional `Transaksi` parameter, mode edit |
| `lib/presentation/screens/home_screen.dart` | Tambah method/GlobalKey untuk switch tab dari child |
| `lib/presentation/providers/toast_provider.dart` | **BARU** — ChangeNotifier, antrian max 3 |
| `lib/presentation/widgets/toast_widget.dart` | **BARU** — Stacked overlay widget |
| `lib/presentation/screens/home_screen.dart` | Tambah `ToastStack` overlay |

### Flow Edit Transaksi
1. User tap "Edit" di DetailTransaksiScreen
2. Navigasi ke TambahTransaksiScreen(transaksi: existingData)
3. Form terisi: jumlah, tanggal, kategori, tipe, catatan
4. User ubah data, tap "Simpan"
5. Provider.update(transaksi) dipanggil
6. Toast sukses muncul
7. Kembali ke DetailTransaksiScreen (data sudah baru)

### Skema Toast Provider
```
ToastProvider
├── List<ToastMessage> _toasts (max 3)
├── add(ToastMessage)
├── remove(int id)
├── clear()
└── ToastMessage { id, tipe, judul, pesan, durasi }
```

## Dampak ke Sistem
- Tambah 2 file baru (toast_provider, toast_widget)
- Form transaksi jadi dual-mode (tambah/edit)
- Dashboard "Lihat Detail" jadi fungsional
- Semua screen dapat trigger toast setelah aksi

## Definition of Done
- "Lihat Detail" navigasi ke tab Riwayat
- Edit transaksi buka form penuh, title "Edit Transaksi"
- Data terisi sesuai transaksi yang diedit
- Toast muncul di kanan atas, max 3, auto-dismiss
- Toast mengikuti tema light/dark
- flutter analyze: 0 error
- flutter test: semua existing test pass
