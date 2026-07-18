import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/domain/entities/kategori.dart';
import 'package:uangku/domain/entities/transaksi.dart';
import 'package:uangku/domain/repositories/kategori_repository.dart';
import 'package:uangku/domain/repositories/transaksi_repository.dart';
import 'package:uangku/domain/services/data_export_service.dart';

class FakeTransaksiRepo implements TransaksiRepository {
  final Map<int, Transaksi> store = {};
  int _seq = 1;

  @override
  Future<int> insert(Transaksi t) async {
    final id = t.id ?? _seq++;
    store[id] = t.copyWith(id: id);
    return id;
  }

  @override
  Future<int> update(Transaksi t) async {
    store[t.id!] = t;
    return 1;
  }

  @override
  Future<Transaksi?> getById(int id) async => store[id];

  @override
  Future<List<Transaksi>> getAll() async => store.values.toList();

  @override
  Future<int> delete(int id) async => store.remove(id) != null ? 1 : 0;

  @override
  Future<List<Transaksi>> getByMonth(int year, int month) async => [];

  @override
  Future<List<Transaksi>> getTerbaru(int limit) async => [];

  @override
  Future<int> getSaldo() async => 0;

  @override
  Future<Map<String, int>> getRingkasanHarian(DateTime tanggal) async => {};
}

class FakeKategoriRepo implements KategoriRepository {
  final Map<int, Kategori> store = {};
  int _seq = 1;

  @override
  Future<int> insert(Kategori k) async {
    final id = k.id ?? _seq++;
    store[id] = k.copyWith(id: id);
    return id;
  }

  @override
  Future<int> update(Kategori k) async {
    store[k.id!] = k;
    return 1;
  }

  @override
  Future<Kategori?> getById(int id) async => store[id];

  @override
  Future<List<Kategori>> getAll() async => store.values.toList();

  @override
  Future<List<Kategori>> getByTipe(String tipe) async =>
      store.values.where((k) => k.tipe == tipe).toList();

  @override
  Future<int> delete(int id) async => store.remove(id) != null ? 1 : 0;
}

void main() {
  late FakeTransaksiRepo transaksiRepo;
  late FakeKategoriRepo kategoriRepo;
  late DataExportService service;

  setUp(() {
    transaksiRepo = FakeTransaksiRepo();
    kategoriRepo = FakeKategoriRepo();
    service = DataExportService(
      transaksiRepository: transaksiRepo,
      kategoriRepository: kategoriRepo,
    );
  });

  Transaksi makeTransaksi(int id, int jumlah, TransaksiType tipe, String kategori) => Transaksi(
        id: id,
        jumlah: jumlah,
        tanggal: DateTime(2026, 7, 18),
        kategori: kategori,
        catatan: 'catatan $id',
        tipe: tipe,
      );

  Kategori makeKategori(int id, String nama) => Kategori(
        id: id,
        nama: nama,
        icon: 'restaurant',
        warna: '#FF0000',
        tipe: 'pengeluaran',
      );

  group('export', () {
    test('exportJson berisi transaksi & kategori', () async {
      await transaksiRepo.insert(makeTransaksi(1, 10000, TransaksiType.pengeluaran, 'Makan'));
      await kategoriRepo.insert(makeKategori(1, 'Makan'));

      final json = await service.exportJson();
      expect(json, contains('"transaksi"'));
      expect(json, contains('"kategori"'));
      expect(json, contains('Makan'));
    });

    test('exportCsvTransaksi punya header & baris', () async {
      await transaksiRepo.insert(makeTransaksi(1, 10000, TransaksiType.pengeluaran, 'Makan'));
      final csv = await service.exportCsvTransaksi();
      expect(csv.startsWith('id,jumlah,tanggal,kategori,catatan,tipe'), isTrue);
      expect(csv, contains('Makan'));
    });
  });

  group('import', () {
    test('importJson roundtrip tidak duplikat', () async {
      await transaksiRepo.insert(makeTransaksi(1, 10000, TransaksiType.pengeluaran, 'Makan'));
      await kategoriRepo.insert(makeKategori(1, 'Makan'));

      final json = await service.exportJson();
      final result = await service.importJson(json);

      expect(result.transaksiSukses, 1);
      expect(result.kategoriSukses, 1);
      expect(result.gagal, 0);
      // tidak duplikat: tetap 1 karena upsert by id
      expect((await transaksiRepo.getAll()).length, 1);
      expect((await kategoriRepo.getAll()).length, 1);
    });

    test('importJson dengan id baru menambah data', () async {
      final payload = {
        'transaksi': [
          {'id': 99, 'jumlah': 5000, 'tanggal': 1750000000000, 'kategori': 'Lainnya', 'catatan': null, 'tipe': 'pengeluaran'}
        ],
        'kategori': [
          {'id': 99, 'nama': 'Lainnya', 'icon': 'more', 'warna': '#00FF00', 'isDefault': 0, 'tipe': 'pengeluaran'}
        ]
      };
      final result = await service.importJson(
        const JsonEncoder().convert(payload),
      );
      expect(result.transaksiSukses, 1);
      expect(result.kategoriSukses, 1);
      expect((await transaksiRepo.getAll()).length, 1);
    });

    test('importJson menolak format rusak', () async {
      final result = await service.importJson('bukan json{');
      expect(result.hasError, isTrue);
    });

    test('importCsvTransaksi memvalidasi jumlah > 0', () async {
      const csv = 'id,jumlah,tanggal,kategori,catatan,tipe\n'
          '1,10000,1750000000000,Makan,,pengeluaran\n'
          '2,0,1750000000000,Makan,,pengeluaran';
      final result = await service.importCsvTransaksi(csv);
      expect(result.transaksiSukses, 1);
      expect(result.gagal, 1);
    });
  });
}
