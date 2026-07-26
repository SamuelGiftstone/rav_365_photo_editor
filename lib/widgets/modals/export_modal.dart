import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_provider.dart';

class LuminaExportModal extends StatefulWidget {
  const LuminaExportModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LuminaExportModal(),
    );
  }

  @override
  State<LuminaExportModal> createState() => _LuminaExportModalState();
}

class _LuminaExportModalState extends State<LuminaExportModal> {
  String _format = 'JPEG';
  double _quality = 92.0;
  String _resolution = 'Original (4K)';
  String _colorSpace = 'sRGB Color Profile';
  bool _includeExif = true;
  bool _watermark = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final photo = provider.activePhoto;

    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(PhosphorIconsRegular.export, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                const Text(
                  'EXPORT STUDIO ASSETS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.x, size: 16, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF334155)),
            const SizedBox(height: 12),

            if (photo != null)
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: NetworkImage(photo.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${photo.metadata.width} x ${photo.metadata.height} • ${photo.metadata.fileSize}',
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Format Selection
            _buildLabel('File Format'),
            const SizedBox(height: 6),
            Row(
              children: ['JPEG', 'PNG', 'WEBP', 'TIFF'].map((fmt) {
                final isSel = _format == fmt;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(fmt, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : Colors.white70)),
                    selected: isSel,
                    selectedColor: const Color(0xFF2563EB),
                    backgroundColor: const Color(0xFF0F172A),
                    onSelected: (selected) {
                      if (selected) setState(() => _format = fmt);
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Quality Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel('Image Quality'),
                Text('${_quality.toInt()}%', style: const TextStyle(color: Colors.cyanAccent, fontSize: 11)),
              ],
            ),
            Slider(
              value: _quality,
              min: 10,
              max: 100,
              activeColor: const Color(0xFF2563EB),
              inactiveColor: Colors.white12,
              onChanged: (v) => setState(() => _quality = v),
            ),

            const SizedBox(height: 10),

            // Resolution Dropdown
            _buildLabel('Output Resolution'),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _resolution,
                  dropdownColor: const Color(0xFF0F172A),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  isExpanded: true,
                  items: ['Original (4K)', 'Full HD (1080p)', 'HD (720p)', 'Thumbnail (25%)'].map((r) {
                    return DropdownMenuItem(value: r, child: Text(r));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _resolution = v);
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Toggles
            Row(
              children: [
                Checkbox(
                  value: _includeExif,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: (v) => setState(() => _includeExif = v ?? true),
                ),
                const Text('Embed Camera EXIF Metadata', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const Spacer(),
                Checkbox(
                  value: _watermark,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: (v) => setState(() => _watermark = v ?? false),
                ),
                const Text('Add Copyright Watermark', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),

            const SizedBox(height: 20),

            // Export Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    provider.showToast('Exported asset as $_format ($_resolution) at ${_quality.toInt()}% quality');
                  },
                  icon: const Icon(PhosphorIconsRegular.downloadSimple, size: 16),
                  label: const Text('Export Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFF94A3B8),
        letterSpacing: 0.5,
      ),
    );
  }
}
