import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uangku/presentation/providers/transaksi_provider.dart';
import 'package:uangku/presentation/screens/tambah_transaksi_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<TransaksiProvider>(
      create: (_) => TransaksiProvider(),
      child: const MaterialApp(
        home: TambahTransaksiScreen(),
      ),
    );
  }

  group('Tambah Transaksi Screen', () {
    testWidgets('should render form fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Tambah Transaksi'), findsOneWidget);
      expect(find.text('Jumlah'), findsOneWidget);
      expect(find.text('Tanggal'), findsOneWidget);
      expect(find.text('Kategori'), findsOneWidget);
      expect(find.text('Tipe Transaksi'), findsOneWidget);
      expect(find.text('Catatan (opsional)'), findsOneWidget);
    });

    testWidgets('should have pill buttons for tipe', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Pemasukan'), findsOneWidget);
      expect(find.text('Pengeluaran'), findsOneWidget);
    });

    testWidgets('should have category field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Kategori'), findsOneWidget);
      expect(find.text('Makan'), findsOneWidget);
    });

    testWidgets('should show gradient header', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Tambah Transaksi'), findsOneWidget);
    });

    testWidgets('should have save button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Simpan'), findsOneWidget);
    });
  });
}
