import 'package:flutter/foundation.dart';
import '../../domain/entities/transaksi.dart';
import '../../domain/repositories/transaksi_repository.dart';
import '../../data/repositories/transaksi_repository_impl.dart';

class TransaksiProvider extends ChangeNotifier {
  final TransaksiRepository _repository;

  List<Transaksi> _list = [];
  bool _isLoading = false;
  String? _error;
  int _saldo = 0;
  Map<String, int> _ringkasanHarian = {'pemasukan': 0, 'pengeluaran': 0};

  TransaksiProvider({TransaksiRepository? repository})
      : _repository = repository ?? TransaksiRepositoryImpl();

  List<Transaksi> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get saldo => _saldo;
  Map<String, int> get ringkasanHarian => _ringkasanHarian;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _repository.getAll();
      _saldo = await _repository.getSaldo();
      _ringkasanHarian = await _repository.getRingkasanHarian(DateTime.now());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadByMonth(int year, int month) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _repository.getByMonth(year, month);
      _saldo = await _repository.getSaldo();
      _ringkasanHarian = await _repository.getRingkasanHarian(DateTime.now());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTerbaru({int limit = 5}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _repository.getTerbaru(limit);
      _saldo = await _repository.getSaldo();
      _ringkasanHarian = await _repository.getRingkasanHarian(DateTime.now());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Transaksi transaksi) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.insert(transaksi);
      await _refreshData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(Transaksi transaksi) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.update(transaksi);
      await _refreshData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCatatan(int id, String catatan) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final transaksi = await _repository.getById(id);
      if (transaksi != null) {
        await _repository.update(transaksi.copyWith(catatan: catatan));
        await _refreshData();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.delete(id);
      await _refreshData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshData() async {
    _list = await _repository.getAll();
    _saldo = await _repository.getSaldo();
    _ringkasanHarian = await _repository.getRingkasanHarian(DateTime.now());
  }
}
