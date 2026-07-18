import 'dart:convert';

import '../entities/kategori.dart';
import '../entities/transaksi.dart';
import '../repositories/kategori_repository.dart';
import '../repositories/transaksi_repository.dart';

class DataExportService {
  final TransaksiRepository transaksiRepository;
  final KategoriRepository kategoriRepository;

  DataExportService({
    required this.transaksiRepository,
    required this.kategoriRepository,
  });

  Future<List<Transaksi>> _getAllTransaksi() => transaksiRepository.getAll();
  Future<List<Kategori>> _getAllKategori() => kategoriRepository.getAll();

  // ---------------- EKSPOR ----------------

  Future<String> exportCsvTransaksi() async {
    final list = await _getAllTransaksi();
    final buffer = StringBuffer();
    buffer.writeln('id,jumlah,tanggal,kategori,catatan,tipe');
    for (final t in list) {
      final catatan = t.catatan?.replaceAll('"', '""') ?? '';
      buffer.writeln(
        '${t.id},${t.jumlah},${t.tanggal.millisecondsSinceEpoch},'
        '"${_csvEscape(t.kategori)}","$catatan",${t.tipe.name}',
      );
    }
    return buffer.toString();
  }

  Future<String> exportCsvKategori() async {
    final list = await _getAllKategori();
    final buffer = StringBuffer();
    buffer.writeln('id,nama,icon,warna,isDefault,tipe');
    for (final k in list) {
      buffer.writeln(
        '${k.id},"${_csvEscape(k.nama)}","${_csvEscape(k.icon)}",'
        '"${_csvEscape(k.warna)}",${k.isDefault ? 1 : 0},"${_csvEscape(k.tipe)}"',
      );
    }
    return buffer.toString();
  }

  Future<String> exportJson() async {
    final transaksi = await _getAllTransaksi();
    final kategori = await _getAllKategori();
    final payload = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'transaksi': transaksi.map((t) => t.toMap()).toList(),
      'kategori': kategori.map((k) => k.toMap()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  // ---------------- IMPOR ----------------

  /// Impor dari JSON backup lengkap (transaksi + kategori).
  /// Mengembalikan ringkasan jumlah baris sukses/gagal.
  Future<ImportResult> importJson(String content) async {
    late final Map<String, dynamic> data;
    try {
      data = jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      return ImportResult(
        transaksiSukses: 0,
        kategoriSukses: 0,
        gagal: 1,
        error: 'Format JSON tidak valid: $e',
      );
    }

    int transaksiSukses = 0;
    int kategoriSukses = 0;
    int gagal = 0;

    final kategoriRaw = data['kategori'];
    if (kategoriRaw is List) {
      for (final item in kategoriRaw) {
        try {
          final k = Kategori.fromMap(_asMap(item));
          await _upsertKategori(k);
          kategoriSukses++;
        } catch (e) {
          gagal++;
        }
      }
    }

    final transaksiRaw = data['transaksi'];
    if (transaksiRaw is List) {
      for (final item in transaksiRaw) {
        try {
          final t = Transaksi.fromMap(_asMap(item));
          _validateTransaksi(t);
          await _upsertTransaksi(t);
          transaksiSukses++;
        } catch (e) {
          gagal++;
        }
      }
    }

    return ImportResult(
      transaksiSukses: transaksiSukses,
      kategoriSukses: kategoriSukses,
      gagal: gagal,
    );
  }

  /// Impor dari CSV transaksi.
  Future<ImportResult> importCsvTransaksi(String content) async {
    int sukses = 0;
    int gagal = 0;
    final lines = content.split(RegExp(r'\r\n|\n'));
    if (lines.isEmpty) return ImportResult(transaksiSukses: 0, kategoriSukses: 0, gagal: 1, error: 'File kosong');

    final header = _splitCsv(lines.first);
    final idx = _headerIndex(header);
    if (idx.id == null || idx.jumlah == null || idx.tanggal == null || idx.kategori == null || idx.tipe == null) {
      return ImportResult(transaksiSukses: 0, kategoriSukses: 0, gagal: 1, error: 'Header CSV transaksi tidak lengkap');
    }

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      try {
        final cols = _splitCsv(line);
        final t = Transaksi(
          id: int.tryParse(cols[idx.id!]),
          jumlah: int.parse(cols[idx.jumlah!]),
          tanggal: DateTime.fromMillisecondsSinceEpoch(int.parse(cols[idx.tanggal!])),
          kategori: cols[idx.kategori!],
          catatan: cols[idx.catatan!].isEmpty ? null : cols[idx.catatan!],
          tipe: TransaksiType.values.firstWhere((e) => e.name == cols[idx.tipe!]),
        );
        _validateTransaksi(t);
        await _upsertTransaksi(t);
        sukses++;
      } catch (e) {
        gagal++;
      }
    }
    return ImportResult(transaksiSukses: sukses, kategoriSukses: 0, gagal: gagal);
  }

  /// Impor dari CSV kategori.
  Future<ImportResult> importCsvKategori(String content) async {
    int sukses = 0;
    int gagal = 0;
    final lines = content.split(RegExp(r'\r\n|\n'));
    if (lines.isEmpty) return ImportResult(transaksiSukses: 0, kategoriSukses: 0, gagal: 1, error: 'File kosong');

    final header = _splitCsv(lines.first);
    final idx = _headerIndexKategori(header);
    if (idx.id == null || idx.nama == null || idx.icon == null || idx.warna == null || idx.tipe == null) {
      return ImportResult(transaksiSukses: 0, kategoriSukses: 0, gagal: 1, error: 'Header CSV kategori tidak lengkap');
    }

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      try {
        final cols = _splitCsv(line);
        final k = Kategori(
          id: int.tryParse(cols[idx.id!]),
          nama: cols[idx.nama!],
          icon: cols[idx.icon!],
          warna: cols[idx.warna!],
          isDefault: cols[idx.isDefault!] == '1',
          tipe: cols[idx.tipe!],
        );
        await _upsertKategori(k);
        sukses++;
      } catch (e) {
        gagal++;
      }
    }
    return ImportResult(transaksiSukses: 0, kategoriSukses: sukses, gagal: gagal);
  }

