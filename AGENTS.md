# UangKu — Agent Guide

Aplikasi pencatatan keuangan pribadi berbasis Flutter (Dart) dengan SQLite lokal. Fase 1 (MVP): Dasbor Keuangan, Catat Transaksi, Riwayat Transaksi.

## Memory proyek (`.memori.txt`)

Project ini punya **persistent project memory** di file `.memori.txt` (root project) agar AI tetap paham konteks lintas sesi.

- **Sebelum kerja apa pun**: cari `.memori.txt` di root. Jika ada, **cari entry yang relevan dengan konteks kerja saat ini** (tidak harus mulai dari yang paling atas — file ini bisa panjang karena banyak agent menulis bersamaan); jadikan konteks utama. Jika tidak ada, beritahu user dan tawarkan membuat file baru.
- **Kapan update**: saat ada info penting — bug ditemukan/diperbaiki, perubahan arsitektur/struktur folder/fitur/dependency/framework/config, keputusan desain, atau catatan teknis berguna. Jangan catat hal sepele (typo, format).
- **Format**: untuk info **baru**, tambahkan catatan **paling atas** (newest first). Untuk info yang **sudah ada** di entry tertentu, **edit langsung entry tersebut di tempatnya** (perbarui Detail/Dampak/Status) — **JANGAN pindahkan ke atas**, agar urutan milik agent lain tidak terganggu.
  ```
  ==================================================
  Tanggal : YYYY-MM-DD
  Waktu   : HH:mm
  Kategori: <Bug | Feature | Refactor | Config | Decision | Architecture | Note>

  Judul:
  Ringkasan singkat.

  Detail:
  - ...
  - ...

  Dampak:
  - ...
  ==================================================
  ```
- **Aturan penulisan**: jangan hapus history lama; jangan ubah catatan lama kecuali salah; pakai bahasa singkat & jelas; fokus info teknis. **Jika mengupdate memori yang relevan dengan pekerjaan agent lain, edit entry-nya di tempat (in-place) tanpa memindahkannya ke atas** — ini mencegah tumpang-tindih catatan antar agent yang sedang bekerja.
- **Maintenance**: bila file > ±1000 baris / ±100 KB, buat bagian "Ringkasan Project" — gabungkan info lama, pertahankan keputusan/bug/arsitektur penting, jangan hapus info penting.
- **Sebelum akhiri kerja**: cek apakah ada info layak disimpan; jika ada, update `.memori.txt`; jika tidak ada info penting, jangan ubah file.

## Bahasa (language)

- **WAJIB**: Selalu gunakan **Bahasa Indonesia** untuk seluruh komunikasi — baik chat/balasan ke user maupun semua dokumen plan (plan design, task files, catatan, commit message bila memungkinkan). Jangan menulis penjelasan atau dokumen planning dalam Bahasa Inggris kecuali user yang minta.

## Project info

| Item | Detail |
|---|---|
| Nama Aplikasi | UangKu |
| Platform | Android & iOS (Mobile) |
| Framework | Flutter (Dart) |
| State Management | Provider / Riverpod / Bloc (belum diputuskan) |
| Database | SQLite lokal (sqflite/Hive) — offline-first |
| Fase Saat Ini | 1 (MVP) |
| Status | Perencanaan (Draft) |

## Fitur Fase 1 (MVP)

| Fitur | Sub-fitur |
|---|---|
| Dasbor Keuangan | Saldo Terkini, Ringkasan Harian (pemasukan hijau / pengeluaran merah), Transaksi Terbaru (5 terakhir) |
| Catat Transaksi | Tambah Pemasukan, Tambah Pengeluaran. Field: jumlah (positif, wajib), tanggal (default hari ini), kategori (dropdown: Gaji, Makan, Transportasi, Hiburan, Lainnya), catatan (opsional) |
| Riwayat Transaksi | Daftar Semua Transaksi, Filter Bulanan, Edit Catatan, Hapus Catatan (dengan dialog konfirmasi) |

## Acceptance Criteria (ringkasan)

