import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uangku/data/datasources/local/database_helper.dart';
import 'package:uangku/domain/entities/notifikasi.dart';
import 'package:uangku/presentation/providers/notifikasi_provider.dart';

void main() {
  late NotifikasiProvider provider;
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    DatabaseHelper.resetInstance();
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
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
        },
      ),
    );
    await DatabaseHelper.instance.setDatabase(db);
    provider = NotifikasiProvider();
  });

  tearDown(() async {
    await db.close();
    DatabaseHelper.resetInstance();
  });

  group('Notifikasi Provider', () {
    test('initial state - should have empty list', () {
      expect(provider.list, isEmpty);
      expect(provider.jumlahBelumDibaca, 0);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('tambah - should add notifikasi and update list', () async {
      await provider.tambah(Notifikasi(
        judul: 'Test Judul',
        pesan: 'Test Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));

      expect(provider.list.length, 1);
      expect(provider.jumlahBelumDibaca, 1);
    });

    test('loadAll - should load all notifikasi', () async {
      await provider.tambah(Notifikasi(
        judul: 'Notif 1',
        pesan: 'Pesan 1',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await provider.tambah(Notifikasi(
        judul: 'Notif 2',
        pesan: 'Pesan 2',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        createdAt: DateTime(2026, 7, 17),
      ));

      await provider.loadAll();

      expect(provider.list.length, 2);
      expect(provider.list.first.judul, 'Notif 1');
    });

    test('tandaiDibaca - should mark notifikasi as read', () async {
      await provider.tambah(Notifikasi(
        judul: 'Test',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));

      final id = provider.list.first.id;
      await provider.tandaiDibaca(id!);

      expect(provider.jumlahBelumDibaca, 0);
    });

    test('tandaiSemuaDibaca - should mark all as read', () async {
      await provider.tambah(Notifikasi(
        judul: 'Notif 1',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await provider.tambah(Notifikasi(
        judul: 'Notif 2',
        pesan: 'Pesan',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        createdAt: DateTime(2026, 7, 17),
      ));

      await provider.tandaiSemuaDibaca();

      expect(provider.jumlahBelumDibaca, 0);
    });

    test('hapus - should delete notifikasi', () async {
      await provider.tambah(Notifikasi(
        judul: 'Test',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));

      final id = provider.list.first.id;
      await provider.hapus(id!);

      expect(provider.list, isEmpty);
      expect(provider.jumlahBelumDibaca, 0);
    });
  });
}
