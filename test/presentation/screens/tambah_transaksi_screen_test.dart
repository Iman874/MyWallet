import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uangku/presentation/providers/transaksi_provider.dart';
import 'package:uangku/presentation/providers/kategori_provider.dart';
import 'package:uangku/presentation/providers/notifikasi_provider.dart';
import 'package:uangku/presentation/providers/batas_provider.dart';
import 'package:uangku/presentation/providers/theme_provider.dart';
import 'package:uangku/presentation/screens/tambah_transaksi_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransaksiProvider()),
        ChangeNotifierProvider(create: (_) => KategoriProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BatasProvider()),
        ChangeNotifierProvider(create: (_) => NotifikasiProvider()),
      ],
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
