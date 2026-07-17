import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uangku/domain/entities/transaksi.dart';
import 'package:uangku/presentation/providers/transaksi_provider.dart';
import 'package:uangku/presentation/screens/dashboard_screen.dart';

void main() {
  Widget createWidgetUnderTest({List<Transaksi>? transaksiList}) {
    final provider = TransaksiProvider();

    return ChangeNotifierProvider<TransaksiProvider>(
      create: (_) => provider,
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    );
  }

  group('Dashboard Screen', () {
    testWidgets('should render empty state when no transactions',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Belum ada transaksi'), findsOneWidget);
    });

    testWidgets('should render saldo card', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Saldo Terkini'), findsOneWidget);
    });

    testWidgets('should render ringkasan harian card', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Ringkasan Hari Ini'), findsOneWidget);
      expect(find.text('Pemasukan'), findsWidgets);
      expect(find.text('Pengeluaran'), findsWidgets);
    });

    testWidgets('should render transaksi terbaru section', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Transaksi Terbaru'), findsOneWidget);
    });

    testWidgets('should have floating action button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should navigate to form when FAB tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Tambah Transaksi'), findsOneWidget);
    });
  });
}
