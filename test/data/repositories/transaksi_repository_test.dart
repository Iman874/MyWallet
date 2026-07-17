import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uangku/data/datasources/local/database_helper.dart';
import 'package:uangku/data/repositories/transaksi_repository_impl.dart';
import 'package:uangku/domain/entities/transaksi.dart';

void main() {
  late TransaksiRepositoryImpl repository;
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
        },
      ),
    );
    await DatabaseHelper.instance.setDatabase(db);
    repository = TransaksiRepositoryImpl();
  });

  tearDown(() async {
    await db.close();
    DatabaseHelper.resetInstance();
  });

  group('Transaksi Repository', () {
    test('insert - should insert transaksi and return id', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        catatan: 'Gaji bulanan',
        tipe: TransaksiType.pemasukan,
      );

      final id = await repository.insert(transaksi);
      expect(id, greaterThan(0));
    });

    test('getAll - should return all transaksi', () async {
      final transaksi1 = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );
      final transaksi2 = Transaksi(
        jumlah: 20000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      );

      await repository.insert(transaksi1);
      await repository.insert(transaksi2);

      final all = await repository.getAll();
      expect(all.length, 2);
    });

    test('getById - should return transaksi by id', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );

      final id = await repository.insert(transaksi);
      final result = await repository.getById(id);

      expect(result, isNotNull);
      expect(result!.jumlah, 50000);
      expect(result.kategori, 'Gaji');
    });

    test('getByMonth - should return transaksi for specific month', () async {
      final transaksi1 = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );
      final transaksi2 = Transaksi(
        jumlah: 20000,
        tanggal: DateTime(2026, 8, 10),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      );

      await repository.insert(transaksi1);
      await repository.insert(transaksi2);

      final july = await repository.getByMonth(2026, 7);
      expect(july.length, 1);
      expect(july.first.kategori, 'Gaji');
    });

    test('getTerbaru - should return latest transaksi with limit', () async {
      for (var i = 0; i < 10; i++) {
        await repository.insert(Transaksi(
          jumlah: 10000 * (i + 1),
          tanggal: DateTime(2026, 7, 17 - i),
          kategori: 'Lainnya',
          tipe: TransaksiType.pemasukan,
        ));
      }

      final terbaru = await repository.getTerbaru(5);
      expect(terbaru.length, 5);
    });

    test('update - should update transaksi', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );

      final id = await repository.insert(transaksi);
      final updated = await repository.update(
        transaksi.copyWith(id: id, catatan: 'Updated'),
      );

      expect(updated, 1);

      final result = await repository.getById(id);
      expect(result!.catatan, 'Updated');
    });

    test('delete - should delete transaksi', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );

      final id = await repository.insert(transaksi);
      final deleted = await repository.delete(id);

      expect(deleted, 1);

      final result = await repository.getById(id);
      expect(result, isNull);
    });

    test('getSaldo - should calculate saldo correctly', () async {
      await repository.insert(Transaksi(
        jumlah: 100000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));
      await repository.insert(Transaksi(
        jumlah: 30000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      ));

      final saldo = await repository.getSaldo();
      expect(saldo, 70000);
    });

    test('getRingkasanHarian - should return daily summary', () async {
      await repository.insert(Transaksi(
        jumlah: 100000,
        tanggal: DateTime(2026, 7, 17, 10, 0),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));
      await repository.insert(Transaksi(
        jumlah: 30000,
        tanggal: DateTime(2026, 7, 17, 12, 0),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      ));
      await repository.insert(Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 18, 10, 0),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));

      final ringkasan = await repository.getRingkasanHarian(DateTime(2026, 7, 17));
      expect(ringkasan['pemasukan'], 100000);
      expect(ringkasan['pengeluaran'], 30000);
    });
  });
}
