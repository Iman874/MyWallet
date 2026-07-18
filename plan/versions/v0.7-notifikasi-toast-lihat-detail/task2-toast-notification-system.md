# Task 2: Toast Notification System

## Deskripsi
Membuat sistem notifikasi toast modern di pojok kanan atas dengan antrian maksimal 3 notifikasi. Menggantikan snackbar default Flutter.

## Tujuan Teknis
- Widget overlay di kanan atas, stacked
- Max 3 notifikasi bersamaan
- Tipe: success (hijau), error (merah), warning (kuning), info (biru)
- Auto-dismiss 3 detik, tap to dismiss
- Mengikuti tema light/dark

## Scope
- Buat `ToastProvider` (ChangeNotifier) — kelola antrian toast
- Buat `ToastWidget` — tampilan toast card
- Buat `ToastStack` — widget overlay di HomeScreen
- Integrasi ke screen yang ada

## Langkah Implementasi
1. Buat `ToastProvider` di `lib/presentation/providers/toast_provider.dart`
   - `List<ToastMessage> _toasts` dengan max 3
   - `add()` — append, auto-trim ke 3, auto-remove setelah durasi
   - `remove(id)` — manual dismiss
   - Method helper: `showSuccess()`, `showError()`, `showWarning()`, `showInfo()`
2. Buat model `ToastMessage` (id, tipe, title, message, durasi)
3. Buat `ToastWidget` — card dengan icon, title, message, warna sesuai tipe
4. Buat `ToastStack` — `Positioned` top-right, `Column` of `ToastWidget`
5. Register `ToastProvider` di `MultiProvider` main.dart
6. Tambah `ToastStack` di `HomeScreen` di atas `PageView`
7. Integrasi trigger toast di: tambah transaksi, edit transaksi, hapus transaksi

## Output yang Diharapkan
- Toast muncul di kanan atas setelah aksi CRUD
- Max 3 toast bersamaan
- Auto-dismiss setelah 3 detik
- Manual dismiss via tap

## Dependencies
- Task 1 (karena ada perubahan di form transaksi)

## Acceptance Criteria
- [ ] Toast muncul di pojok kanan atas
- [ ] Maksimal 3 toast bersamaan
- [ ] 4 tipe: success, error, warning, info — masing-masing warna berbeda
- [ ] Auto-dismiss 3 detik
- [ ] Tap untuk dismiss manual
- [ ] Mengikuti tema light/dark
- [ ] flutter analyze tidak ada error baru

## Estimasi
2 jam
