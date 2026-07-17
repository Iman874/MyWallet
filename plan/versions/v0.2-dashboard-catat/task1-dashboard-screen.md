# Task 1: Dashboard Screen

## Deskripsi
Membangun halaman utama Dasbor dengan saldo, ringkasan harian, dan 5 transaksi terbaru.

## Tujuan Teknis
- `DashboardScreen` sebagai home screen
- `SaldoCard` — tampilkan saldo total (hijau `AppColors.success` jika > 0, merah `AppColors.error` jika < 0, abu-abu jika 0)
- `RingkasanHarianCard` — pemasukan (hijau) & pengeluaran (merah) terpisah
- `TransaksiTerbaruList` — ListView max 5 item, terbaru di atas
- `EmptyStateWidget` — tampilkan **gambar ilustrasi** (SVG/PNG) & teks "Belum ada transaksi"
- Gunakan `Consumer<TransaksiProvider>` untuk reactive update

## Gambar & Ilustrasi
- **Empty State**: Gunakan gambar ilustrasi SVG/PNG yang jelas (contoh: dompet kosong, buku catatan)
- **Icon Kategori**: Gunakan icon yang sesuai dari material icons atau asset custom
- **Format gambar**: Simpan di `assets/images/` dan daftarkan di `pubspec.yaml`
- **Command untuk generate asset**: `flutter pub run flutter_launcher_icons:main` (jika perlu icon app)

## Palet Warna yang Digunakan
| Komponen | Warna | Source |
|----------|-------|--------|
| Saldo Positif | Success Green | `AppColors.success` |
| Saldo Negatif | Error Red | `AppColors.error` |
| Primary Button | Primary Blue | `AppColors.primary` |
| Background Screen | Light Teal | `AppColors.background` |
| Text Primary | Dark Blue | `AppColors.primaryDark` |

## Scope
- `lib/presentation/screens/dashboard_screen.dart`
- `lib/presentation/widgets/saldo_card.dart`
- `lib/presentation/widgets/ringkasan_harian_card.dart`
- `lib/presentation/widgets/transaksi_terbaru_list.dart`
- `lib/presentation/widgets/transaksi_list_item.dart`
- `lib/presentation/widgets/empty_state_widget.dart`
- `assets/images/empty_state.png` (ilustrasi empty state)

## Output yang Diharapkan
- Dashboard menampilkan data real-time dari provider
- Warna sesuai: hijau (+), merah (-)
- Empty state dengan gambar ilustrasi saat belum ada data
- Semua widget menggunakan `AppTextStyles` dan `AppColors` dari folder theme

## Dependencies
v0.1 (foundation)

## Acceptance Criteria
- [ ] Saldo muncul dan sesuai dengan warna benar (hijau/merah)
- [ ] Ringkasan harian dengan warna berbeda (pemasukan hijau, pengeluaran merah)
- [ ] Transaksi terbaru maksimal 5 item
- [ ] Empty state muncul dengan gambar ilustrasi jika 0 transaksi
- [ ] Semua widget menggunakan `AppColors` dan `AppTextStyles` dari folder theme
- [ ] `flutter analyze` tanpa error baru

## Estimasi
60 menit
