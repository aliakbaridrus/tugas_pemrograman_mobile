import 'package:flutter/material.dart';

import 'profile_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String nimPraktikan = '20240801218';
  final String namaPraktikan = 'Muhammad Ali Akbar';
  final String hobiPraktikan = 'Futsal';

  @override
  Widget build(BuildContext context) {
    // Digit terakhir NIM 20240801218 adalah 8 (Genap) -> Colors.amber[100]
    final int digitTerakhir = int.parse(nimPraktikan[nimPraktikan.length - 1]);
    final bool isGanjil = digitTerakhir % 2 != 0;

    final Color backgroundColor = isGanjil
        ? (Colors.tealAccent[100] ?? Colors.tealAccent)
        : (Colors.amber[100] ?? Colors.amber);

    return MaterialApp(
      title: 'Tugas Layout Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      home: HomePage(
        nim: nimPraktikan,
        nama: namaPraktikan,
        hobi: hobiPraktikan,
        bgColor: backgroundColor,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String nim;
  final String nama;
  final String hobi;
  final Color bgColor;

  const HomePage({
    super.key,
    required this.nim,
    required this.nama,
    required this.hobi,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    // Formula Skor Aktivitas: (2 digit terakhir NIM) + 50 = 18 + 50 = 68
    final int duaDigitTerakhir = int.parse(nim.substring(nim.length - 2));
    final int hitungSkorAktivitas = duaDigitTerakhir + 50;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Profil Praktikan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileCard(
              nama: nama,
              nim: nim,
              hobi: hobi,
              skorAktivitas: hitungSkorAktivitas,
            ),
          ],
        ),
      ),
    );
  }
}