- Saldo terkini real-time update tiap transaksi baru/edit/hapus
- Ringkasan harian: pemasukan (hijau) & pengeluaran (merah) terpisah
- Transaksi terbaru max 5 item, terbaru dulu
- Empty state kalau belum ada transaksi
- List riwayat: tanggal, kategori, jumlah, tipe dgn indikator warna
- Hapus perlu dialog konfirmasi

## Kebutuhan teknis

- **Flutter + Dart** — pastikan SDK terinstall dan sesuai `pubspec.yaml`
- **SQLite lokal** — offline-first, tanpa backend
- **State management** — pilih salah satu: Provider (sederhana), Riverpod (modern), Bloc (enterprise)
- **Performa**: Dasbor load < 2 detik; cold start < 3 detik; crash rate < 1%
- **Validasi**: jumlah tidak boleh 0 atau negatif
- **Edit/Hapus**: langsung update saldo (re-calc dari seluruh transaksi atau delta)

## Workflow: perubahan (bug fix / fitur baru)

Untuk setiap perubahan non-trivial (fitur baru, perbaikan bug, refactor), ikuti planning workflow di bawah ini. Jangan langsung edit kode tanpa plan bila task menyentuh lebih dari satu file atau butuh verifikasi lintas fitur.

### 1. Plan & analisis
- Pahami scope: lihat PRD.md dan file terdampak.
- Identifikasi layering: **UI (screen/widget)** → **ViewModel/Controller/Bloc** → **Repository** → **Database (SQLite)**. Jangan campur logic lintas layer dalam satu task.
- Buat plan design di `plan/versions/` (buat folder bila belum ada) dengan format `plan-design-nama-fitur.md`. Section wajib: Latar Belakang, Tujuan, Scope (dikerjakan/tidak), Breakdown Task, Design Teknis (file terdampak, flow, skema DB), Dampak ke Sistem, Definition of Done.

### 2. Eksekusi
- Kerjakan task berurutan sesuai dependency.
- Setiap task mencakup: UI, logic, database, validasi.
- Pastikan empty state, error state, dan loading state terhandle.

### 3. Verifikasi wajib (setiap task)
- **Flutter analyze**: jalankan `flutter analyze` atau `dart analyze` — pastikan tidak ada error/warning baru.
- **Flutter test**: jalankan `flutter test` jika ada unit test/widget test.
- **Regression check**: pastikan fitur lain tidak rusak.

### 4. Setelah implementasi
- Update status plan & task.
- Update `.memori.txt` bila ada info penting.
- Pastikan `pubspec.yaml` tidak corrupted.

### Definition of Done
- Kode sesuai scope plan.
- Flutter analyze bersih (tanpa error baru).
- Semua acceptance criteria terpenuhi.
- Empty/error/loading state terhandle.
- Tidak ada perubahan liar di luar scope.

## Workflow debugging & standar pelaporan

### 1. Identifikasi area
Tentukan apakah bug di UI, state management, atau database. Gunakan `flutter analyze` dulu sebelum debugging manual.

### 2. Prosedur analisis error
- **Flutter**: selalu cek `flutter analyze` dulu. AI tidak bisa lihat emulator langsung — minta user screenshot atau console log bila perlu.
- **Database**: cek query SQLite, pastikan migration benar. Jangan asumsikan error tanpa bukti.

### 3. Setelah perubahan
Validasi minimal: `flutter analyze`, test relevan, pastikan tidak ada compile error, warning baru, dan perubahan tidak merusak fitur lain.

### 4. Git
- Cek status perubahan dengan `git status`. Jangan commit/push tanpa izin user.
- Format commit message: `fix bug <judul>: <deskripsi>` / `add feature <nama>: <deskripsi>` (Bahasa Indonesia).

### 5. Format laporan (wajib setiap selesai kerja)
- **Ringkasan**: masalah + solusi.
- **Yang Saya Lakukan**: daftar tindakan (analisis, flutter analyze/test, fix, refactor, dll).
- **Hasil Validasi**: flutter analyze bersih / ada error tertentu / tidak dapat verifikasi runtime.
- **File yang Diubah**: path, jenis perubahan, alasan, nomor baris, ringkasan.
- **Dampak Perubahan**: fitur terdampak, efek samping, risiko regresi.
- **Hal yang Perlu Diverifikasi User**: daftar uji manual.
- **Kendala**: keterbatasan yang dihadapi.

