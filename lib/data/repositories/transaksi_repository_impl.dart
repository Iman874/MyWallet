import '../../domain/entities/transaksi.dart';
import '../../domain/repositories/transaksi_repository.dart';
import '../datasources/local/database_helper.dart';

class TransaksiRepositoryImpl implements TransaksiRepository {
  final DatabaseHelper _databaseHelper;

  TransaksiRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<int> insert(Transaksi transaksi) async {
    final map = transaksi.toMap();
    map.remove('id');
    final id = await _databaseHelper.rawInsert(
      'INSERT INTO transaksi (jumlah, tanggal, kategori, catatan, tipe) VALUES (?, ?, ?, ?, ?)',
      [
        map['jumlah'],
        map['tanggal'],
        map['kategori'],
        map['catatan'],
        map['tipe'],
      ],
    );
    return id;
  }

  @override
  Future<List<Transaksi>> getAll() async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM transaksi ORDER BY tanggal DESC',
    );
    return maps.map((map) => Transaksi.fromMap(map)).toList();
  }

  @override
  Future<Transaksi?> getById(int id) async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM transaksi WHERE id = ?',
      [id],
    );
    if (maps.isEmpty) return null;
    return Transaksi.fromMap(maps.first);
  }

  @override
  Future<List<Transaksi>> getByMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM transaksi WHERE tanggal >= ? AND tanggal <= ? ORDER BY tanggal DESC',
      [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );
    return maps.map((map) => Transaksi.fromMap(map)).toList();
  }

  @override
  Future<List<Transaksi>> getTerbaru(int limit) async {
    final maps = await _databaseHelper.rawQuery(
      'SELECT * FROM transaksi ORDER BY tanggal DESC LIMIT ?',
      [limit],
    );
    return maps.map((map) => Transaksi.fromMap(map)).toList();
  }

  @override
  Future<int> update(Transaksi transaksi) async {
    final map = transaksi.toMap();
    return await _databaseHelper.rawUpdate(
      'UPDATE transaksi SET jumlah = ?, tanggal = ?, kategori = ?, catatan = ?, tipe = ? WHERE id = ?',
      [
        map['jumlah'],
        map['tanggal'],
        map['kategori'],
        map['catatan'],
        map['tipe'],
        map['id'],
      ],
    );
  }

  @override
  Future<int> delete(int id) async {
    return await _databaseHelper.rawDelete(
      'DELETE FROM transaksi WHERE id = ?',
      [id],
    );
  }

  @override
  Future<int> getSaldo() async {
    final result = await _databaseHelper.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN jumlah ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN jumlah ELSE 0 END), 0) as saldo
      FROM transaksi
    ''');
    return (result.first['saldo'] as int?) ?? 0;
  }

  @override
  Future<Map<String, int>> getRingkasanHarian(DateTime tanggal) async {
    final startOfDay = DateTime(tanggal.year, tanggal.month, tanggal.day);
    final endOfDay = DateTime(tanggal.year, tanggal.month, tanggal.day, 23, 59, 59);

    final result = await _databaseHelper.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN jumlah ELSE 0 END), 0) as pemasukan,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN jumlah ELSE 0 END), 0) as pengeluaran
      FROM transaksi
      WHERE tanggal >= ? AND tanggal <= ?
    ''', [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch]);

    return {
      'pemasukan': (result.first['pemasukan'] as int?) ?? 0,
      'pengeluaran': (result.first['pengeluaran'] as int?) ?? 0,
    };
  }
}
