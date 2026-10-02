import 'package:flutter/material.dart';

import 'profile_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Digit terakhir NIM 8 (Genap) -> Colors.amber[100]
    return MaterialApp(
      title: 'Tugas Layout Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.amber[100],
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: const Text('Profil Praktikan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileCard(
              nama: 'Muhammad Ali Akbar',
              nim: '20240801218',
              hobi: 'Futsal',
              skorAktivitas: 68, // (18 + 50)
            ),
          ],
        ),
      ),
    );
  }
}
