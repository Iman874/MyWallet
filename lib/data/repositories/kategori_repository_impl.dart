import '../../domain/entities/kategori.dart';
import '../../domain/repositories/kategori_repository.dart';
import '../datasources/local/database_helper.dart';

class KategoriRepositoryImpl implements KategoriRepository {
  final DatabaseHelper _databaseHelper;

  KategoriRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<Kategori>> getAll() async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM kategori ORDER BY isDefault DESC, nama ASC',
    );
    return maps.map((map) => Kategori.fromMap(map)).toList();
  }

  @override
  Future<List<Kategori>> getByTipe(String tipe) async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM kategori WHERE tipe = ? ORDER BY isDefault DESC, nama ASC',
      [tipe],
    );
    return maps.map((map) => Kategori.fromMap(map)).toList();
  }

  @override
  Future<Kategori?> getById(int id) async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM kategori WHERE id = ?',
      [id],
    );
    if (maps.isEmpty) return null;
    return Kategori.fromMap(maps.first);
  }

  @override
  Future<int> insert(Kategori kategori) async {
    final map = kategori.toMap();
    map.remove('id');
    return await _databaseHelper.rawInsert(
      'INSERT INTO kategori (nama, icon, warna, isDefault, tipe) VALUES (?, ?, ?, ?, ?)',
      [map['nama'], map['icon'], map['warna'], map['isDefault'], map['tipe']],
    );
  }

  @override
  Future<int> update(Kategori kategori) async {
    final map = kategori.toMap();
    return await _databaseHelper.rawUpdate(
      'UPDATE kategori SET nama = ?, icon = ?, warna = ?, isDefault = ?, tipe = ? WHERE id = ?',
      [map['nama'], map['icon'], map['warna'], map['isDefault'], map['tipe'], map['id']],
    );
  }

  @override
  Future<int> delete(int id) async {
    return await _databaseHelper.rawDelete(
      'DELETE FROM kategori WHERE id = ? AND isDefault = 0',
      [id],
    );
  }
}
