import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../models/photo.dart';
import '../providers/photo_provider.dart';
import 'modals/export_modal.dart';
import 'modals/slideshow_overlay.dart';

class LuminaToolbar extends StatelessWidget {
  const LuminaToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final activeTool = provider.activeTool;

    return Container(
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF323232),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Active Tool Icon Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFF424242)),
              ),
              child: Row(
                children: [
                  Icon(_getToolIcon(activeTool), size: 14, color: const Color(0xFF00A2ED)),
                  const SizedBox(width: 6),
                  Text(
                    _getToolName(activeTool),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
            ),

            _divider(),

            // Dynamic Contextual Tool Controls
            _buildContextualToolControls(context, provider, activeTool),

            _divider(),

            // View Mode & Zoom Strip on Right
            _buildIconButton(
              icon: PhosphorIconsRegular.image,
              tooltip: 'Single View (1)',
              isActive: provider.viewMode == ViewMode.single,
              onPressed: () => provider.setViewMode(ViewMode.single),
            ),
            _buildIconButton(
              icon: PhosphorIconsRegular.squaresFour,
              tooltip: 'Grid Gallery (2)',
              isActive: provider.viewMode == ViewMode.grid,
              onPressed: () => provider.setViewMode(ViewMode.grid),
            ),
            _buildIconButton(
              icon: PhosphorIconsRegular.sliders,
              tooltip: 'Studio Canvas Edit Mode (3)',
              isActive: provider.viewMode == ViewMode.edit,
              onPressed: () => provider.setViewMode(ViewMode.edit),
            ),
            _buildIconButton(
              icon: PhosphorIconsRegular.columns,
              tooltip: 'Compare View (4)',
              isActive: provider.viewMode == ViewMode.compare,
              onPressed: () => provider.setViewMode(ViewMode.compare),
            ),

            _divider(),

            // Zoom %
            Text(
              '${(provider.zoom * 100).round()}%',
              style: const TextStyle(fontSize: 10, color: Color(0xFF00A2ED), fontFamily: 'monospace', fontWeight: FontWeight.bold),
            ),
            _buildIconButton(
              icon: PhosphorIconsRegular.magnifyingGlassMinus,
              tooltip: 'Zoom Out',
              onPressed: () => provider.setZoom(provider.zoom * 0.8),
            ),
            _buildIconButton(
              icon: PhosphorIconsRegular.magnifyingGlassPlus,
              tooltip: 'Zoom In',
              onPressed: () => provider.setZoom(provider.zoom * 1.25),
            ),

            _divider(),

            // Export & Slideshow
            ElevatedButton.icon(
              onPressed: () => LuminaExportModal.show(context),
              icon: const Icon(PhosphorIconsRegular.downloadSimple, size: 12, color: Colors.white),
              label: const Text('Export', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0078D4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () => LuminaSlideshowOverlay.show(context),
              icon: const Icon(PhosphorIconsRegular.playCircle, size: 15, color: Colors.white70),
              tooltip: 'Slideshow',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualToolControls(BuildContext context, PhotoProvider provider, PhotoshopTool tool) {
    final adj = provider.currentAdjustments;

    switch (tool) {
      case PhotoshopTool.brush:
      case PhotoshopTool.healing:
      case PhotoshopTool.clone:
      case PhotoshopTool.eraser:
        return Row(
          children: [
            _buildLabel('Size:'),
            SizedBox(
              width: 90,
              child: Slider(
                value: provider.brushSize,
                min: 2,
                max: 100,
                activeColor: const Color(0xFF00A2ED),
                inactiveColor: const Color(0xFF424242),
                onChanged: (v) => provider.setBrushSize(v),
              ),
            ),
            Text('${provider.brushSize.round()}px', style: const TextStyle(fontSize: 10, color: Colors.white70)),
            const SizedBox(width: 10),
            _buildLabel('Opacity:'),
            SizedBox(
              width: 80,
              child: Slider(
                value: provider.brushOpacity,
                min: 0.1,
                max: 1.0,
                activeColor: const Color(0xFF00A2ED),
                inactiveColor: const Color(0xFF424242),
                onChanged: (v) => provider.setBrushOpacity(v),
              ),
            ),
            Text('${(provider.brushOpacity * 100).round()}%', style: const TextStyle(fontSize: 10, color: Colors.white70)),
            const SizedBox(width: 10),
            _buildLabel('Mode:'),
            _buildSmallDropdown(['Normal', 'Multiply', 'Screen', 'Overlay', 'Darken', 'Lighten'], 'Normal', (v) {}),
          ],
        );

      case PhotoshopTool.crop:
        return Row(
          children: [
            _buildLabel('Ratio:'),
            _buildSmallDropdown(['Original', '1:1 Square', '16:9 Screen', '4:5 Portrait', '2:3 Classic'], provider.cropAspectRatio, (v) {
              if (v != null) provider.setCropAspectRatio(v);
            }),
            const SizedBox(width: 10),
            _buildLabel('Straighten:'),
            SizedBox(
              width: 90,
              child: Slider(
                value: adj.straightenAngle,
                min: -45,
                max: 45,
                activeColor: const Color(0xFF00A2ED),
                inactiveColor: const Color(0xFF424242),
                onChanged: (v) {
                  adj.straightenAngle = v;
                  provider.updateAdjustments(adj);
                },
              ),
            ),
            Text('${adj.straightenAngle.round()}°', style: const TextStyle(fontSize: 10, color: Colors.white70)),
          ],
        );

      case PhotoshopTool.text:
        return Row(
          children: [
            _buildLabel('Font:'),
            _buildSmallDropdown(['Inter', 'Roboto', 'Arial', 'Times New Roman', 'Courier'], 'Inter', (v) {}),
            const SizedBox(width: 10),
            _buildLabel('Size:'),
            _buildSmallDropdown(['12 pt', '18 pt', '24 pt', '36 pt', '48 pt', '72 pt'], '24 pt', (v) {}),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () => provider.addTextLayer('Photoshop Text'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A2ED)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+ Add Text', style: TextStyle(fontSize: 10, color: Color(0xFF00A2ED))),
            ),
          ],
        );

      case PhotoshopTool.eyedropper:
        return Row(
          children: [
            _buildLabel('Sample Size:'),
            _buildSmallDropdown(['Point Sample', '3x3 Average', '5x5 Average', '11x11 Average'], 'Point Sample', (v) {}),
            const SizedBox(width: 12),
            _buildLabel('Sampled Color:'),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: provider.sampledColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54),
              ),
            ),
          ],
        );

      case PhotoshopTool.marquee:
      case PhotoshopTool.move:
      default:
        return Row(
          children: [
            _buildLabel('Feather:'),
            const Text('0 px', style: TextStyle(fontSize: 10, color: Colors.white70)),
            const SizedBox(width: 14),
            OutlinedButton(
              onPressed: () => provider.showToast('AI Subject Selected'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF555555)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Select Subject', style: TextStyle(fontSize: 10, color: Colors.white70)),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => provider.showToast('Select and Mask Panel Opened'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF555555)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Select and Mask...', style: TextStyle(fontSize: 10, color: Colors.white70)),
            ),
          ],
        );
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Color(0xFF999999), fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSmallDropdown(List<String> items, String current, ValueChanged<String?> onChanged) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF424242)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(current) ? current : items.first,
          dropdownColor: const Color(0xFF2B2B2B),
          style: const TextStyle(color: Colors.white, fontSize: 10),
          isDense: true,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 14,
        color: isActive ? const Color(0xFF00A2ED) : const Color(0xFFCCCCCC),
      ),
      tooltip: tooltip,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFF424242),
    );
  }

  IconData _getToolIcon(PhotoshopTool tool) {
    switch (tool) {
      case PhotoshopTool.move: return PhosphorIconsRegular.arrowsOutCardinal;
      case PhotoshopTool.marquee: return PhosphorIconsRegular.selection;
      case PhotoshopTool.crop: return PhosphorIconsRegular.crop;
      case PhotoshopTool.brush: return PhosphorIconsRegular.paintBrush;
      case PhotoshopTool.healing: return PhosphorIconsRegular.firstAid;
      case PhotoshopTool.clone: return PhosphorIconsRegular.copy;
      case PhotoshopTool.eraser: return PhosphorIconsRegular.eraser;
      case PhotoshopTool.text: return PhosphorIconsRegular.textT;
      case PhotoshopTool.eyedropper: return PhosphorIconsRegular.eyedropper;
      case PhotoshopTool.gradient: return PhosphorIconsRegular.gradient;
      case PhotoshopTool.filter: return PhosphorIconsRegular.magicWand;
    }
  }

  String _getToolName(PhotoshopTool tool) {
    switch (tool) {
      case PhotoshopTool.move: return 'Move Tool (V)';
      case PhotoshopTool.marquee: return 'Marquee Tool (M)';
      case PhotoshopTool.crop: return 'Crop Tool (C)';
      case PhotoshopTool.brush: return 'Brush Tool (B)';
      case PhotoshopTool.healing: return 'Spot Healing (J)';
      case PhotoshopTool.clone: return 'Clone Stamp (S)';
      case PhotoshopTool.eraser: return 'Eraser Tool (E)';
      case PhotoshopTool.text: return 'Text Tool (T)';
      case PhotoshopTool.eyedropper: return 'Eyedropper (I)';
      case PhotoshopTool.gradient: return 'Gradient (G)';
      case PhotoshopTool.filter: return 'Color Presets (F)';
    }
  }
}
