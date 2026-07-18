import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uangku/presentation/providers/batas_provider.dart';

void main() {
  group('Batas Provider', () {
    test('initial state - should have default values', () {
      SharedPreferences.setMockInitialValues({});
      final provider = BatasProvider();

      expect(provider.batasHarian, 200000);
      expect(provider.batasMingguan, 1500000);
      expect(provider.batasBulanan, 5000000);
    });

    test('setBatasHarian - should update harian limit', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = BatasProvider();
      await Future.delayed(Duration.zero);

      await provider.setBatasHarian(100000);

      expect(provider.batasHarian, 100000);
    });

    test('setBatasMingguan - should update mingguan limit', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = BatasProvider();
      await Future.delayed(Duration.zero);

      await provider.setBatasMingguan(1000000);

      expect(provider.batasMingguan, 1000000);
    });

    test('setBatasBulanan - should update bulanan limit', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = BatasProvider();
      await Future.delayed(Duration.zero);

      await provider.setBatasBulanan(3000000);

      expect(provider.batasBulanan, 3000000);
    });

    test('setSemuaBatas - should update all limits at once', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = BatasProvider();
      await Future.delayed(Duration.zero);

      await provider.setSemuaBatas(
        harian: 50000,
        mingguan: 500000,
        bulanan: 2000000,
      );

      expect(provider.batasHarian, 50000);
      expect(provider.batasMingguan, 500000);
      expect(provider.batasBulanan, 2000000);
    });

    test('persist - should persist and load values from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'batas_harian': 100000,
        'batas_mingguan': 700000,
        'batas_bulanan': 3000000,
      });

      final provider = BatasProvider();
      await Future.delayed(Duration.zero);

      expect(provider.batasHarian, 100000);
      expect(provider.batasMingguan, 700000);
      expect(provider.batasBulanan, 3000000);
    });
  });
}
