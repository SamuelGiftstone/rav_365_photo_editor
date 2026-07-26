import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../models/photo.dart';
import '../providers/photo_provider.dart';

class LuminaPhotoshopToolsBar extends StatelessWidget {
  const LuminaPhotoshopToolsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final activeTool = provider.activeTool;

    return Container(
      width: 36,
      decoration: const BoxDecoration(
        color: Color(0xFF262626), // Photoshop dark toolbar background
        border: Border(
          right: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),

          // Tools List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.move,
                  icon: PhosphorIconsRegular.arrowsOutCardinal,
                  tooltip: 'Move Tool (V)',
                  isActive: activeTool == PhotoshopTool.move,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.marquee,
                  icon: PhosphorIconsRegular.selection,
                  tooltip: 'Rectangular Marquee Tool (M)',
                  isActive: activeTool == PhotoshopTool.marquee,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.crop,
                  icon: PhosphorIconsRegular.crop,
                  tooltip: 'Crop Tool (C)',
                  isActive: activeTool == PhotoshopTool.crop,
                ),
                const Divider(color: Color(0xFF383838), height: 8, indent: 4, endIndent: 4),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.eyedropper,
                  icon: PhosphorIconsRegular.eyedropper,
                  tooltip: 'Eyedropper Tool (I)',
                  isActive: activeTool == PhotoshopTool.eyedropper,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.healing,
                  icon: PhosphorIconsRegular.firstAid,
                  tooltip: 'Spot Healing Brush Tool (J)',
                  isActive: activeTool == PhotoshopTool.healing,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.brush,
                  icon: PhosphorIconsRegular.paintBrush,
                  tooltip: 'Brush Tool (B)',
                  isActive: activeTool == PhotoshopTool.brush,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.clone,
                  icon: PhosphorIconsRegular.copy,
                  tooltip: 'Clone Stamp Tool (S)',
                  isActive: activeTool == PhotoshopTool.clone,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.eraser,
                  icon: PhosphorIconsRegular.eraser,
                  tooltip: 'Eraser Tool (E)',
                  isActive: activeTool == PhotoshopTool.eraser,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.gradient,
                  icon: PhosphorIconsRegular.gradient,
                  tooltip: 'Gradient Tool (G)',
                  isActive: activeTool == PhotoshopTool.gradient,
                ),
                const Divider(color: Color(0xFF383838), height: 8, indent: 4, endIndent: 4),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.text,
                  icon: PhosphorIconsRegular.textT,
                  tooltip: 'Horizontal Type Tool (T)',
                  isActive: activeTool == PhotoshopTool.text,
                ),
                _buildToolButton(
                  context: context,
                  provider: provider,
                  tool: PhotoshopTool.filter,
                  icon: PhosphorIconsRegular.magicWand,
                  tooltip: 'Color Filter Preset (F)',
                  isActive: activeTool == PhotoshopTool.filter,
                ),
              ],
            ),
          ),

          // Foreground / Background Color Swatch Stack
          const Divider(color: Color(0xFF383838), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Stack(
                children: [
                  // Background Swatch
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white60, width: 1),
                      ),
                    ),
                  ),
                  // Foreground Swatch (Active Brush Color)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _showColorPickerDialog(context, provider),
                      child: Tooltip(
                        message: 'Set Foreground Color',
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: provider.brushColor,
                            border: Border.all(color: Colors.white, width: 1),
                            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required BuildContext context,
    required PhotoProvider provider,
    required PhotoshopTool tool,
    required IconData icon,
    required String tooltip,
    required bool isActive,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => provider.setActiveTool(tool),
        child: Container(
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF383838) : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: isActive ? const Color(0xFF00A2ED) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 15,
              color: isActive ? const Color(0xFF00A2ED) : const Color(0xFFCCCCCC),
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, PhotoProvider provider) {
    final colors = [
      const Color(0xFF00A2ED),
      Colors.white,
      Colors.black,
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text('Color Picker (Foreground Color)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((c) {
            return GestureDetector(
              onTap: () {
                provider.setBrushColor(c);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white38, width: 1.5),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
