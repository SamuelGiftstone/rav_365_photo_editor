import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LuminaShortcutsModal extends StatelessWidget {
  const LuminaShortcutsModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LuminaShortcutsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 680,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
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
                        PhosphorIconsRegular.keyboard,
                        size: 20,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keyboard Shortcuts',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          'Master desktop interactions for ultra-fast photo browsing',
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
            const Divider(color: Color(0xFFE5E7EB), height: 1),
            const SizedBox(height: 20),

            // Shortcut Categories Grid
            SizedBox(
              height: 380,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoryHeader('NAVIGATION'),
                          _buildShortcutRow('Next Image', 'Right Arrow'),
                          _buildShortcutRow('Previous Image', 'Left Arrow'),
                          _buildShortcutRow('Start Slideshow', 'Space'),
                          _buildShortcutRow('Fullscreen View', 'F11 / F'),

                          const SizedBox(height: 16),
                          _buildCategoryHeader('VIEW & ZOOM'),
                          _buildShortcutRow('Zoom In', 'Ctrl +'),
                          _buildShortcutRow('Zoom Out', 'Ctrl -'),
                          _buildShortcutRow('Reset Zoom (100%)', 'Ctrl 0'),
                          _buildShortcutRow('Actual Size (1:1)', 'Ctrl 1'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoryHeader('FILE & ACTIONS'),
                          _buildShortcutRow('Open Image File', 'Ctrl O'),
                          _buildShortcutRow('Toggle Favorite', 'F'),
                          _buildShortcutRow('Rate 5 Stars', '5'),
                          _buildShortcutRow('Delete Photo', 'Delete'),

                          const SizedBox(height: 16),
                          _buildCategoryHeader('PHOTOSHOP TOOLS & HISTORY'),
                          _buildShortcutRow('Move / Pan', 'V'),
                          _buildShortcutRow('Marquee Selection', 'M'),
                          _buildShortcutRow('Crop & Straighten', 'C'),
                          _buildShortcutRow('Paint Brush / Airbrush', 'B'),
                          _buildShortcutRow('Spot Healing Brush', 'J'),
                          _buildShortcutRow('Clone Stamp Tool', 'S'),
                          _buildShortcutRow('Eraser Tool', 'E'),
                          _buildShortcutRow('Text Overlay Layer', 'T'),
                          _buildShortcutRow('Eyedropper Sampler', 'I'),
                          _buildShortcutRow('Undo Action', 'Ctrl Z'),
                          _buildShortcutRow('Redo Action', 'Ctrl Y'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE5E7EB), height: 1),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9CA3AF),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildShortcutRow(String label, String keyCombo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              keyCombo,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
