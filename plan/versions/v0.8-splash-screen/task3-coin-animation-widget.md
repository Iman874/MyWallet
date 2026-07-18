# Task 3: Buat CoinAnimation Widget

## Judul
Buat CoinAnimation Widget

## Deskripsi
Membuat reusable widget untuk animasi coin yang bouncing dan masuk ke dalam wallet.

## Tujuan Teknis
- Buat CoinAnimation StatefulWidget
- Implementasi bouncing animation (1200ms, 3-4 kali repeat)
- Implementasi squash effect saat impact
- Implementasi rotation -8° to +8° saat bouncing
- Coin menghilang setelah masuk wallet
- Sparkle effect saat coin masuk wallet

## Scope
- [ ] Buat coin_animation.dart
- [ ] Implementasi bouncing path animation
- [ ] Implementasi squash effect
- [ ] Implementasi rotation
- [ ] Coin restart logic (new coin after previous masuk)
- [ ] Callback onCoinEnteredWallet

## Langkah Implementasi

### 1. Buat File
```
lib/presentation/widgets/coin_animation.dart
```

### 2. Animation Timeline
```
Total duration: 1200ms
- 0-300ms: Coin turun dari atas ke bawah
- 300-400ms: Coin squash + bounce
- 400-700ms: Coin naik ke atas (smaller bounce)
- 700-800ms: Coin squash + bounce
- 800-1000ms: Coin naik (smaller bounce)
- 1000-1100ms: Coin squash + final bounce
- 1100-1200ms: Coin masuk wallet (scale to 0 + fade out)
```

### 3. Implementasi Widget
```dart
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
  late Animation<double> _bounceAnimation;
  late Animation<double> _squashAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // Bounce animation
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Squash animation
    _squashController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _setupAnimations();

    if (widget.startAnimation) {
      _startBounceLoop();
    }
  }

  void _setupAnimations() {
    // Bounce path: down → up → down → up → into wallet
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 25), // Fall
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 25), // Rise
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 25), // Fall
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.5), weight: 25), // Rise + enter
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Squash: 1.0 → 0.7 (squash) → 1.0 (restore)
    _squashAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _squashController,
      curve: Curves.easeOut,
    ));

    // Rotation: -8° to +8° during bounce
    _rotationAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  void _startBounceLoop() async {
    while (mounted) {
      await _bounceController.forward(from: 0);
      
      // Trigger squash on impact
      await _squashController.forward(from: 0);
      await _squashController.reverse();
      
      // Coin entered wallet
      widget.onCoinEntered?.call();
      
      // Wait before next coin
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (!mounted) break;
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _squashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnimation, _squashAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..translate(0.0, _bounceAnimation.value * 100) // Bounce movement
            ..rotateZ(_rotationAnimation.value * 3.14159 / 180) // Rotation
            ..scale(1.0, _squashAnimation.value), // Squash effect
          child: Opacity(
            opacity: _bounceController.value > 0.9 ? 1.0 - (_bounceController.value - 0.9) * 10 : 1.0,
            child: SvgPicture.asset(
              'assets/svg/coin.svg',
              width: widget.size,
              height: widget.size,
            ),
          ),
        );
      },
    );
  }
}
```

## Output yang Diharapkan
- File coin_animation.dart dengan bouncing animation
- Coin masuk wallet dengan squash effect
- Sparkle effect (bisa diintegrasikan di splash_screen)

## Dependencies
- Task 1 (SVG assets)

## Acceptance Criteria
- [ ] Coin bounce animation smooth (1200ms)
- [ ] Squash effect saat impact
- [ ] Rotation -8° to +8°
- [ ] Coin menghilang setelah masuk wallet
- [ ] Coin baru muncul setelah sebelumnya masuk
- [ ] Performance 60 FPS

## Estimasi
1.5 jam