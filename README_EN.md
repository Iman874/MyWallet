# 💰 UangKu — Personal Finance Tracker

> **[🇬🇧 English](./README_EN.md)** | **[🇮🇩 Bahasa Indonesia](./README_ID.md)**

**Personal finance tracker app** built with **Flutter (Dart)** and **local SQLite** — *offline-first*, no backend required.

This app helps users record daily income & expenses, view real-time balance summaries, review transaction history, analyze spending, and back up their data with ease.

---

## ✨ Feature Highlights

| Feature | Description | Version |
|---|---|---|
| 🏠 **Dashboard** | Real-time balance, daily summary (income green / expense red), latest 5 transactions, category budget progress | `v0.2` |
| ➕ **Add Transaction** | Record income / expense with amount, date, dynamic category, and optional note | `v0.2` |
| 📜 **History** | List all transactions grouped by date, monthly filter, edit (full form) & delete (confirmation dialog) | `v0.3` |
| 📊 **Statistics** | Spending breakdown by category (pie chart via `fl_chart`), filter by type & category | `v0.4` / `v0.9` |
| 🗂️ **Categories** | Custom category CRUD with icons, per-category budget limit | `v0.5` / `v0.9` |
| 🔔 **Notifications** | In-app spending limit alerts (daily/weekly/monthly) & per-category budget alerts, badge on dashboard | `v0.6` / `v0.9` |
| 🌗 **Theme** | Light / Dark / System theme toggle | `v0.5` |
| 💬 **Toast** | In-app toast notifications (success / error / warning / info), max 3, auto-dismiss | `v0.7` |
| 🔍 **Detail View** | Tap transaction → detail screen, edit opens full form | `v0.7` |
| ✨ **Splash Screen** | Animated wallet logo (breathing), bouncing coin, loading dots, fade transition | `v0.8` |
| 📥 **Export / Import** | Backup & restore data to CSV / JSON with validation & upsert (no duplicates) | `v0.9` |
| 📈 **Budget per Category** | Set limit per category, progress bar of monthly usage, auto notification when reached | `v0.9` |

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3, Dart (`sdk: ^3.10.7`) |
| **Database** | SQLite (`sqflite`) — offline-first, local-only |
| **State Management** | Provider |
| **Charts** | `fl_chart` (pie chart statistik) |
| **File Picker** | `file_picker` (export/import data) |
| **Architecture** | Layered: UI (screen/widget) → Provider → Repository → SQLite |
| **Platform** | Android & iOS (Mobile) |

---

## 🚀 Quick Start

```powershell
# Ensure Flutter SDK is installed
flutter doctor

# Get dependencies
flutter pub get

# Run the app (debug mode)
flutter run
```

> 📖 Full setup guide available at [`how_to_run.md`](./how_to_run.md)

---

## 📸 App Preview

Screenshots of the UangKu interface are stored in the folder:

> 🗂️ **`D:\Iman874\Documents\Github\ai-agent-hybrid`**

| Screen | File | Description |
|---|---|---|
| Dashboard | `uangku-dashboard.jpeg` | Current balance, daily summary, latest transactions |
| Add Transaction | `uangku-tambah.jpeg` | Income / expense form |
| History | `uangku-riwayat.jpeg` | Transaction list & monthly filter |
| Statistics | `uangku-statistik.jpeg` | Pie chart by category |
| Categories & Budget | `uangku-kategori.jpeg` | Custom categories + budget progress |
| Settings | `uangku-pengaturan.jpeg` | Export / import data, theme |
| Notifications | `uangku-notifikasi.jpeg` | Limit & budget alerts |
| Splash | `uangku-splash.jpeg` | Animated wallet logo & coin animation |

---

## 📁 Project Structure

```
MyWallet/
├── lib/
│   ├── core/
│   │   ├── theme/           # App theme, colors, text styles, decorations
│   │   └── utils/           # Formatters (formatCurrency), icon mapper
│   ├── data/
│   │   ├── datasources/     # SQLite database helper (DB v5)
│   │   └── repositories/    # Repository implementations
│   ├── domain/
│   │   ├── entities/        # Transaksi, Kategori (batas), Notifikasi
│   │   ├── repositories/    # Repository interfaces
│   │   └── services/        # DataExportService, NotifikasiService
│   └── presentation/
│       ├── providers/       # Transaksi, Kategori, Theme, Notifikasi, Toast, Batas, Export/Import
│       ├── screens/         # Home, Dashboard, Tambah, Riwayat, Detail, Statistik, Kategori, Pengaturan, Notifikasi, Splash
│       └── widgets/         # Reusable UI (cards, header, pie chart, toast, splash widgets)
├── test/                     # Unit & widget tests (56 tests pass)
├── plan/                     # Design docs & task breakdowns (v0.1 – v0.9)
└── pubspec.yaml              # Flutter dependencies
```

---

## 📋 Release History

### v0.9.x — Portfolio Features
| Version | Name | Highlight |
|---|---|---|
| `v0.9` | Fitur Portofolio | Ekspor/Impor CSV+JSON (upsert anti-duplikat), Pie Chart statistik, Budget per kategori (batas, progress bar, notifikasi) |

### v0.8.x — Splash Screen
| Version | Name | Highlight |
|---|---|---|
| `v0.8` | Splash Screen | Animated wallet logo (breathing), coin animation (bounce/squash/rotate), loading dots, gradient fade transition |

### v0.7.x — Detail & Toast
| Version | Name | Highlight |
|---|---|---|
| `v0.7` | Detail & Toast | Lihat detail transaksi, edit penuh via form, Toast notification system (4 tipe, max 3) |

### v0.6.x — Detail & Notifikasi
| Version | Name | Highlight |
|---|---|---|
| `v0.6` | Detail & Notifikasi | Database notifikasi, detail transaksi, batas pemakaian (harian/mingguan/bulanan), logika notifikasi otomatis, halaman & badge notifikasi |

### v0.5.x — Statistik, Kategori, Pengaturan
| Version | Name | Highlight |
|---|---|---|
| `v0.5` | Stats/Kategori/Settings | CRUD kategori (ikon), statistik chart, pengaturan (theme toggle light/dark/system) |

### v0.4.x — Modern UI
| Version | Name | Highlight |
|---|---|---|
| `v0.4` | Modern UI | Redesign tema, widget reusable (gradient header, modern card, pill button), bottom nav pill indicator |

### v0.3.x — Riwayat
| Version | Name | Highlight |
|---|---|---|
| `v0.3` | Riwayat & Polish | Riwayat screen, filter bulanan, edit & hapus transaksi, grup tanggal, icon kategori |

### v0.2.x — Dashboard & Catat
| Version | Name | Highlight |
|---|---|---|
| `v0.2` | Dashboard & Catat | Dashboard (saldo real-time, ringkasan harian), form tambah transaksi |

### v0.1.x — Foundation
| Version | Name | Highlight |
|---|---|---|
| `v0.1` | Foundation | Struktur Flutter, model entity, SQLite helper, repository+provider, theme system, 18 unit test |

---

## 📄 License

Private project — not for public distribution.
