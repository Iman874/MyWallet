import 'package:flutter/foundation.dart';
import '../../domain/entities/notifikasi.dart';
import '../../domain/repositories/notifikasi_repository.dart';
import '../../data/repositories/notifikasi_repository_impl.dart';

class NotifikasiProvider extends ChangeNotifier {
  final NotifikasiRepository _repository;

  List<Notifikasi> _list = [];
  List<Notifikasi> _belumDibaca = [];
  int _jumlahBelumDibaca = 0;
  bool _isLoading = false;
  String? _error;

  NotifikasiProvider({NotifikasiRepository? repository})
      : _repository = repository ?? NotifikasiRepositoryImpl();

  List<Notifikasi> get list => _list;
  List<Notifikasi> get belumDibaca => _belumDibaca;
  int get jumlahBelumDibaca => _jumlahBelumDibaca;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _repository.getAll();
      _belumDibaca = await _repository.getBelumDibaca();
      _jumlahBelumDibaca = await _repository.getJumlahBelumDibaca();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tambah(Notifikasi notifikasi) async {
    try {
      await _repository.insert(notifikasi);
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> tandaiDibaca(int id) async {
    try {
      await _repository.tandaiSudahDibaca(id);
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> tandaiSemuaDibaca() async {
    try {
      await _repository.tandaiSemuaSudahDibaca();
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> hapus(int id) async {
    try {
      await _repository.delete(id);
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> hapusSemua() async {
    try {
      await _repository.deleteSemua();
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