  // ---------------- HELPER ----------------

  Future<void> _upsertTransaksi(Transaksi t) async {
    if (t.id != null && await transaksiRepository.getById(t.id!) != null) {
      await transaksiRepository.update(t);
    } else {
      await transaksiRepository.insert(t.copyWith(id: null));
    }
  }

  Future<void> _upsertKategori(Kategori k) async {
    if (k.id != null && await kategoriRepository.getById(k.id!) != null) {
      await kategoriRepository.update(k);
    } else {
      await kategoriRepository.insert(k.copyWith(id: null));
    }
  }

  void _validateTransaksi(Transaksi t) {
    if (t.jumlah <= 0) throw Exception('Jumlah harus > 0');
    if (t.tipe != TransaksiType.pemasukan && t.tipe != TransaksiType.pengeluaran) {
      throw Exception('Tipe tidak valid');
    }
  }

  String _csvEscape(String value) => value.replaceAll('"', '""');

  Map<String, dynamic> _asMap(dynamic item) {
    if (item is Map<String, dynamic>) return item;
    if (item is Map) return item.map((k, v) => MapEntry(k.toString(), v));
    throw Exception('Item bukan map');
  }

  List<String> _splitCsv(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final c = line[i];
      if (c == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (c == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(c);
      }
    }
    result.add(buffer.toString());
    return result;
  }

  _CsvHeaderIndex _headerIndex(List<String> header) {
    int? id, jumlah, tanggal, kategori, catatan, tipe;
    for (int i = 0; i < header.length; i++) {
      switch (header[i].trim().toLowerCase()) {
        case 'id':
          id = i;
        case 'jumlah':
          jumlah = i;
        case 'tanggal':
          tanggal = i;
        case 'kategori':
          kategori = i;
        case 'catatan':
          catatan = i;
        case 'tipe':
          tipe = i;
      }
    }
    return _CsvHeaderIndex(id, jumlah, tanggal, kategori, catatan, tipe);
  }

  _CsvHeaderIndexKategori _headerIndexKategori(List<String> header) {
    int? id, nama, icon, warna, isDefault, tipe;
    for (int i = 0; i < header.length; i++) {
      switch (header[i].trim().toLowerCase()) {
        case 'id':
          id = i;
        case 'nama':
          nama = i;
        case 'icon':
          icon = i;
        case 'warna':
          warna = i;
        case 'isdefault':
          isDefault = i;
        case 'tipe':
          tipe = i;
      }
    }
    return _CsvHeaderIndexKategori(id, nama, icon, warna, isDefault, tipe);
  }
}

class _CsvHeaderIndex {
  final int? id, jumlah, tanggal, kategori, catatan, tipe;
  _CsvHeaderIndex(this.id, this.jumlah, this.tanggal, this.kategori, this.catatan, this.tipe);
}

class _CsvHeaderIndexKategori {
  final int? id, nama, icon, warna, isDefault, tipe;
  _CsvHeaderIndexKategori(this.id, this.nama, this.icon, this.warna, this.isDefault, this.tipe);
}

class ImportResult {
  final int transaksiSukses;
  final int kategoriSukses;
  final int gagal;
  final String? error;

  const ImportResult({
    required this.transaksiSukses,
    required this.kategoriSukses,
    required this.gagal,
    this.error,
  });

  bool get hasError => error != null;

  @override
  String toString() {
    return 'ImportResult(transaksi: $transaksiSukses, kategori: $kategoriSukses, gagal: $gagal)';
  }
}
