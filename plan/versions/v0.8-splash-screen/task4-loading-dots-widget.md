# Task 4: Buat LoadingDots Widget

## Judul
Buat LoadingDots Widget

## Deskripsi
Membuat reusable widget untuk loading indicator berupa 3 dots yang beranimasi.

## Tujuan Teknis
- Buat LoadingDots StatefulWidget
- Implementasi bouncing dots animation (800ms loop)
- Opacity dan scale animation untuk setiap dot
- Delay antar dots untuk efek sequential
- Warna Primary Blue (#4F7CFF)

## Scope
- [ ] Buat loading_dots.dart
- [ ] Implementasi 3 animated dots
- [ ] Sequential animation (● ○ ○ → ○ ● ○ → ○ ○ ●)
- [ ] Custom properties (size, color, spacing)

## Langkah Implementasi

### 1. Buat File
```
lib/presentation/widgets/loading_dots.dart
```

### 2. Implementasi Widget
```dart
import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  final double size;
  final Color color;
  final double spacing;
  final Duration duration;

  const LoadingDots({
    super.key,
    this.size = 8.0,
    this.color = const Color(0xFF4F7CFF),
    this.spacing = 6.0,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Each dot animates with delay
    _animation1 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_animation1),
        SizedBox(width: widget.spacing),
        _buildDot(_animation2),
        SizedBox(width: widget.spacing),
        _buildDot(_animation3),
      ],
    );
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (animation.value * 0.4),
          child: Opacity(
            opacity: animation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
```

## Output yang Diharapkan
- File loading_dots.dart dengan animated dots
- 3 dots dengan sequential animation
- Custom properties untuk size, color, spacing

## Dependencies
- Tidak ada

## Acceptance Criteria
- [ ] 3 dots beranimasi sequential
- [ ] Opacity dan scale animation smooth
- [ ] Warna Primary Blue (#4F7CFF)
- [ ] Animation loop continues
- [ ] Custom properties berfungsi

## Estimasi
30 menit