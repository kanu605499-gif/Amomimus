# Struktur UI Amomimus (Khusus Light Theme)

Dokumen ini berisi rangkuman struktur User Interface (UI) dari aplikasi Amomimus, dikhususkan pada penggunaan **Light Theme**. Struktur dan konfigurasi tema ini dirancang agar dapat digunakan kembali sebagai *blueprint* atau kerangka dasar untuk pengembangan aplikasi baru (seperti aplikasi absensi).

---

## 🎨 Konfigurasi Tema (Light Theme)

Warna utama (Primary Color) yang digunakan pada aplikasi adalah **Purple** (`Color(0xff8c72c4)`). Berikut adalah rincian `ThemeData` untuk Light Mode yang dapat langsung diimplementasikan ke aplikasi baru:

### 1. Warna Dasar & Scaffold
- **Scaffold Background**: `Colors.white`
- **Surface / Card Background**: `Colors.white`
- **Primary Color**: `Color(0xff8c72c4)` (Ungu Utama)
- **Shadow Color**: `Colors.grey.withOpacity(0.2)`
- **Blur Overlay**: `Colors.white.withOpacity(0.75)`

### 2. Tipografi (TextTheme)
- **Title Large**: `Colors.black87` (FontWeight: bold)
- **Body Large**: `Colors.black87`
- **Body Medium**: `Colors.black54`

### 3. Komponen Tema
- **AppBarTheme**:
  - Background: `Colors.white`
  - Icon: `Colors.black87`
  - Title Text: `Color(0xff8c72c4)` (Size: 20, Bold)
  - Elevation: 0, SurfaceTintColor: Transparent
- **FloatingActionButtonTheme**:
  - Background: `Color(0xff8c72c4)`
  - Foreground (Icon): `Colors.white`
  - Shape: CircleBorder, Elevation: 6
- **BottomAppBarTheme**:
  - Background: `Color(0xFFF5F5F5)`
  - Elevation: 0
- **DrawerTheme**:
  - Background: `Colors.white`
  - Elevation: 16
- **DividerTheme**:
  - Color: `Colors.grey[300]`
  - Thickness: 1, Space: 1
- **ListTileTheme**:
  - Icon Color: `Colors.black54`
  - Text Color: `Colors.black87`
  - Gap: 12
- **PopupMenuTheme**:
  - Background: `Colors.white`
  - Radius: 12
  - Text: `Colors.black87` (Bold)
- **SnackBarTheme**:
  - Background: `Colors.grey[800]`
  - Text: `Colors.white`
  - Behavior: Floating, Radius: 16

### 4. Dekorasi Kartu (Card Decoration)
Untuk membuat wadah (container/card) yang konsisten dengan gaya Amomimus, gunakan *BoxDecoration* berikut:
```dart
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
```

---

## 📂 Struktur Folder UI

Berikut adalah rekomendasi adaptasi struktur folder `lib/` (khusus untuk UI: Screens dan Widgets) yang terinspirasi dari arsitektur Amomimus untuk digunakan pada **Aplikasi Absensi** yang baru.

### `lib/screens/`
Folder ini berisi tampilan utama dari setiap halaman aplikasi.
- `splash_screen.dart` : Halaman awal saat aplikasi dibuka.
- `login_screen.dart` & `register_screen.dart` : Autentikasi pengguna.
- `onboarding_screen.dart` : Penjelasan awal fitur aplikasi absensi.
- `home_screen.dart` : Dashboard utama (terinspirasi dari `feed_screen.dart`).
- `attendance_screen.dart` : Halaman khusus untuk melakukan absen masuk/keluar (Form).
- `history_screen.dart` : Riwayat absensi pengguna.
- `profile_screen.dart` : Halaman profil pengguna (terinspirasi dari `profile_screen.dart`).
- `settings_screen.dart` : Pengaturan aplikasi.

### `lib/widgets/`
Folder ini berisi komponen UI yang bisa digunakan kembali *(reusable components)*.
- **`/forms/`** *(Adaptasi dari input dialog)*
  - `custom_input_field.dart` : TextField khusus untuk input data absensi/catatan.
  - `date_picker_field.dart` : Widget untuk memilih tanggal.
- **`/buttons/`**
  - `primary_button.dart` : Tombol aksi utama (seperti tombol "Absen Sekarang").
- **`/cards/`**
  - `attendance_history_card.dart` : Kartu yang menampilkan rincian tiap riwayat absensi.
  - `stat_card.dart` : Kartu untuk dashboard (menampilkan jumlah hadir/izin).
- **`/dialogs/`**
  - `confirmation_dialog.dart` : Dialog konfirmasi (mirip `report_dialog.dart`).
  - `info_dialog.dart` : Menampilkan informasi sukses/gagal absen.
- **`/effects/`**
  - Efek UI tambahan jika diperlukan (misal: background atau animasi loading sederhana).
- `update_checker.dart` : Widget pengecek versi aplikasi.

---

## 🚀 Implementasi Awal pada Aplikasi Baru

Untuk memakai tema ini pada fungsi `main.dart` aplikasi absensi baru Anda:

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    
    // Gunakan konfigurasi TextTheme, AppBarTheme, dll sesuai rincian di atas
    
  ),
  home: const SplashScreen(),
)
```

**Panduan Lanjutan:**
1. Anda cukup menyalin blok *Light Mode* yang ada pada metode `currentThemeData` dari file `amomimusdark.dart` secara utuh.
2. Karena hanya menggunakan versi Light, tidak perlu menggunakan `ChangeNotifier` untuk *toggle* mode gelap-terang. Cukup berikan `ThemeData` secara konstan (statis) ke `MaterialApp`.
