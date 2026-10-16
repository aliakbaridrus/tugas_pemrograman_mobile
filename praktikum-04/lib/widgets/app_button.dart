import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? url;
  final double height; // Ditambahkan sesuai ketentuan
  final double borderRadius; // Ditambahkan sesuai ketentuan

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.url,
    required this.height,
    required this.borderRadius,
  });

  Future<void> _handlePressed() async {
    if (onPressed != null) {
      onPressed!();
      return;
    }
    if (url != null) {
      final Uri uri = Uri.parse(url!);
      final bool success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success) {
        debugPrint("Gagal Membuka Link");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height, // Menerapkan tinggi tombol berdasarkan NIM
      child: ElevatedButton(
        onPressed: (onPressed != null || url != null) ? _handlePressed : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Menerapkan radius berdasarkan NIM
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: 8),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}