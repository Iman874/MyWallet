import '../../domain/entities/notifikasi.dart';
import '../../domain/repositories/notifikasi_repository.dart';
import '../datasources/local/database_helper.dart';

class NotifikasiRepositoryImpl implements NotifikasiRepository {
  final DatabaseHelper _databaseHelper;

  NotifikasiRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<Notifikasi>> getAll() async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM notifikasi ORDER BY createdAt DESC',
    );
    return maps.map((map) => Notifikasi.fromMap(map)).toList();
  }

  @override
  Future<List<Notifikasi>> getBelumDibaca() async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM notifikasi WHERE isRead = 0 ORDER BY createdAt DESC',
    );
    return maps.map((map) => Notifikasi.fromMap(map)).toList();
  }

  @override
  Future<int> getJumlahBelumDibaca() async {
    final result = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM notifikasi WHERE isRead = 0',
    );
    return result.first['count'] as int;
  }

  @override
  Future<Notifikasi?> getById(int id) async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM notifikasi WHERE id = ?',
      [id],
    );
    if (maps.isEmpty) return null;
    return Notifikasi.fromMap(maps.first);
  }

  @override
  Future<int> insert(Notifikasi notifikasi) async {
    final map = notifikasi.toMap();
    map.remove('id');
    return await _databaseHelper.rawInsert(
      'INSERT INTO notifikasi (judul, pesan, tipe, jumlah_pengeluaran, batas, isRead, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [map['judul'], map['pesan'], map['tipe'], map['jumlah_pengeluaran'], map['batas'], map['isRead'], map['createdAt']],
    );
  }

  @override
  Future<int> tandaiSudahDibaca(int id) async {
    return await _databaseHelper.rawUpdate(
      'UPDATE notifikasi SET isRead = 1 WHERE id = ?',
      [id],
    );
  }

  @override
  Future<int> tandaiSemuaSudahDibaca() async {
    return await _databaseHelper.rawUpdate(
      'UPDATE notifikasi SET isRead = 1 WHERE isRead = 0',
    );
  }

  @override
  Future<int> delete(int id) async {
    return await _databaseHelper.rawDelete(
      'DELETE FROM notifikasi WHERE id = ?',
      [id],
    );
  }

  @override
  Future<int> deleteSemua() async {
    return await _databaseHelper.rawDelete(
      'DELETE FROM notifikasi',
    );
  }
}
