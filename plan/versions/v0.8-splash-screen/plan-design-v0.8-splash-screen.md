# Plan Design v0.8 - Modern Splash Screen

## Latar Belakang

Aplikasi UangKu saat ini langsung menuju HomeScreen tanpa splash screen. Sebagai aplikasi fintech premium, perlu splash screen yang memberikan kesan profesional dan modern saat pertama kali dibuka.

## Tujuan

Membuat splash screen premium fintech dengan animasi wallet logo yang smooth dan delightful, menggunakan CustomPainter dan AnimationController tanpa依赖 package berat.

## Scope

### Dikerjakan
- Splash screen dengan gradient background
- Animated wallet logo dengan CustomPainter
- Coin bouncing animation dengan squash effect
- Wallet breathing animation (scale up/down)
- Loading dots animation (bouncing dot indicator)
- Sparkle effect saat coin masuk wallet
- Fade transition ke HomeScreen
- Reusable widgets: WalletLogo, CoinAnimation, LoadingDots
- SVG assets untuk wallet, coin, sparkle

### Tidak Dikerjakan
- Onboarding flow
- Splash screen dengan API call
- Lottie animations
- Haptic feedback

## Breakdown Task

| Task | Judul | Estimasi | Dependencies |
|------|-------|----------|--------------|
| 1 | Setup Dependencies & Assets | 30 menit | - |
| 2 | Buat WalletLogo Widget | 1 jam | Task 1 |
| 3 | Buat CoinAnimation Widget | 1.5 jam | Task 2 |
| 4 | Buat LoadingDots Widget | 30 menit | - |
| 5 | Buat SplashScreen Screen | 1.5 jam | Task 2, 3, 4 |
| 6 | Integrasi & Final Verify | 30 menit | Task 5 |

## Design Teknis

### Struktur Widget
```
SplashScreen
├── Gradient Background (#F6F8FC + radial gradient)
├── Center
│   ├── WalletLogo (CustomPainter)
│   ├── CoinAnimation (AnimationController + CustomPainter)
│   ├── SparkleEffect (AnimationController)
│   └── LoadingDots (3 animated dots)
└── Version Text
```

### Animations
| Animation | Duration | Curve | Repeat |
|-----------|----------|-------|--------|
| Wallet Fade In | 300ms | easeOutCubic | Once |
| Coin Bounce | 1200ms | easeInOut | Loop |
| Wallet Breathing | 900ms | easeInOut | Loop |
| Loading Dots | 800ms | easeInOut | Loop |
| Screen Fade Out | 350ms | easeOutCubic | Once |

### Colors
| Element | Color |
|---------|-------|
| Primary Blue | #4F7CFF |
| Secondary Blue | #2F5BFF |
| Background | #F6F8FC |
| Coin Gold | #FFC83D |
| Coin Highlight | #FFE483 |

### File Structure
```
lib/
├── presentation/
│   └── screens/
│       └── splash_screen.dart
│   └── widgets/
│       ├── wallet_logo.dart
│       ├── coin_animation.dart
│       ├── loading_dots.dart
│       └── sparkle_effect.dart
├── core/
│   └── constants/
│       └── splash_constants.dart
```

## Dampak ke Sistem

### Positif
- First impression lebih profesional
- Brand identity lebih kuat
- Loading time terasa lebih cepat

### Risiko
- Cold start sedikit lebih lama (200-300ms)
- Perlu maintain SVG assets

### Mitigasi
- Inisialisasi provider dilakukan paralel saat splash
- Cache assets agar tidak loading ulang

## Definition of Done

- [ ] Splash screen muncul saat app pertama kali dibuka
- [ ] Animasi wallet fade in smooth (300ms)
- [ ] Coin bounce animation berulang 3-4 kali
- [ ] Wallet breathing animation smooth
- [ ] Loading dots beranimasi
- [ ] Setelah inisialisasi, fade transition ke HomeScreen
- [ ] Tidak ada error/warning di flutter analyze
- [ ] Semua test pass
- [ ] Performance 60 FPS
- [ ] Reusable widgets bisa dipakai di tempat lain