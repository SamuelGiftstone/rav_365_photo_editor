import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import 'histogram_painter.dart';
import 'edit_panel.dart';
import 'layers_history_panel.dart';

class LuminaRightSidebar extends StatefulWidget {
  const LuminaRightSidebar({Key? key}) : super(key: key);

  @override
  State<LuminaRightSidebar> createState() => _LuminaRightSidebarState();
}

class _LuminaRightSidebarState extends State<LuminaRightSidebar> {
  int _activeTabIndex = 0; // 0: Adjustments, 1: Layers & History, 2: Info & EXIF

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final photo = provider.activePhoto;

    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: Color(0xFF262626),
        border: Border(
          left: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          // Photoshop Right Panel Header Tabs
          Container(
            height: 30,
            color: const Color(0xFF323232),
            child: Row(
              children: [
                _buildTabButton(0, 'Adjustments', PhosphorIconsRegular.sliders),
                _buildTabButton(1, 'Layers', PhosphorIconsRegular.stack),
                _buildTabButton(2, 'Info & EXIF', PhosphorIconsRegular.info),
                const Spacer(),
                InkWell(
                  onTap: () => provider.toggleRightSidebar(),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(PhosphorIconsRegular.caretRight, size: 14, color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),

          // Active Panel Content
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                const LuminaEditPanel(),
                const LuminaLayersHistoryPanel(),
                _buildExifInfoPanel(context, provider, photo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isActive = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF262626) : const Color(0xFF323232),
          border: Border(
            top: BorderSide(color: isActive ? const Color(0xFF00A2ED) : Colors.transparent, width: 2.0),
            right: const BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: isActive ? const Color(0xFF00A2ED) : const Color(0xFF888888)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExifInfoPanel(BuildContext context, PhotoProvider provider, dynamic photo) {
    if (photo == null) {
      return const Center(
        child: Text('No active image selected', style: TextStyle(color: Color(0xFF888888), fontSize: 11)),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // RGB Histogram
        _buildHeader('RGB LUMINANCE HISTOGRAM'),
        const SizedBox(height: 6),
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF383838)),
          ),
          padding: const EdgeInsets.all(6),
          child: CustomPaint(
            size: Size.infinite,
            painter: HistogramPainter(
              red: photo.histogramRed,
              green: photo.histogramGreen,
              blue: photo.histogramBlue,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Color Palette
        _buildHeader('SWATCH PALETTE'),
        const SizedBox(height: 6),
        Row(
          children: photo.metadata.dominantColors.map<Widget>((hex) {
            final color = Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
            return Expanded(
              child: GestureDetector(
                onTap: () => provider.setSampledColor(color),
                child: Container(
                  height: 22,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.white24),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // File Metadata
        _buildHeader('FILE METADATA'),
        const SizedBox(height: 6),
        _buildMetaRow('Filename', photo.metadata.filename),
        _buildMetaRow('Dimensions', '${photo.metadata.width} × ${photo.metadata.height} px'),
        _buildMetaRow('Aspect Ratio', photo.metadata.aspectRatio),
        _buildMetaRow('Megapixels', photo.metadata.megapixels),
        _buildMetaRow('File Size', photo.metadata.fileSize),
        _buildMetaRow('Color Profile', photo.metadata.colorProfile),

        const SizedBox(height: 16),

        // Camera Optics
        _buildHeader('CAMERA & OPTICS'),
        const SizedBox(height: 6),
        _buildMetaRow('Camera Body', photo.exif.cameraModel),
        _buildMetaRow('Lens', photo.exif.lens),
        _buildMetaRow('ISO Speed', 'ISO ${photo.exif.iso}'),
        _buildMetaRow('Aperture', photo.exif.aperture),
        _buildMetaRow('Shutter Speed', photo.exif.shutterSpeed),
        _buildMetaRow('Focal Length', photo.exif.focalLength),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF888888), letterSpacing: 0.8),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFCCCCCC), fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
