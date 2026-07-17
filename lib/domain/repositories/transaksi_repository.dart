import '../entities/transaksi.dart';

abstract class TransaksiRepository {
  Future<int> insert(Transaksi transaksi);
  Future<List<Transaksi>> getAll();
  Future<Transaksi?> getById(int id);
  Future<List<Transaksi>> getByMonth(int year, int month);
  Future<List<Transaksi>> getTerbaru(int limit);
  Future<int> update(Transaksi transaksi);
  Future<int> delete(int id);
  Future<int> getSaldo();
  Future<Map<String, int>> getRingkasanHarian(DateTime tanggal);
}
