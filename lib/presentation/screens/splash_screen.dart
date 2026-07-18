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
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CoinAnimation(
                          size: 50,
                          onCoinEntered: _onCoinEntered,
                        ),
                        const SizedBox(height: 16),
                        const WalletLogo(size: 140),
                        const SizedBox(height: 60),
                        const LoadingDots(),
                      ],
                    ),
                  ),

                  if (_showSparkle)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.4,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: SvgPicture.asset(
                          'assets/svg/sparkle.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),

                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Text(
                      'v1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.withValues(alpha: 0.5),
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