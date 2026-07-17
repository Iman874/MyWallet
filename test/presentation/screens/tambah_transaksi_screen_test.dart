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

    testWidgets('should show error when submitting empty form',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(find.text('Jumlah wajib diisi'), findsOneWidget);
    });

    testWidgets('should show error when jumlah is 0', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).first, '0');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(find.text('Jumlah harus lebih dari 0'), findsOneWidget);
    });

    testWidgets('should show error when jumlah is negative', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).first, '-100');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(find.text('Jumlah harus lebih dari 0'), findsOneWidget);
    });

    testWidgets('should have radio buttons for tipe', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Pemasukan'), findsOneWidget);
      expect(find.text('Pengeluaran'), findsOneWidget);
    });

    testWidgets('should have category dropdown', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });
  });
}
