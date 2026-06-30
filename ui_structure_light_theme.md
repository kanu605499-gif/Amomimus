# Struktur UI Amomimus (Light & Dark Theme)

Dokumen ini berisi rangkuman struktur User Interface (UI) dari aplikasi Amomimus, mencakup konfigurasi **Light Theme** dan **Dark Theme**, serta detail struktur halaman profil. Rangkuman ini dirancang agar dapat digunakan kembali sebagai *blueprint* untuk pengembangan aplikasi baru (seperti aplikasi absensi).

---

## 🎨 Konfigurasi Tema (Light vs Dark)

Aplikasi Amomimus menggunakan skema warna utama (Primary) **Purple** (`Color(0xff8c72c4)`) untuk Light Mode, dan tambahan warna aksen kontras **Police Line Yellow** (`Color(0xFFFFD700)`) untuk Dark Mode.

Berikut adalah perbandingan properti `ThemeData` antara Light Mode dan Dark Mode:

| Komponen / Properti | Light Theme ☀️ | Dark Theme 🌙 |
| :--- | :--- | :--- |
| **Scaffold Background** | `Colors.white` | `Color(0xff121212)` |
| **Card / Surface Background** | `Colors.white` | `Color(0xff1e1e1e)` |
| **Primary Color** | `Color(0xff8c72c4)` (Purple) | `Color(0xff8c72c4)` (Purple) |
| **Accent / Highlight Color** | N/A | `Color(0xFFFFD700)` (Yellow) |
| **Text Primary** | `Colors.black87` | `Color(0xfff5f5f5)` |
| **Text Secondary** | `Colors.black54` | `Color(0xffb3b3b3)` |
| **Divider Color** | `Colors.grey[300]` | `Color(0xff2d2d2d)` |
| **AppBar Background** | `Colors.white` | `Color(0xff121212)` |
| **AppBar Text/Icon** | `Colors.black87` | `Color(0xfff5f5f5)` |
| **AppBar Title Color** | `Color(0xff8c72c4)` | `Color(0xff8c72c4)` (Atau `Color(0xFFFFD700)` di beberapa screen) |
| **FAB Background** | `Color(0xff8c72c4)` | `Color(0xff8c72c4)` / `Color(0xFFFFD700)` |
| **FAB Foreground** | `Colors.white` | `Colors.black` |
| **BottomAppBar Color** | `Color(0xFFF5F5F5)` | `Color(0xff1e1e1e)` |
| **Drawer Background** | `Colors.white` | `Color(0xff121212)` |
| **ListTile Icon / Text** | `Colors.black54` / `Colors.black87` | `Color(0xffb3b3b3)` / `Color(0xfff5f5f5)` |
| **SnackBar Background** | `Colors.grey[800]` | `Color(0xff1e1e1e)` |

---

### 📦 Dekorasi Kartu (Card Decoration)

Untuk membuat wadah (container/card) yang konsisten dengan gaya Amomimus, gunakan *BoxDecoration* dinamis berikut:

```dart
// Untuk Light Mode
BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: Colors.grey[300]!),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
)

// Untuk Dark Mode
BoxDecoration(
  color: const Color(0xff1e1e1e),
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
)
```

---

## 👤 Detail Struktur UI Halaman Profil (Profile Screen)

Halaman profil (`ProfileScreen`) di Amomimus dirancang dengan struktur layout yang dinamis dan interaktif. Halaman ini membedakan tampilan antara profil diri sendiri (pemilik akun) dan profil orang lain (terkunci/tidak terkunci).

Berikut adalah hirarki komponen di dalam `ProfileScreen`:

1. **Scaffold & AppBar**:
   - Judul AppBar: "Profil" dengan font tebal (`FontWeight.bold`). Warna dinamis (`primaryPurple` pada Light Theme, `policeLineYellow` pada Dark Theme).
   - **Tombol Aksi (Actions)**:
     - 🔍 *Icon Search*: Mengarah ke halaman dokumen/informasi (`FakePdfScreen`).
     - ⚙️ *Icon Settings*: Hanya muncul jika melihat profil sendiri, mengarah ke `SettingsScreen`.
     - ⚠️ *Icon Warning*: Muncul jika melihat profil orang lain untuk melaporkan akun (`ReportDialog`).

