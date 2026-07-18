import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatasProvider extends ChangeNotifier {
  static const String _keyHarian = 'batas_harian';
  static const String _keyMingguan = 'batas_mingguan';
  static const String _keyBulanan = 'batas_bulanan';

  int _batasHarian = 200000;
  int _batasMingguan = 1500000;
  int _batasBulanan = 5000000;
  bool _isLoading = false;

  int get batasHarian => _batasHarian;
  int get batasMingguan => _batasMingguan;
  int get batasBulanan => _batasBulanan;
  bool get isLoading => _isLoading;

  BatasProvider() {
    _loadBatas();
  }

  Future<void> _loadBatas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _batasHarian = prefs.getInt(_keyHarian) ?? 200000;
      _batasMingguan = prefs.getInt(_keyMingguan) ?? 1500000;
      _batasBulanan = prefs.getInt(_keyBulanan) ?? 5000000;
    } catch (e) {
      debugPrint('Error loading batas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setBatasHarian(int value) async {
    _batasHarian = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHarian, value);
  }

  Future<void> setBatasMingguan(int value) async {
    _batasMingguan = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMingguan, value);
  }

  Future<void> setBatasBulanan(int value) async {
    _batasBulanan = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyBulanan, value);
  }

  Future<void> setSemuaBatas({
    required int harian,
    required int mingguan,
    required int bulanan,
  }) async {
    _batasHarian = harian;
    _batasMingguan = mingguan;
    _batasBulanan = bulanan;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHarian, harian);
    await prefs.setInt(_keyMingguan, mingguan);
    await prefs.setInt(_keyBulanan, bulanan);
  }
}
