import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/repositories/kategori_repository_impl.dart';
import '../../data/repositories/transaksi_repository_impl.dart';
import '../../domain/services/data_export_service.dart';

class ExportImportProvider extends ChangeNotifier {
  final DataExportService _service;

  bool _isBusy = false;
  String? _message;
  bool _isError = false;

  ExportImportProvider({DataExportService? service})
      : _service = service ??
            DataExportService(
              transaksiRepository: TransaksiRepositoryImpl(),
              kategoriRepository: KategoriRepositoryImpl(),
            );

  bool get isBusy => _isBusy;
  String? get message => _message;
  bool get isError => _isError;

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    _isError = false;
    notifyListeners();
  }

  Future<void> exportCsv() async {
    _setBusy(true);
    try {
      final csvT = await _service.exportCsvTransaksi();
      final csvK = await _service.exportCsvKategori();
      final now = _timestamp();
      final pathT = await FilePicker.platform.saveFile(
        dialogTitle: 'Simpan CSV Transaksi',
        fileName: 'uangku_transaksi_$now.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: Uint8List.fromList(csvT.codeUnits),
      );
      if (pathT == null) {
        _message = 'Ekspor dibatalkan';
        _isError = false;
        return;
      }
      final pathK = await FilePicker.platform.saveFile(
        dialogTitle: 'Simpan CSV Kategori',
        fileName: 'uangku_kategori_$now.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: Uint8List.fromList(csvK.codeUnits),
      );
      if (pathK == null) {
        _message = 'Ekspor dibatalkan';
        _isError = false;
        return;
      }
      _message = 'Berhasil ekspor CSV transaksi & kategori';
      _isError = false;
    } catch (e) {
      _message = 'Gagal ekspor CSV: $e';
      _isError = true;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> exportJson() async {
    _setBusy(true);
    try {
      final json = await _service.exportJson();
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Simpan Backup JSON',
        fileName: 'uangku_backup_${_timestamp()}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: Uint8List.fromList(json.codeUnits),
      );
      if (path == null) {
        _message = 'Ekspor dibatalkan';
        _isError = false;
        return;
      }
      _message = 'Berhasil ekspor backup JSON';
      _isError = false;
    } catch (e) {
      _message = 'Gagal ekspor JSON: $e';
      _isError = true;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> importData() async {
    _setBusy(true);
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Pilih file backup (CSV/JSON)',
        type: FileType.custom,
        allowedExtensions: ['csv', 'json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        _message = 'Impor dibatalkan';
        _isError = false;
        return;
      }
      final file = result.files.first;
      final content = String.fromCharCodes(file.bytes!);
      late final ImportResult res;
      if (file.extension == 'json') {
        res = await _service.importJson(content);
      } else if (file.extension == 'csv') {
        final header = content.split(RegExp(r'\r\n|\n')).first.toLowerCase();
        res = header.contains('nama')
            ? await _service.importCsvKategori(content)
            : await _service.importCsvTransaksi(content);
      } else {
        _message = 'Format file tidak didukung';
        _isError = true;
        return;
      }

      if (res.hasError) {
        _message = 'Gagal impor: ${res.error}';
        _isError = true;
      } else {
        _message =
            'Impor selesai: ${res.transaksiSukses} transaksi, ${res.kategoriSukses} kategori'
            '${res.gagal > 0 ? ', ${res.gagal} gagal' : ''}';
        _isError = false;
      }
    } catch (e) {
      _message = 'Gagal impor: $e';
      _isError = true;
    } finally {
      _setBusy(false);
    }
  }

  String _timestamp() {
    final d = DateTime.now();
    return '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
  }
}
