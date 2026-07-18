import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uangku/data/datasources/local/database_helper.dart';
import 'package:uangku/data/repositories/notifikasi_repository_impl.dart';
import 'package:uangku/domain/entities/notifikasi.dart';

void main() {
  late NotifikasiRepositoryImpl repository;
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
    repository = NotifikasiRepositoryImpl();
  });

  tearDown(() async {
    await db.close();
    DatabaseHelper.resetInstance();
  });

  group('Notifikasi Repository', () {
    test('insert - should insert notifikasi and return id', () async {
      final notif = Notifikasi(
        judul: 'Test Judul',
        pesan: 'Test Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      );

      final id = await repository.insert(notif);
      expect(id, greaterThan(0));
    });

    test('getAll - should return all notifikasi', () async {
      await repository.insert(Notifikasi(
        judul: 'Notif 1',
        pesan: 'Pesan 1',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await repository.insert(Notifikasi(
        judul: 'Notif 2',
        pesan: 'Pesan 2',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        createdAt: DateTime(2026, 7, 17),
      ));

      final all = await repository.getAll();
      expect(all.length, 2);
      expect(all.first.judul, 'Notif 1');
    });

    test('getById - should return notifikasi by id', () async {
      final id = await repository.insert(Notifikasi(
        judul: 'Test Judul',
        pesan: 'Test Pesan',
        tipe: 'bulanan',
        jumlahPengeluaran: 6000000,
        batas: 5000000,
        createdAt: DateTime(2026, 7, 18),
      ));

      final result = await repository.getById(id);
      expect(result, isNotNull);
      expect(result!.judul, 'Test Judul');
      expect(result.jumlahPengeluaran, 6000000);
    });

    test('getBelumDibaca - should return unread notifikasi', () async {
      await repository.insert(Notifikasi(
        judul: 'Unread',
        pesan: 'Belum dibaca',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await repository.insert(Notifikasi(
        judul: 'Read',
        pesan: 'Sudah dibaca',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        isRead: true,
        createdAt: DateTime(2026, 7, 17),
      ));

      final belumDibaca = await repository.getBelumDibaca();
      expect(belumDibaca.length, 1);
      expect(belumDibaca.first.judul, 'Unread');
    });

    test('getJumlahBelumDibaca - should return count of unread', () async {
      await repository.insert(Notifikasi(
        judul: 'Unread 1',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await repository.insert(Notifikasi(
        judul: 'Unread 2',
        pesan: 'Pesan',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        createdAt: DateTime(2026, 7, 17),
      ));
      await repository.insert(Notifikasi(
        judul: 'Read',
        pesan: 'Sudah dibaca',
        tipe: 'bulanan',
        jumlahPengeluaran: 6000000,
        batas: 5000000,
        isRead: true,
        createdAt: DateTime(2026, 7, 16),
      ));

      final count = await repository.getJumlahBelumDibaca();
      expect(count, 2);
    });

    test('tandaiSudahDibaca - should mark notifikasi as read', () async {
      final id = await repository.insert(Notifikasi(
        judul: 'Test',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));

      await repository.tandaiSudahDibaca(id);
      final result = await repository.getById(id);
      expect(result!.isRead, true);
    });

    test('tandaiSemuaSudahDibaca - should mark all as read', () async {
      await repository.insert(Notifikasi(
        judul: 'Notif 1',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await repository.insert(Notifikasi(
        judul: 'Notif 2',
        pesan: 'Pesan',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        createdAt: DateTime(2026, 7, 17),
      ));

      await repository.tandaiSemuaSudahDibaca();

      final belumDibaca = await repository.getBelumDibaca();
      expect(belumDibaca.length, 0);
    });

    test('delete - should delete notifikasi', () async {
      final id = await repository.insert(Notifikasi(
        judul: 'Test',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));

      final deleted = await repository.delete(id);
      expect(deleted, 1);

      final result = await repository.getById(id);
      expect(result, isNull);
    });

    test('deleteSemua - should delete all notifikasi', () async {
      await repository.insert(Notifikasi(
        judul: 'Notif 1',
        pesan: 'Pesan',
        tipe: 'harian',
        jumlahPengeluaran: 250000,
        batas: 200000,
        createdAt: DateTime(2026, 7, 18),
      ));
      await repository.insert(Notifikasi(
        judul: 'Notif 2',
        pesan: 'Pesan',
        tipe: 'mingguan',
        jumlahPengeluaran: 2000000,
        batas: 1500000,
        createdAt: DateTime(2026, 7, 17),
      ));

      await repository.deleteSemua();

      final all = await repository.getAll();
      expect(all.length, 0);
    });
  });
}
