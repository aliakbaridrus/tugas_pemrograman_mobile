import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Variabel d dari digit terakhir NIM (20240801218 -> 8)
    final int d = 8;

    // Perhitungan ukuran berdasarkan NIM (d = 8)
    final double cardPadding = 16.0 + d;      // 24.0 px
    final double cardRadius = 8.0 + d;        // 16.0 px
    final double buttonHeight = 40.0 + d;     // 48.0 px
    final double buttonRadius = 4.0 + d;      // 12.0 px
    final double avatarSize = 40.0 + (2 * d); // 56.0 px
    final double nameNimSpacing = 8.0 + d;    // 16.0 px

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile Card'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Foto profil / ikon avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(avatarSize / 2),
                    child: Container(
                      width: avatarSize,
                      height: avatarSize,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 30),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Nama lengkap (menggunakan Text biasa tanpa style)
                  const Text('Muhammad Ali Akbar'),
                  SizedBox(height: nameNimSpacing),

                  // 3. NIM
                  const Text('20240801218'),
                  const SizedBox(height: 8),

                  // 4. Program studi
                  const Text('Teknik Informatika'),
                  const SizedBox(height: 8),

                  // 5. Deskripsi singkat tentang diri sendiri
                  const Text('Mahasiswa aktif Informatika Universitas Esa Unggul yang tertarik pada pengembangan perangkat lunak.'),
                  const SizedBox(height: 16),

                  // 6. Tombol Kunjungi GitHub Saya
                  AppButton(
                    label: 'Kunjungi GitHub Saya',
                    icon: Icons.code,
                    url: 'https://github.com/muhammadaliakbar', // Sesuaikan username GitHub Anda jika perlu
                    height: buttonHeight,
                    borderRadius: buttonRadius,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}