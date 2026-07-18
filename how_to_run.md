# Cara Menjalankan UangKu (Flutter) — v0.9

Project ini adalah aplikasi mobile **Flutter** dengan database **SQLite lokal** — berjalan *offline* tanpa backend. Versi terkini: **v0.9 (Fitur Portofolio)** — ekspor/impor data, pie chart statistik, dan budget per kategori.

---

## ⚡ Quick Start

```powershell
# Pastikan Flutter SDK terinstall
flutter doctor

# Ambil dependency
flutter pub get

# Jalankan di emulator / device (debug)
flutter run
```

---

## Prasyarat

Pastikan hal berikut sudah terinstall di sistem:

| Komponen | Versi Minimum | Keterangan |
|---|---|---|
| **Flutter SDK** | 3.19+ (project: `sdk: ^3.10.7`) | Framework utama |
| **Dart SDK** | 3.3+ | Ikut bundle dengan Flutter |
| **Android Studio** | - | Emulator / build Android |
| **Xcode** | 15+ | Opsional, untuk build iOS (macOS) |
| **Git** | - | Version control |

### Environment Variables

Tidak ada environment variable wajib — aplikasi berjalan penuh *offline* dengan SQLite lokal.

---

## Setup Pertama Kali

### 1. Clone Repository

```powershell
git clone https://github.com/Iman874/MyWallet.git
cd MyWallet
```

### 2. Install Dependency Flutter

```powershell
flutter pub get
```

### 3. Cek Device / Emulator

```powershell
flutter devices
```

Pastikan ada minimal satu device aktif (emulator Android, iOS simulator, atau device fisik via USB debug).

---

## Menjalankan Aplikasi

### Mode Debug

```powershell
flutter run
```

### Build Release (Android)

```powershell
flutter build apk --release
```

Hasil APK ada di `build/app/outputs/flutter-apk/app-release.apk`.

### Build Release (iOS) — macOS only

```powershell
flutter build ios --release
```

---

## 📸 Preview Aplikasi

Screenshot antarmuka UangKu tersimpan di folder:

> 🗂️ **`D:\Iman874\Documents\Github\ai-agent-hybrid`**

| Tampilan | File |
|---|---|
| Dasbor Keuangan | `uangku-dashboard.jpeg` |
| Catat Transaksi | `uangku-tambah.jpeg` |
| Riwayat | `uangku-riwayat.jpeg` |
| Statistik | `uangku-statistik.jpeg` |
| Kategori & Budget | `uangku-kategori.jpeg` |
| Pengaturan | `uangku-pengaturan.jpeg` |
| Notifikasi | `uangku-notifikasi.jpeg` |
| Splash Screen | `uangku-splash.jpeg` |

---

## Arsitektur Project

```
MyWallet/
├── lib/
│   ├── core/
│   │   ├── theme/           # Tema, warna, text style, decorations
│   │   └── utils/           # Formatter (formatCurrency), icon mapper
│   ├── data/
│   │   ├── datasources/     # SQLite database helper (DB v5)
│   │   └── repositories/    # Implementasi repository
│   ├── domain/
│   │   ├── entities/        # Transaksi, Kategori (batas), Notifikasi
│   │   ├── repositories/    # Interface repository
│   │   └── services/        # DataExportService, NotifikasiService
│   └── presentation/
│       ├── providers/       # Transaksi, Kategori, Theme, Notifikasi, Toast, Batas, Export/Import
│       ├── screens/         # Home, Dashboard, Tambah, Riwayat, Detail, Statistik, Kategori, Pengaturan, Notifikasi, Splash
│       └── widgets/         # UI reusable (cards, header, pie chart, toast, splash widgets)
├── test/                     # Unit & widget test (56 test pass)
├── plan/                     # Dokumen desain & task breakdown (v0.1 – v0.9)
└── pubspec.yaml              # Dependency Flutter
```

---

## Troubleshooting

| Error | Solusi |
|---|---|
| `Flutter command not found` | Tambahkan Flutter ke PATH, jalankan `flutter doctor` |
| `Pub get failed` | Cek koneksi internet & `pubspec.yaml`, lalu `flutter pub get` ulang |
| `No devices found` | Buka emulator Android / hubungkan device fisik dengan USB debug aktif |
| `Gradle build failed` | `flutter clean` lalu `flutter pub get` & build ulang |
| `SQLite error` | Hapus & rebuild aplikasi (data lokal akan reset) |

---

## Perintah Berguna

```powershell
# Cek kesehatan environment Flutter
flutter doctor

# Ambil / perbarui dependency
flutter pub get

# Analisis kode (wajib sebelum commit)
flutter analyze

# Jalankan test suite
flutter test

# Bersihkan build cache
flutter clean

# Format semua file Dart
dart format lib test
```