### 6. Prinsip kerja
- Jangan nebak penyebab bug; pakai bukti (log, stack trace, hasil analyze, hasil test).
- Jelaskan alasan tiap perubahan. Utamakan perubahan sekecil mungkin (minimal change).
- Jika ada >1 solusi, jelaskan kelebihan/kekurangan masing-masing.
- Laporkan semua tindakan secara transparan. Jangan klaim selesai sebelum ada bukti.

## git

- Project ini menggunakan **satu repository git** di root `MyWallet/`.
- JANGAN commit/push/buat branch tanpa izin user.
- Format commit message (Bahasa Indonesia):
  - Perbaikan bug: `fix bug <judul-bug>: <deskripsi>`
  - Penambahan fitur: `add feature <nama-fitur>: <deskripsi>`
- Selalu cek `git status` sebelum dan sesudah bekerja.

## graphify

This project has a graphify knowledge graph at .graphify/.

Rules:
- For codebase or architecture questions, when `.graphify/graph.json` exists, first run `graphify query "<question>"` (or `graphify path "<A>" "<B>"` / `graphify explain "<concept>"`); these return a scoped subgraph, usually much smaller than `GRAPH_REPORT.md` or raw grep output
- If .graphify/wiki/index.md exists, navigate it instead of reading raw files
- If .graphify/graph.json is missing but graphify-out/graph.json exists, run `graphify migrate-state --dry-run` first; if tracked legacy artifacts are reported, ask before using the recommended `git mv -f graphify-out .graphify` and commit message
- If .graphify/needs_update exists or .graphify/branch.json has stale=true, warn before relying on semantic results and run the graphify pipeline with `--update` when appropriate
- If the user asks to build, update, query, path, or explain the graph, use the installed graphify pipeline instead of ad-hoc file traversal
- Before proposing or committing .graphify artifacts, run `graphify portable-check .graphify`; commit-safe graph artifacts must use repo-relative paths, and never commit .graphify/branch.json, .graphify/worktree.json, .graphify/needs_update, or .graphify/cache/. If a repo already tracks any of them, first add them to .gitignore, then propose `git rm --cached .graphify/branch.json .graphify/worktree.json .graphify/needs_update` and `git rm -r --cached .graphify/cache`; never mutate git state without asking
- Before deep graph traversal, prefer `graphify summary --graph .graphify/graph.json` for compact first-hop orientation
- For review impact on changed files, use `graphify review-delta --graph .graphify/graph.json` instead of generic traversal
- Read `.graphify/GRAPH_REPORT.md` only for broad architecture review or when `query` / `path` / `explain` do not surface enough context
- After modifying code files in this session, run `npx graphify hook-rebuild` to keep the graph current

## following instructions

- **CRITICAL**: Nurut arahan user. JANGAN cari alternatif atau buat asumsi sendiri kecuali user yang suruh.
- Kalau user bilang lakukan A, lakukan A. Jangan coba-coba pendekatan B, C, D sendiri.
- Kalau user sudah jelas bilang apa yang mereka mau, langsung implement. Jangan sok pinter cari cara lain.

## Prinsip kejujuran & delegasi

### Kejujuran
- **CRITICAL**: Selalu jujur kepada user, termasuk saat kabar buruk. Jika tidak paham logika tertentu, tidak mampu menangani sebuah bug, atau tidak yakin dengan solusi — **katakan secara jujur**, jangan berpura-pura selesai.
- Jangan klaim bug sudah diperbaiki / fitur sudah jadi tanpa bukti (hasil analyze, hasil test).
- Jika butuh informasi dari user (screenshot, console, akses device), minta dengan jelas.

### Delegasi & penghematan token
- Jika user meminta untuk **memahami konteks** (eksplorasi codebase, riset, analisis), manfaatkan **sub-agent / multi-agent** yang tersedia alih-alih mengerjakan semuanya sendiri.
- Serahkan pengumpulan konteks berat ke agent terpisah, lalu gunakan hasil ringkasnya.
