import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String hobi;
  final int skorAktivitas;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.hobi,
    required this.skorAktivitas,
  });

  @override
  Widget build(BuildContext context) {
    // Ekstraksi digit NIM untuk formula otomatis (NIM: 20240801218)
    final String cleanNim = nim.trim();
    final int digitTerakhir = cleanNim.isNotEmpty
        ? int.tryParse(cleanNim[cleanNim.length - 1]) ?? 0
        : 0;
    final int digitKe2Belakang = cleanNim.length >= 2
        ? int.tryParse(cleanNim[cleanNim.length - 2]) ?? 0
        : 0;

    // Perhitungan Formula Sesuai Ketentuan Modul
    // Lebar Kartu    : 320.0 + (1 * 5)   = 325.0
    // Sudut Lengkung : 12.0 + (8 * 1.5)  = 24.0
    // Ukuran Logo    : 60.0 + (8 * 2)    = 76.0
    // Jarak Pemisah  : 15.0 + 8          = 23.0
    final double cardWidth = 320.0 + (digitKe2Belakang * 5.0);
    final double cardRadius = 12.0 + (digitTerakhir * 1.5);
    final double logoSize = 60.0 + (digitTerakhir * 2.0);
    final double spaceWidth = 15.0 + digitTerakhir;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header Kartu (Horizontal - Row)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sisi Kiri: Logo Flutter berbingkai lengkung
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey.shade100,
                ),
                child: FlutterLogo(size: logoSize),
              ),
              SizedBox(width: spaceWidth),
              // Sisi Kanan: Judul dan Nama Praktikan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kartu Praktikan',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          // Pemisah
          const Divider(thickness: 1.5),
          const SizedBox(height: 12.0),
          // Bagian Detail Identitas (Vertikal - Column)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('NIM', nim),
              const SizedBox(height: 8.0),
              _buildDetailRow('Hobi', hobi),
              const SizedBox(height: 8.0),
              _buildDetailRow('Skor Aktivitas', skorAktivitas.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}