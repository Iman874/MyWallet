import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinAnimation extends StatefulWidget {
  final double size;
  final VoidCallback? onCoinEntered;
  final bool startAnimation;

  const CoinAnimation({
    super.key,
    this.size = 50,
    this.onCoinEntered,
    this.startAnimation = true,
  });

  @override
  State<CoinAnimation> createState() => _CoinAnimationState();
}

class _CoinAnimationState extends State<CoinAnimation>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _squashController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _squashAnimation;
  late Animation<double> _rotationAnimation;

  bool _isLooping = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _squashController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _setupAnimations();
    if (widget.startAnimation) {
      _startBounceLoop();
    }
  }

  @override
  void didUpdateWidget(covariant CoinAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kalau startAnimation berubah dari false -> true saat widget sudah hidup,
    // loop-nya ikut jalan (sebelumnya tidak ada cara untuk memicu ini).
    if (widget.startAnimation && !oldWidget.startAnimation && !_isLooping) {
      _startBounceLoop();
    }
  }

  void _setupAnimations() {
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.5), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    _squashAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _squashController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startBounceLoop() async {
    _isLooping = true;
    while (mounted) {
      // Pastikan koin terlihat penuh di awal setiap siklus.
      _fadeController.value = 0;

      // 1) Bounce sampai selesai — koin tetap terlihat.
      await _bounceController.forward(from: 0);
      if (!mounted) break;

      // 2) Efek squash "mendarat" — koin masih terlihat di sini,
      //    ini yang tadi ke-skip karena fade duluan.
      await _squashController.forward(from: 0);
      if (!mounted) break;
      await _squashController.reverse();
      if (!mounted) break;

      // 3) Baru trigger callback (sparkle) setelah koin benar-benar "mendarat".
      widget.onCoinEntered?.call();

      // 4) Jeda sebentar biar sparkle sempat kelihatan berbarengan dengan koin.
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) break;

      // 5) Baru fade out untuk transisi ke siklus berikutnya.
      await _fadeController.forward(from: 0);
      if (!mounted) break;
    }
    _isLooping = false;
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _squashController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_bounceAnimation, _squashAnimation, _rotationAnimation, _fadeController]),
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _fadeController.value,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..translateByDouble(0.0, _bounceAnimation.value * 60, 0.0, 1.0)
              ..rotateZ(_rotationAnimation.value * 3.14159 / 180)
              ..scaleByDouble(1.0, _squashAnimation.value, 1.0, 1.0),
            child: child,
          ),
        );
      },
      // SvgPicture dibuat sekali lewat `child` biar tidak di-rebuild
      // setiap frame animasi (sedikit lebih hemat performa).
      child: SvgPicture.asset(
        'assets/svg/coin.svg',
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}