# Task 5 — Halaman Notifikasi

## Judul
Buat Halaman Notifikasi & Badge

## Deskripsi
Buat halaman notifikasi dan badge indicator di dashboard.

## Tujuan Teknis
- Ikon notifikasi di dashboard dengan badge
- Halaman notifikasi tampilkan list
- Tandai sudah dibaca

## Scope
- Buat `lib/presentation/screens/notifikasi_screen.dart`
- Buat `lib/presentation/widgets/notifikasi_badge.dart`
- Update `dashboard_screen.dart` → tambah ikon notifikasi

## Langkah Implementasi
1. Buat `notifikasi_badge.dart`:
   - Widget ikon notifikasi dengan badge angka
   - Badge tampilkan jumlah belum dibaca
   - Tap → navigasi ke notifikasi screen
2. Buat `notifikasi_screen.dart`:
   - Header "Notifikasi"
   - List notifikasi (chronological)
   - Setiap item: icon tipe, judul, pesan, waktu
   - Tap → tandai dibaca
   - Empty state jika belum ada notifikasi
3. Update `dashboard_screen.dart`:
   - Tambah `NotifikasiBadge` di header (sebelah kanan)
   - Pass context ke navigation

## Output yang Diharapkan
- Ikon notifikasi di dashboard
- Badge menunjukkan jumlah belum dibaca
- Halaman notifikasi berfungsi

## Dependencies
- Task 1 (NotifikasiProvider)
- Task 4 (logika notifikasi)

## Acceptance Criteria
- [ ] Ikon notifikasi di dashboard
- [ ] Badge tampilkan jumlah
- [ ] Halaman notifikasi tampil
- [ ] Tap notifikasi → tandai dibaca

## Estimasi
2-3 jam
