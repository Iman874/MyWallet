import '../entities/notifikasi.dart';

abstract class NotifikasiRepository {
  Future<List<Notifikasi>> getAll();
  Future<List<Notifikasi>> getBelumDibaca();
  Future<int> getJumlahBelumDibaca();
  Future<Notifikasi?> getById(int id);
  Future<int> insert(Notifikasi notifikasi);
  Future<int> tandaiSudahDibaca(int id);
  Future<int> tandaiSemuaSudahDibaca();
  Future<int> delete(int id);
  Future<int> deleteSemua();
}
