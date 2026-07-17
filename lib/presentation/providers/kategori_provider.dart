import 'package:flutter/foundation.dart';
import '../../domain/entities/kategori.dart';
import '../../domain/repositories/kategori_repository.dart';
import '../../data/repositories/kategori_repository_impl.dart';

class KategoriProvider extends ChangeNotifier {
  final KategoriRepository _repository;

  List<Kategori> _list = [];
  bool _isLoading = false;
  String? _error;

  KategoriProvider({KategoriRepository? repository})
      : _repository = repository ?? KategoriRepositoryImpl();

  List<Kategori> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Kategori kategori) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.insert(kategori);
      await loadAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(Kategori kategori) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.update(kategori);
      await loadAll();
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
      await loadAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
