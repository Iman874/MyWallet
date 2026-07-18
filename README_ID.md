# 💰 UangKu — Pencatatan Keuangan Pribadi

> **[🇬🇧 English](./README_EN.md)** | **[🇮🇩 Bahasa Indonesia](./README_ID.md)**

**Aplikasi pencatatan keuangan pribadi** berbasis **Flutter (Dart)** dengan **SQLite lokal** — *offline-first*, tanpa backend.

Aplikasi ini membantu pengguna mencatat pemasukan & pengeluaran harian, melihat ringkasan saldo secara *real-time*, memeriksa riwayat transaksi, menganalisis pengeluaran, serta mencadangkan datanya dengan mudah.

---

## ✨ Highlight Fitur

| Fitur | Deskripsi | Versi |
|---|---|---|
| 🏠 **Dasbor** | Saldo real-time, ringkasan harian (pemasukan hijau / pengeluaran merah), 5 transaksi terbaru, progress budget kategori | `v0.2` |
| ➕ **Catat Transaksi** | Catat pemasukan / pengeluaran dengan jumlah, tanggal, kategori dinamis, dan catatan opsional | `v0.2` |
| 📜 **Riwayat** | Daftar transaksi ter-grup per tanggal, filter bulanan, edit (form penuh) & hapus (dialog konfirmasi) | `v0.3` |
| 📊 **Statistik** | Breakdown pengeluaran per kategori (pie chart `fl_chart`), filter tipe & kategori | `v0.4` / `v0.9` |
| 🗂️ **Kategori** | CRUD kategori custom ber-ikon, batas budget per kategori | `v0.5` / `v0.9` |
| 🔔 **Notifikasi** | Peringatan batas pemakaian in-app (harian/mingguan/bulanan) & budget kategori, badge di dasbor | `v0.6` / `v0.9` |
| 🌗 **Tema** | Toggle tema Terang / Gelap / Sistem | `v0.5` |
| 💬 **Toast** | Notifikasi toast in-app (sukses/error/warning/info), maks 3, auto-dismiss | `v0.7` |
| 🔍 **Lihat Detail** | Tap transaksi → detail, edit buka form penuh | `v0.7` |
| ✨ **Splash Screen** | Wallet logo animasi (breathing), koin memantul, loading dots, fade transition | `v0.8` |
| 📥 **Export / Import** | Backup & restore data ke CSV / JSON dengan validasi & upsert (anti-duplikat) | `v0.9` |
| 📈 **Budget per Kategori** | Set batas tiap kategori, progress bar pemakaian bulanan, notifikasi otomatis saat tercapai | `v0.9` |

---

## 🏗️ Tech Stack

| Layer | Teknologi |
|---|---|
| **Framework** | Flutter 3, Dart (`sdk: ^3.10.7`) |
| **Database** | SQLite (`sqflite`) — offline-first, lokal |
| **State Management** | Provider |
| **Charts** | `fl_chart` (pie chart statistik) |
| **File Picker** | `file_picker` (export/import data) |
| **Arsitektur** | Layered: UI (screen/widget) → Provider → Repository → SQLite |
| **Platform** | Android & iOS (Mobile) |

---

## 🚀 Quick Start

```powershell
# Pastikan Flutter SDK terinstall
flutter doctor

# Ambil dependency
flutter pub get

# Jalankan aplikasi (mode debug)
flutter run
```

> 📖 Panduan lengkap ada di [`how_to_run.md`](./how_to_run.md)

---

## 📦 Build APK (Siap Pasang)

```powershell
flutter build apk --release
```

Hasil APK ada di **`build_apk/app-release.apk`** — file ini langsung bisa dipasang (install) di device Android.

---

## 📸 Preview Aplikasi

Tangkapan layar (screenshot) antarmuka UangKu tersimpan di folder:

> 🗂️ **`preview/`** (root project MyWallet)

| Tampilan | File |
|---|---|
| Dasbor Keuangan | `preview/uangku-dashboard.jpeg` |
| Riwayat | `preview/uangku-riwayat.jpeg` |
| Statistik | `preview/uangku-statistik.jpeg` |
| Kategori & Budget | `preview/uangku-category.jpeg` |
| Pengaturan | `preview/uangku-settings.jpeg` |
| Splash | `preview/uangku-splash.jpeg` |

---

## 📁 Struktur Project

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

## 📋 Riwayat Rilis

### v0.9.x — Fitur Portofolio
| Versi | Nama | Highlight |
|---|---|---|
| `v0.9` | Fitur Portofolio | Ekspor/Impor CSV+JSON (upsert anti-duplikat), Pie Chart statistik, Budget per kategori (batas, progress bar, notifikasi) |

### v0.8.x — Splash Screen
| Versi | Nama | Highlight |
|---|---|---|
| `v0.8` | Splash Screen | Wallet logo animasi (breathing), coin animation (bounce/squash/rotate), loading dots, gradient fade transition |

### v0.7.x — Detail & Toast
| Versi | Nama | Highlight |
|---|---|---|
| `v0.7` | Detail & Toast | Lihat detail transaksi, edit penuh via form, Toast notification system (4 tipe, maks 3) |

### v0.6.x — Detail & Notifikasi
| Versi | Nama | Highlight |
|---|---|---|
| `v0.6` | Detail & Notifikasi | Database notifikasi, detail transaksi, batas pemakaian (harian/mingguan/bulanan), logika notifikasi otomatis, halaman & badge notifikasi |

### v0.5.x — Statistik, Kategori, Pengaturan
| Versi | Nama | Highlight |
|---|---|---|
| `v0.5` | Stats/Kategori/Settings | CRUD kategori (ikon), statistik chart, pengaturan (theme toggle terang/gelap/sistem) |

### v0.4.x — Modern UI
| Versi | Nama | Highlight |
|---|---|---|
| `v0.4` | Modern UI | Redesign tema, widget reusable (gradient header, modern card, pill button), bottom nav pill indicator |

### v0.3.x — Riwayat
| Versi | Nama | Highlight |
|---|---|---|
| `v0.3` | Riwayat & Polish | Riwayat screen, filter bulanan, edit & hapus transaksi, grup tanggal, ikon kategori |

### v0.2.x — Dashboard & Catat
| Versi | Nama | Highlight |
|---|---|---|
| `v0.2` | Dashboard & Catat | Dashboard (saldo real-time, ringkasan harian), form tambah transaksi |

### v0.1.x — Foundation
| Versi | Nama | Highlight |
|---|---|---|
| `v0.1` | Foundation | Struktur Flutter, model entity, SQLite helper, repository+provider, theme system, 18 unit test |

---

## 📄 Lisensi

Project privat — tidak untuk distribusi publik.
