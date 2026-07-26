import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LuminaAboutModal extends StatelessWidget {
  const LuminaAboutModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LuminaAboutModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Accent Box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                PhosphorIconsRegular.aperture,
                size: 32,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Lumina Photo Viewer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Professional Creative Software for Windows',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),

            // System Specs Grid
            _buildSpecRow('Version', 'v1.0.0 (Flutter Desktop Build 2026.07)'),
            _buildSpecRow('Target Platform', 'Windows 11 / Windows 10 (x64)'),
            _buildSpecRow('Graphics Pipeline', 'Skia / Impulse GPU Acceleration'),
            _buildSpecRow('Color Management', 'ICC Profile Engine (Display P3, sRGB)'),
            _buildSpecRow('Window Framework', 'bitsdojo_window + Provider'),

            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE5E7EB)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '© 2026 Lumina Creative Technologies',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }
}
