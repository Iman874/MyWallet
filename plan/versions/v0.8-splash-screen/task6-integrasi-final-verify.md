# Task 6: Integrasi & Final Verify

## Judul
Integrasi & Final Verify

## Deskripsi
Mengintegrasikan splash screen ke dalam aplikasi dan melakukan verifikasi akhir.

## Tujuan Teknis
- Update main.dart untuk menggunakan SplashScreen
- Pastikan inisialisasi provider dilakukan dengan benar
- Jalankan flutter analyze
- Jalankan flutter test
- Pastikan tidak ada regression

## Scope
- [ ] Update main.dart navigation
- [ ] Pastikan provider initialization benar
- [ ] Flutter analyze 0 error
- [ ] Flutter test pass semua
- [ ] Performance check
- [ ] Update .memori.txt

## Langkah Implementasi

### 1. Update main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/transaksi_provider.dart';
import 'presentation/providers/kategori_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/batas_provider.dart';
import 'presentation/providers/notifikasi_provider.dart';
import 'presentation/providers/toast_provider.dart';
import 'presentation/screens/splash_screen.dart'; // Import splash

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
        ChangeNotifierProvider(create: (_) => ToastProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'UangKu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(), // Ganti ke SplashScreen
          );
        },
      ),
    );
  }
}
```

### 2. Jalankan Flutter Analyze
```bash
flutter analyze
```

### 3. Jalankan Flutter Test
```bash
flutter test
```

### 4. Performance Check
- Pastikan animation 60 FPS
- Tidak ada frame drops
- Memory usage normal

### 5. Update .memori.txt
Tambahkan entry baru untuk v0.8 splash screen.

## Output yang Diharapkan
- SplashScreen sebagai initial route
- Semua provider terinisialisasi dengan benar
- Tidak ada error/warning di flutter analyze
- Semua test pass

## Dependencies
- Task 5 (SplashScreen)

## Acceptance Criteria
- [ ] SplashScreen muncul saat app pertama kali dibuka
- [ ] Semua provider terinisialisasi
- [ ] Fade transition ke HomeScreen berhasil
- [ ] Flutter analyze 0 error
- [ ] Flutter test pass semua
- [ ] Performance 60 FPS
- [ ] Tidak ada regression

## Estimasi
30 menit