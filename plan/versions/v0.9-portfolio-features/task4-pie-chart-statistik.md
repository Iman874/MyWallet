# Task 4 - Pie Chart Kategori di Statistik

## Judul
Tambah PieKategoriWidget & integrasi ke StatistikScreen

## Deskripsi
Visualisasi komposisi pengeluaran per kategori menggunakan fl_chart PieChart,
dengan legend dan total di tengah.

## Tujuan Teknis
- Memperkaya Statistik dengan breakdown kategori yang mudah dipahami.

## Scope
- Buat `lib/presentation/widgets/pie_kategori_widget.dart`.
- Update `lib/presentation/screens/statistik_screen.dart` (sisip setelah _buildChart).
- Warna dari `kategori.warna`, agregasi pengeluaran per kategori (filter bulan).

## Langkah Implementasi
1. Buat widget PieChart dari fl_chart.
2. Hitung total pengeluaran per kategori dari list ter-filter.
3. Render section + legend (nama + persen + jumlah).
4. Center text: total pengeluaran bulan terpilih.
5. Empty state kalau tidak ada pengeluaran.

## Output yang Diharapkan
- Pie chart muncul di Statistik saat ada pengeluaran.

## Dependencies
- Task 1 (fl_chart).

## Acceptance Criteria
- Pie chart tampil dengan proporsi benar.
- Legend menampilkan kategori & persentase.
- Total di tengah sesuai.
- Empty state saat data kosong.

## Estimasi
2 jam
