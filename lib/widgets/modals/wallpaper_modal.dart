import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_provider.dart';
import '../photo_image.dart';

class LuminaWallpaperModal extends StatefulWidget {
  const LuminaWallpaperModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LuminaWallpaperModal(),
    );
  }

  @override
  State<LuminaWallpaperModal> createState() => _LuminaWallpaperModalState();
}

class _LuminaWallpaperModalState extends State<LuminaWallpaperModal> {
  String _fitMode = 'Fill';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final photo = provider.activePhoto;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        PhosphorIconsRegular.desktop,
                        size: 20,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set as Windows Wallpaper',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          'Customize high-resolution desktop background placement',
                          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(PhosphorIconsRegular.x, size: 18, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Monitor Mockup Display
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155), width: 4),
              ),
              child: Stack(
                children: [
                  if (photo != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LuminaPhotoWidget(
                          photo: photo,
                          fit: _getBoxFit(_fitMode),
                        ),
                      ),
                    ),
                  // Taskbar Mockup Overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 24,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(PhosphorIconsFill.windowsLogo, size: 12, color: Colors.blue.shade300),
                          const SizedBox(width: 12),
                          const Icon(PhosphorIconsRegular.magnifyingGlass, size: 11, color: Colors.white70),
                          const SizedBox(width: 12),
                          const Icon(PhosphorIconsRegular.folder, size: 11, color: Colors.amber),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Placement Option Radio Group
            const Text(
              'CHOOSE A FIT MODE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: ['Fill', 'Fit', 'Stretch', 'Center', 'Span'].map((mode) {
                final isSelected = _fitMode == mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  selectedColor: const Color(0xFFDBEAFE),
                  backgroundColor: const Color(0xFFF3F4F6),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF374151),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _fitMode = mode);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE5E7EB)),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    provider.showToast('Applied "${photo?.title}" as Windows Wallpaper');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(PhosphorIconsRegular.desktop, size: 16),
                  label: const Text('Set Wallpaper'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxFit _getBoxFit(String mode) {
    switch (mode) {
      case 'Fit':
        return BoxFit.contain;
      case 'Stretch':
        return BoxFit.fill;
      case 'Center':
        return BoxFit.none;
      case 'Fill':
      default:
        return BoxFit.cover;
    }
  }
}
