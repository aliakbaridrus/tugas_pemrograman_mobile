import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pencatatan Stok Barang',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const StokBarangPage(),
    );
  }
}

class StokBarangPage extends StatefulWidget {
  const StokBarangPage({super.key});

  @override
  State<StokBarangPage> createState() => _StokBarangPageState();
}

class _StokBarangPageState extends State<StokBarangPage> {
  // Global key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil teks input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  bool _isLoading = false;

  // Fungsi untuk menyimpan data barang ke Firebase Cloud Firestore
  Future<void> _simpanBarang() async {
    // 1. Validasi seluruh field form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Ambil dan konversikan input pengguna menjadi integer
      final String namaBarang = _namaController.text.trim();
      final int kodeBarang = int.parse(_kodeController.text.trim());
      final int jumlahStok = int.parse(_stokController.text.trim());

      // 3. Simpan data ke Firestore dalam collection 'stok_barang'
      await FirebaseFirestore.instance.collection('stok_barang').add({
        'nama_barang': namaBarang,
        'kode_barang': kodeBarang, // Tersimpan sebagai Integer (Number)
        'jumlah_stok': jumlahStok, // Tersimpan sebagai Integer (Number)
        'waktu': FieldValue.serverTimestamp(), // Timestamp dari server Firebase
      });

      // 4. Bersihkan seluruh field input
      _namaController.clear();
      _kodeController.clear();
      _stokController.clear();

      // 5. Tampilkan notifikasi keberhasilan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Data barang berhasil disimpan ke Firebase!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // 6. Tampilkan pesan kesalahan jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Gagal menyimpan: $e')),
              ],
            ),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kodeController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatatan Stok Barang'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Field 1: Nama Barang
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Barang',
                          hintText: 'Contoh: Buku Tulis / Mouse Gaming',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama barang wajib diisi!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Field 2: Kode Barang (Integer & Numeric Keyboard)
                      TextFormField(
                        controller: _kodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Kode Barang',
                          hintText: 'Contoh: 1001',
                          prefixIcon: Icon(Icons.qr_code),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kode barang wajib diisi!';
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null) {
                            return 'Kode barang harus berupa bilangan bulat!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Field 3: Jumlah Stok (Integer, Non-negatif, Numeric Keyboard)
                      TextFormField(
                        controller: _stokController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Stok',
                          hintText: 'Contoh: 25',
                          prefixIcon: Icon(Icons.format_list_numbered),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Jumlah stok wajib diisi!';
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null) {
                            return 'Jumlah stok harus berupa angka!';
                          }
                          if (parsed < 0) {
                            return 'Jumlah stok tidak boleh bernilai negatif!';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan Barang
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _simpanBarang,
                icon: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  _isLoading ? 'Menyimpan...' : 'Simpan Barang',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}