# Task 5: Buat SplashScreen Screen

## Judul
Buat SplashScreen Screen

## Deskripsi
Membuat screen splash screen utama yang menggabungkan semua animated widgets.

## Tujuan Teknis
- Buat SplashScreen StatefulWidget
- Gradient background (#F6F8FC + radial gradient)
- Integrasikan WalletLogo, CoinAnimation, LoadingDots
- Sparkle effect saat coin masuk wallet
- Loading state management
- Fade transition ke HomeScreen setelah inisialisasi

## Scope
- [ ] Buat splash_screen.dart
- [ ] Gradient background
- [ ] Integrasikan animated widgets
- [ ] Sparkle effect
- [ ] Loading state management
- [ ] Fade transition navigation

## Langkah Implementasi

### 1. Buat File
```
lib/presentation/screens/splash_screen.dart
```

### 2. Implementasi Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/wallet_logo.dart';
import '../widgets/coin_animation.dart';
import '../widgets/loading_dots.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _sparkleController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showSparkle = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Sparkle animation
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Screen fade out animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _initialize();
  }

  void _initialize() async {
    // Simulate initialization (load providers, etc.)
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isInitialized = true);
      _navigateToHome();
    }
  }

  void _onCoinEntered() {
    setState(() => _showSparkle = true);
    _sparkleController.forward(from: 0).then((_) {
      setState(() => _showSparkle = false);
    });
  }

  void _navigateToHome() async {
    await _fadeController.forward();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF6F8FC),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Center content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Wallet Logo
                        const WalletLogo(size: 140),
                        
                        const SizedBox(height: 40),
                        
                        // Coin Animation
                        CoinAnimation(
                          size: 50,
                          onCoinEntered: _onCoinEntered,
                        ),
                        
                        // Sparkle Effect
                        if (_showSparkle)
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.4,
                            child: AnimatedOpacity(
                              opacity: _showSparkle ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: SvgPicture.asset(
                                'assets/svg/sparkle.svg',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 60),
                        
                        // Loading Dots
                        const LoadingDots(),
                      ],
                    ),
                  ),
                  
                  // Version Text
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Text(
                      'v1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### 3. Update main.dart
```dart
import 'presentation/screens/splash_screen.dart';

// Ganti home: const HomeScreen() menjadi:
home: const SplashScreen(),
```

## Output yang Diharapkan
- File splash_screen.dart dengan gradient background
- Integrasi semua animated widgets
- Sparkle effect saat coin masuk wallet
- Fade transition ke HomeScreen

## Dependencies
- Task 2 (WalletLogo)
- Task 3 (CoinAnimation)
- Task 4 (LoadingDots)

## Acceptance Criteria
- [ ] Gradient background muncul
- [ ] WalletLogo fade in dan breathing
- [ ] Coin bouncing animation
- [ ] Sparkle effect saat coin masuk
- [ ] Loading dots beranimasi
- [ ] Setelah 2 detik, fade transition ke HomeScreen
- [ ] Tidak ada error di flutter analyze

## Estimasi
1.5 jam