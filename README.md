# Quiz Agama

Aplikasi kuis **Pendidikan Agama Islam (PAI)** lintas platform yang dibangun dengan **Flutter**, arsitektur **MVVM**, dan **Firebase** sebagai backend.

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)

## Tampilan Aplikasi

<!-- Seret screenshot aplikasi ke baris ini saat mengedit README di GitHub -->
<img width="1365" height="758" alt="Screenshot 2026-10-30 102948" src="https://github.com/user-attachments/assets/71c5f0a4-aa27-43f8-9afb-4443a4dfb2cd" />
<img width="1365" height="767" alt="Screenshot 2026-10-30 102741" src="https://github.com/user-attachments/assets/659ac9df-8696-41c4-9764-baec91cb4c13" />
<img width="1365" height="728" alt="Screenshot 2026-10-30 102848" src="https://github.com/user-attachments/assets/48a8019d-86ad-4667-936f-88a52c31a78b" />


## Tentang Proyek

Quiz Agama membantu pelajar berlatih materi Pendidikan Agama Islam lewat kuis di perangkat mobile. Proyek ini juga menjadi contoh penerapan arsitektur MVVM pada aplikasi Flutter yang terhubung ke layanan Firebase.

## Teknologi

| Komponen | Teknologi |
|---|---|
| Framework | Flutter |
| Bahasa | Dart |
| Arsitektur | MVVM (Model - View - ViewModel) |
| Backend | Firebase |

## Arsitektur MVVM

Kode dipisahkan menjadi tiga lapisan agar mudah dirawat dan diuji:

- **Model**: struktur data dan akses ke sumber data (Firebase).
- **View**: tampilan antarmuka yang hanya menampilkan data dan meneruskan aksi pengguna.
- **ViewModel**: logika presentasi dan status layar; menjembatani View dengan Model.

Dengan pemisahan ini, perubahan tampilan tidak mengganggu logika, dan logika dapat diuji tanpa antarmuka.

## Platform yang Didukung

Proyek ini memuat konfigurasi untuk **Android, iOS, Web, Windows, macOS, dan Linux** dari satu basis kode.

## Cara Menjalankan

### Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi stabil terbaru)
- Android Studio atau VS Code dengan ekstensi Flutter
- Akun Firebase

### Langkah

```bash
git clone https://github.com/wahyurizqi363-collab/quiz-agama.git
cd quiz-agama
flutter pub get
flutter run
```

Pilih perangkat target saat diminta (emulator Android, Chrome, atau Windows).

### Konfigurasi Firebase

Aplikasi memakai Firebase. Jika build gagal karena konfigurasi Firebase belum ada, hubungkan proyek ini ke proyek Firebase milik Anda:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Berkas konfigurasi pribadi (misalnya `google-services.json`) sebaiknya tidak diunggah ke repository publik.

## Struktur Repositori

```
quiz-agama/
├── lib/          # kode sumber Dart (Model, View, ViewModel)
├── android/      # proyek Android
├── ios/          # proyek iOS
├── web/          # target web
├── windows/      # target Windows
├── macos/        # target macOS
├── linux/        # target Linux
├── pubspec.yaml  # dependensi dan metadata Flutter
└── firebase.json # konfigurasi Firebase
```

## Penulis

**Muhammad Wahyu Rizqi Pratama, S.Kom., M.I.T**
Dosen Teknik Informatika, Universitas Islam Blitar

- GitHub: [wahyurizqi363-collab](https://github.com/wahyurizqi363-collab)
- Email: wahyurizqi363@gmail.com
