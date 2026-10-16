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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
  final _formKey = GlobalKey<FormState>();

  // 5 Controller sesuai instruksi terbaru
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tglMasukController = TextEditingController();
  final TextEditingController _tglKeluarController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  bool _isLoading = false;

  Future<void> _simpanBarang() async {
    // 1. Jalankan semua validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Ambil data input dan konversikan
      final String namaBarang = _namaController.text.trim();
      final String tglMasuk = _tglMasukController.text.trim();
      final String tglKeluar = _tglKeluarController.text.trim();
      final int kodeBarang = int.parse(_kodeController.text.trim());
      final int jumlahStok = int.parse(_stokController.text.trim());

      // 3. Simpan data ke Firestore (collection: stok_barang)
      await FirebaseFirestore.instance.collection('stok_barang').add({
        'nama_barang': namaBarang,
        'tanggal_masuk': tglMasuk,
        'tanggal_keluar': tglKeluar,
        'kode_barang': kodeBarang, // Integer (Number)
        'jumlah_stok': jumlahStok, // Integer (Number)
        'waktu': FieldValue.serverTimestamp(),
      });

      // 4. Kosongkan seluruh field input setelah sukses
      _namaController.clear();
      _tglMasukController.clear();
      _tglKeluarController.clear();
      _kodeController.clear();
      _stokController.clear();

      // 5. Tampilkan notifikasi keberhasilan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data barang berhasil disimpan ke Firebase!'),
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
            content: Text('Gagal menyimpan data: $e'),
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
    _tglMasukController.dispose();
    _tglKeluarController.dispose();
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
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Field 1: Nama Barang (Wajib menyertakan inisial M)
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Barang (Awali dengan Inisial M)',
                          hintText: 'Contoh: M - Laptop Asus',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama barang wajib diisi!';
                          }
                          // Validasi harus mengandung inisial M (dari Muhammad)
                          if (!value.trim().toUpperCase().startsWith('M')) {
                            return 'Nama barang harus diawali dengan inisial M!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Field 2: Tanggal Masuk
                      TextFormField(
                        controller: _tglMasukController,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Masuk Barang',
                          hintText: 'Contoh: 16-10-2026',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Tanggal masuk wajib diisi!' : null,
                      ),
                      const SizedBox(height: 16),

                      // Field 3: Tanggal Keluar
                      TextFormField(
                        controller: _tglKeluarController,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Keluar Barang',
                          hintText: 'Contoh: 18-10-2026',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Tanggal keluar wajib diisi!' : null,
                      ),
                      const SizedBox(height: 16),

                      // Field 4: Kode Barang (Validasi minimal 6 angka & akhiran 18)
                      TextFormField(
                        controller: _kodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Kode Barang (Min 6 angka, Akhiran 18)',
                          hintText: 'Contoh: 123418',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kode barang wajib diisi!';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'Kode barang harus berupa bilangan bulat!';
                          }
                          if (value.trim().length < 6) {
                            return 'Kode barang minimal 6 angka!';
                          }
                          if (!value.trim().endsWith('18')) {
                            return 'Kode barang harus diakhiri dengan angka 18 (NIM Anda)!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Field 5: Jumlah Stok
                      TextFormField(
                        controller: _stokController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Stok',
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
                            return 'Jumlah stok tidak boleh negatif!';
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
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}