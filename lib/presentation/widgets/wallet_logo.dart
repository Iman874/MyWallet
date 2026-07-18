import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletLogo extends StatefulWidget {
  final double size;
  final bool animate;

  const WalletLogo({
    super.key,
    this.size = 120,
    this.animate = true,
  });

  @override
  State<WalletLogo> createState() => _WalletLogoState();
}

class _WalletLogoState extends State<WalletLogo>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _breathController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    
    // Fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    // Breathing animation
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _startAnimations();
    } else {
      _fadeController.value = 1.0;
      _breathController.repeat(reverse: true);
    }
  }

  void _startAnimations() async {
    await _fadeController.forward();
    if (mounted) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _breathAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _breathAnimation.value,
            child: child,
          );
        },
        child: SvgPicture.asset(
          'assets/svg/wallet_logo.svg',
          width: widget.size,
          height: widget.size * 0.8,
        ),
      ),
    );
  }
}