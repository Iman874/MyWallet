import '../../domain/entities/kategori.dart';

abstract class KategoriRepository {
  Future<List<Kategori>> getAll();
  Future<List<Kategori>> getByTipe(String tipe);
  Future<Kategori?> getById(int id);
  Future<int> insert(Kategori kategori);
  Future<int> update(Kategori kategori);
  Future<int> delete(int id);
}
