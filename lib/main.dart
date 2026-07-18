import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/transaksi_provider.dart';
import 'presentation/providers/kategori_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/batas_provider.dart';
import 'presentation/providers/notifikasi_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransaksiProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => KategoriProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BatasProvider()),
        ChangeNotifierProvider(create: (_) => NotifikasiProvider()..loadAll()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'UangKu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
