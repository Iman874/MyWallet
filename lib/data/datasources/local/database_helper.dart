import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('uangku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> setDatabase(Database db) async {
    _database = db;
  }

  static void resetInstance() {
    _database = null;
  }

  Future _createDB(Database db, int version) async {
    // Tabel transaksi
    await db.execute('''
      CREATE TABLE transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jumlah INTEGER NOT NULL,
        tanggal INTEGER NOT NULL,
        kategori TEXT NOT NULL,
        catatan TEXT,
        tipe TEXT NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_tanggal ON transaksi (tanggal)',
    );

    // Tabel kategori
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        icon TEXT NOT NULL,
        warna TEXT NOT NULL,
        isDefault INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert kategori default
    await _insertDefaultKategori(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE kategori (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT NOT NULL,
          icon TEXT NOT NULL,
          warna TEXT NOT NULL,
          isDefault INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await _insertDefaultKategori(db);
    }
  }

  Future _insertDefaultKategori(Database db) async {
    final defaultKategori = [
      {'nama': 'Gaji', 'icon': 'attach_money', 'warna': '#22C55E', 'isDefault': 1},
      {'nama': 'Makan', 'icon': 'restaurant', 'warna': '#EF4444', 'isDefault': 1},
      {'nama': 'Transportasi', 'icon': 'directions_car', 'warna': '#4F8CFF', 'isDefault': 1},
      {'nama': 'Hiburan', 'icon': 'sports_esports', 'warna': '#A855F7', 'isDefault': 1},
      {'nama': 'Lainnya', 'icon': 'category', 'warna': '#6B7280', 'isDefault': 1},
    ];

    for (final kategori in defaultKategori) {
      await db.insert('kategori', kategori);
    }
  }

  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    final db = await instance.database;
    return await db.rawInsert(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    final db = await instance.database;
    return await db.rawQuery(sql, arguments);
  }

  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    final db = await instance.database;
    return await db.rawUpdate(sql, arguments);
  }

  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    final db = await instance.database;
    return await db.rawDelete(sql, arguments);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}