2. **Body (SingleChildScrollView > Column)**:
   - **`ProfileHeaderInfo`**: Komponen teratas yang menampilkan avatar, nama anonim, ID pengguna, jenis kelamin (Amo/Ami/Amom), dan status aktif.
   - **Kondisi Profil Terkunci (`isLocked`)**:
     - Jika profil orang lain belum berteman/terkunci:
       - Menampilkan `ProfileIndicatorCard` (metrik profil dasar).
       - Menampilkan `LockedProfileView` (pesan bahwa profil terkunci dengan efek blur).
     - Jika profil sendiri / sudah berteman (terbuka):
       - Menampilkan `ProfileBioSection` (informasi biodata lengkap, preferensi, dll).
       - Menampilkan `ProfileVaultSection` (brankas rahasia pengguna - hanya muncul di profil sendiri).
       - Menampilkan `ProfileIndicatorCard` (metrik performa interaksi).
       - Menampilkan `ProfileRecentResonates` (daftar aktivitas atau postingan terbaru).

3. **FloatingActionButton (FAB)**:
   - Terletak melayang di bagian bawah tengah (`FloatingActionButtonLocation.centerFloat`).
   - Diberi **Micro-Animation** berupa efek pantulan naik-turun secara halus (`_fabAnimation`).
   - Ikon di dalam FAB mewakili gender user (`GenderHelpers.getGenderIcon(user.gender)`).
   - Warna background berubah dinamis: **Yellow** (`policeLineYellow`) saat Dark Theme, dan **Purple** (`primaryPurple`) saat Light Theme.

---

## 📂 Struktur Folder UI Aplikasi Absensi

Berikut adalah rekomendasi adaptasi struktur folder `lib/` (khusus untuk UI: Screens dan Widgets) untuk proyek **Aplikasi Absensi** yang baru.

### `lib/screens/`
Folder ini berisi halaman-halaman utama aplikasi.
- `splash_screen.dart` : Halaman loading awal & cek sesi.
- `login_screen.dart` & `register_screen.dart` : Halaman autentikasi karyawan/siswa.
- `onboarding_screen.dart` : Panduan singkat penggunaan aplikasi absensi.
- `home_screen.dart` : Dashboard utama (statistik absensi hari ini, tombol cepat absen).
- `attendance_screen.dart` : Halaman form absen (pilihan WFH/WFO, foto selfie, koordinat lokasi).
- `history_screen.dart` : Halaman riwayat absensi bulanan/mingguan.
- `profile_screen.dart` : Halaman profil pengguna (menampilkan data diri, jabatan, sisa cuti, dsb).
- `settings_screen.dart` : Pengaturan aplikasi (ubah kata sandi, ganti tema Light/Dark).

### `lib/widgets/`
Folder ini berisi komponen kecil yang bisa digunakan berulang kali.
- **`/forms/`**
  - `custom_input_field.dart` : Field input teks (misalnya untuk alasan izin/sakit).
  - `date_picker_field.dart` : Input pemilihan tanggal cuti.
- **`/buttons/`**
  - `primary_button.dart` : Tombol aksi utama dengan gaya border rounded.
- **`/cards/`**
  - `attendance_history_card.dart` : Menampilkan log absen (Jam masuk, Jam keluar, Status: Tepat Waktu/Terlambat).
  - `stat_card.dart` : Menampilkan ringkasan (contoh: Hadir: 20, Izin: 2, Alfa: 0).
- **`/dialogs/`**
  - `confirmation_dialog.dart` : Dialog konfirmasi sebelum kirim absen.
  - `info_dialog.dart` : Notifikasi berhasil melakukan absensi.
- **`/effects/`**
  - Efek visual (loading shimmer, blur overlay pada dialog sukses).

---

## 🚀 Cara Implementasi di Proyek Baru

Bungkus `MaterialApp` dengan state management (seperti `Provider` or `Bloc`) untuk memantau perubahan tema:

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  // Tema Terang
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    // ... Detail konfigurasi Light Theme di atas
  ),
  // Tema Gelap
  darkTheme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff121212),
      foregroundColor: Color(0xfff5f5f5),
      elevation: 0,
    ),
    // ... Detail konfigurasi Dark Theme di atas
  ),
  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
  home: const SplashScreen(),
)
```
