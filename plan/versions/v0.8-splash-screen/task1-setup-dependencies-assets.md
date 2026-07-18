# Task 1: Setup Dependencies & Assets

## Judul
Setup Dependencies & Assets

## Deskripsi
Menambahkan dependency flutter_svg dan membuat SVG assets untuk wallet, coin, dan sparkle.

## Tujuan Teknis
- Install flutter_svg package
- Buat folder assets/svg/
- Buat SVG files: wallet_logo.svg, coin.svg, sparkle.svg
- Update pubspec.yaml untuk register SVG assets

## Scope
- [ ] Install flutter_svg
- [ ] Buat folder assets/svg/
- [ ] Buat wallet_logo.svg
- [ ] Buat coin.svg
- [ ] Buat sparkle.svg
- [ ] Update pubspec.yaml

## Langkah Implementasi

### 1. Install flutter_svg
```yaml
# pubspec.yaml
dependencies:
  flutter_svg: ^2.0.0
```

### 2. Buat Folder Assets
```
assets/
└── svg/
    ├── wallet_logo.svg
    ├── coin.svg
    └── sparkle.svg
```

### 3. Buat wallet_logo.svg
```svg
<svg viewBox="0 0 100 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Main wallet body -->
  <rect x="5" y="15" width="90" height="60" rx="12" fill="#4F7CFF"/>
  
  <!-- Wallet flap -->
  <path d="M5 25 Q5 15 15 15 L75 15 Q85 15 85 25 L85 30 L5 30 Z" fill="#2F5BFF"/>
  
  <!-- Card slot -->
  <rect x="20" y="35" width="45" height="25" rx="4" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Card line -->
  <rect x="25" y="42" width="20" height="3" rx="1.5" fill="#4F7CFF" opacity="0.5"/>
  <rect x="25" y="48" width="15" height="3" rx="1.5" fill="#4F7CFF" opacity="0.3"/>
</svg>
```

### 4. Buat coin.svg
```svg
<svg viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg">
  <!-- Coin shadow -->
  <ellipse cx="25" cy="45" rx="18" ry="4" fill="#FFC83D" opacity="0.3"/>
  
  <!-- Coin body -->
  <circle cx="25" cy="25" r="20" fill="#FFC83D"/>
  
  <!-- Coin highlight -->
  <circle cx="20" cy="20" r="8" fill="#FFE483" opacity="0.6"/>
  
  <!-- Coin inner circle -->
  <circle cx="25" cy="25" r="14" fill="none" stroke="#FFB020" stroke-width="2"/>
  
  <!-- Dollar sign -->
  <text x="25" y="30" text-anchor="middle" font-size="16" font-weight="bold" fill="#FF9800">$</text>
</svg>
```

### 5. Buat sparkle.svg
```svg
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 0L14.5 9.5L24 12L14.5 14.5L12 24L9.5 14.5L0 12L9.5 9.5L12 0Z" fill="#FFE483"/>
</svg>
```

### 6. Update pubspec.yaml
```yaml
flutter:
  assets:
    - assets/images/
    - assets/svg/
```

## Output yang Diharapkan
- flutter_svg terinstall
- 3 SVG files tersimpan di assets/svg/
- pubspec.yaml terupdate

## Dependencies
- Tidak ada

## Acceptance Criteria
- [ ] `flutter pub get` berhasil
- [ ] SVG files bisa di-load tanpa error
- [ ] Tidak ada warning di flutter analyze

## Estimasi
30 menit