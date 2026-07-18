import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

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
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await databaseFactory.openDatabase(
        filePath,
        options: OpenDatabaseOptions(
          version: 5,
          onCreate: _createDB,
          onUpgrade: _onUpgrade,
        ),
      );
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      return await openDatabase(
        path,
        version: 5,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    }
  }

  Future<void> setDatabase(Database db) async {
    _database = db;
  }

  static void resetInstance() {
    _database = null;
  }

  Future _createDB(Database db, int version) async {
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

    await db.execute('CREATE INDEX idx_tanggal ON transaksi (tanggal)');

    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        icon TEXT NOT NULL,
        warna TEXT NOT NULL,
        isDefault INTEGER NOT NULL DEFAULT 0,
        tipe TEXT NOT NULL DEFAULT 'pengeluaran'
      )
    ''');

    await db.execute('''
      CREATE TABLE notifikasi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        pesan TEXT NOT NULL,
        tipe TEXT NOT NULL,
        jumlah_pengeluaran INTEGER NOT NULL,
        batas INTEGER NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

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
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE kategori ADD COLUMN tipe TEXT NOT NULL DEFAULT 'pengeluaran'");
      await _updateDefaultKategoriTipe(db);
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE notifikasi (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          judul TEXT NOT NULL,
          pesan TEXT NOT NULL,
          tipe TEXT NOT NULL,
          jumlah_pengeluaran INTEGER NOT NULL,
          batas INTEGER NOT NULL,
          isRead INTEGER NOT NULL DEFAULT 0,
          createdAt INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE kategori ADD COLUMN batas INTEGER');
    }
  }

  Future _insertDefaultKategori(Database db) async {
    final defaultKategori = [
      {'nama': 'Gaji', 'icon': 'attach_money', 'warna': '#22C55E', 'isDefault': 1, 'tipe': 'pemasukan'},
      {'nama': 'Makan', 'icon': 'restaurant', 'warna': '#EF4444', 'isDefault': 1, 'tipe': 'pengeluaran'},
      {'nama': 'Transportasi', 'icon': 'directions_car', 'warna': '#4F8CFF', 'isDefault': 1, 'tipe': 'pengeluaran'},
      {'nama': 'Hiburan', 'icon': 'sports_esports', 'warna': '#A855F7', 'isDefault': 1, 'tipe': 'pengeluaran'},
      {'nama': 'Lainnya', 'icon': 'category', 'warna': '#6B7280', 'isDefault': 1, 'tipe': 'pengeluaran'},
    ];

    for (final kategori in defaultKategori) {
      await db.insert('kategori', kategori);
    }
  }

  Future _updateDefaultKategoriTipe(Database db) async {
    await db.rawUpdate("UPDATE kategori SET tipe = 'pemasukan' WHERE nama = 'Gaji'");
    await db.rawUpdate("UPDATE kategori SET tipe = 'pengeluaran' WHERE nama != 'Gaji'");
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

