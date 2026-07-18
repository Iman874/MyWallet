import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uangku/data/datasources/local/database_helper.dart';
import 'package:uangku/domain/entities/transaksi.dart';
import 'package:uangku/presentation/providers/transaksi_provider.dart';

void main() {
  late TransaksiProvider provider;
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
    provider = TransaksiProvider();
  });

  tearDown(() async {
    await db.close();
    DatabaseHelper.resetInstance();
  });

  group('Transaksi Provider', () {
    test('initial state - should have empty list and zero saldo', () {
      expect(provider.list, isEmpty);
      expect(provider.saldo, 0);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('add - should add transaksi and update list', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );

      await provider.add(transaksi);
      await provider.loadAll();

      expect(provider.list.length, 1);
      expect(provider.saldo, 50000);
    });

    test('loadAll - should load all transaksi', () async {
      await provider.add(Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));
      await provider.add(Transaksi(
        jumlah: 20000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      ));

      await provider.loadAll();

      expect(provider.list.length, 2);
      expect(provider.saldo, 30000);
    });

    test('loadByMonth - should load transaksi for specific month', () async {
      await provider.add(Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));
      await provider.add(Transaksi(
        jumlah: 20000,
        tanggal: DateTime(2026, 8, 10),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      ));

      await provider.loadByMonth(2026, 7);

      expect(provider.list.length, 1);
      expect(provider.list.first.kategori, 'Gaji');
    });

    test('update - should update transaksi', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );

      await provider.add(transaksi);
      final id = provider.list.first.id;

      await provider.update(
        transaksi.copyWith(id: id, catatan: 'Updated'),
      );
      await provider.loadAll();

      expect(provider.list.first.catatan, 'Updated');
    });

    test('updateCatatan - should update catatan only', () async {
      final transaksi = Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      );

      await provider.add(transaksi);
      final id = provider.list.first.id;

      await provider.updateCatatan(id!, 'New Note');
      await provider.loadAll();

      expect(provider.list.first.catatan, 'New Note');
      expect(provider.list.first.jumlah, 50000);
    });

    test('delete - should delete transaksi', () async {
      await provider.add(Transaksi(
        jumlah: 50000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));

      final id = provider.list.first.id;
      await provider.delete(id!);
      await provider.loadAll();

      expect(provider.list, isEmpty);
      expect(provider.saldo, 0);
    });

    test('saldo - should update after add and delete', () async {
      await provider.add(Transaksi(
        jumlah: 100000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));
      await provider.loadAll();
      expect(provider.saldo, 100000);

      await provider.add(Transaksi(
        jumlah: 30000,
        tanggal: DateTime(2026, 7, 17),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      ));
      await provider.loadAll();
      expect(provider.saldo, 70000);

      final pengeluaran = provider.list.firstWhere(
        (t) => t.tipe == TransaksiType.pengeluaran,
      );
      await provider.delete(pengeluaran.id!);
      await provider.loadAll();
      expect(provider.saldo, 100000);
    });

    test('ringkasanHarian - should return daily summary', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      await provider.add(Transaksi(
        jumlah: 100000,
        tanggal: today.add(const Duration(hours: 10)),
        kategori: 'Gaji',
        tipe: TransaksiType.pemasukan,
      ));
      await provider.add(Transaksi(
        jumlah: 30000,
        tanggal: today.add(const Duration(hours: 12)),
        kategori: 'Makan',
        tipe: TransaksiType.pengeluaran,
      ));

      await provider.loadAll();

      expect(provider.ringkasanHarian['pemasukan'], 100000);
      expect(provider.ringkasanHarian['pengeluaran'], 30000);
    });
  });
}
