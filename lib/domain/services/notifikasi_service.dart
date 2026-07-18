import 'package:intl/intl.dart';
import '../../domain/entities/transaksi.dart';
import '../../domain/entities/notifikasi.dart';
import '../../domain/entities/kategori.dart';
import '../../presentation/providers/transaksi_provider.dart';
import '../../presentation/providers/batas_provider.dart';
import '../../presentation/providers/kategori_provider.dart';
import '../../presentation/providers/notifikasi_provider.dart';

class NotifikasiService {
  final TransaksiProvider _transaksiProvider;
  final BatasProvider _batasProvider;
  final KategoriProvider _kategoriProvider;
  final NotifikasiProvider _notifikasiProvider;

  NotifikasiService({
    required TransaksiProvider transaksiProvider,
    required BatasProvider batasProvider,
    required KategoriProvider kategoriProvider,
    required NotifikasiProvider notifikasiProvider,
  })  : _transaksiProvider = transaksiProvider,
        _batasProvider = batasProvider,
        _kategoriProvider = kategoriProvider,
        _notifikasiProvider = notifikasiProvider;

  Future<void> cekDanBuatNotifikasi(Transaksi transaksi) async {
    if (transaksi.tipe != TransaksiType.pengeluaran) return;

    await _cekHarian(transaksi);
    await _cekMingguan(transaksi);
    await _cekBulanan(transaksi);
    await _cekKategori(transaksi);
  }

  Future<void> _cekHarian(Transaksi transaksi) async {
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);

    int totalPengeluaran = 0;
    for (final t in _transaksiProvider.list) {
      if (t.tipe == TransaksiType.pengeluaran) {
        final tglTransaksi = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
        if (tglTransaksi.isAtSameMomentAs(hariIni)) {
          totalPengeluaran += t.jumlah;
        }
      }
    }

    final batas = _batasProvider.batasHarian;
    if (totalPengeluaran >= batas) {
      final formatted = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(totalPengeluaran);
      final formattedBatas = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(batas);

      await _notifikasiProvider.tambah(Notifikasi(
        judul: 'Batas Pemakaian Harian Tercapai',
        pesan: 'Pengeluaran hari ini sudah mencapai $formatted (Batas: $formattedBatas)',
        tipe: 'harian',
        jumlahPengeluaran: totalPengeluaran,
        batas: batas,
        createdAt: DateTime.now(),
      ));
    }
  }

  Future<void> _cekMingguan(Transaksi transaksi) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final mulaiMinggu = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    int totalPengeluaran = 0;
    for (final t in _transaksiProvider.list) {
      if (t.tipe == TransaksiType.pengeluaran) {
        final tglTransaksi = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
        if (!tglTransaksi.isBefore(mulaiMinggu)) {
          totalPengeluaran += t.jumlah;
        }
      }
    }

    final batas = _batasProvider.batasMingguan;
    if (totalPengeluaran >= batas) {
      final formatted = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(totalPengeluaran);
      final formattedBatas = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(batas);

      await _notifikasiProvider.tambah(Notifikasi(
        judul: 'Batas Pemakaian Mingguan Tercapai',
        pesan: 'Pengeluaran minggu ini sudah mencapai $formatted (Batas: $formattedBatas)',
        tipe: 'mingguan',
        jumlahPengeluaran: totalPengeluaran,
        batas: batas,
        createdAt: DateTime.now(),
      ));
    }
  }

  Future<void> _cekBulanan(Transaksi transaksi) async {
    final now = DateTime.now();
    final mulaiBulan = DateTime(now.year, now.month, 1);

    int totalPengeluaran = 0;
    for (final t in _transaksiProvider.list) {
      if (t.tipe == TransaksiType.pengeluaran) {
        final tglTransaksi = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
        if (!tglTransaksi.isBefore(mulaiBulan)) {
          totalPengeluaran += t.jumlah;
        }
      }
    }

    final batas = _batasProvider.batasBulanan;
    if (totalPengeluaran >= batas) {
      final formatted = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(totalPengeluaran);
      final formattedBatas = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(batas);

      await _notifikasiProvider.tambah(Notifikasi(
        judul: 'Batas Pemakaian Bulanan Tercapai',
        pesan: 'Pengeluaran bulan ini sudah mencapai $formatted (Batas: $formattedBatas)',
        tipe: 'bulanan',
        jumlahPengeluaran: totalPengeluaran,
        batas: batas,
        createdAt: DateTime.now(),
      ));
    }
  }

  Future<void> _cekKategori(Transaksi transaksi) async {
    final kategori = _kategoriProvider.list.firstWhere(
      (k) => k.nama == transaksi.kategori,
      orElse: () => Kategori(nama: '', icon: '', warna: ''),
    );
    if (kategori.batas == null || kategori.batas! <= 0) return;

    final now = DateTime.now();
    final mulaiBulan = DateTime(now.year, now.month, 1);

    int totalKategori = 0;
    for (final t in _transaksiProvider.list) {
      if (t.tipe == TransaksiType.pengeluaran && t.kategori == transaksi.kategori) {
        final tgl = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
        if (!tgl.isBefore(mulaiBulan)) {
          totalKategori += t.jumlah;
        }
      }
    }

    if (totalKategori >= kategori.batas!) {
      final formatted = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(totalKategori);
      final formattedBatas = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0).format(kategori.batas!);
      await _notifikasiProvider.tambah(Notifikasi(
        judul: 'Budget Kategori "${kategori.nama}" Tercapai',
        pesan: 'Pengeluaran untuk ${kategori.nama} sudah mencapai $formatted (Batas: $formattedBatas)',
        tipe: 'kategori',
        jumlahPengeluaran: totalKategori,
        batas: kategori.batas!,
        createdAt: DateTime.now(),
      ));
    }
  }
}
