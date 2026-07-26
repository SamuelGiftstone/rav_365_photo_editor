import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class LuminaStatusBar extends StatelessWidget {
  const LuminaStatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final activePhoto = provider.activePhoto;
    final total = provider.filteredPhotos.length;
    final index = provider.activeIndex;

    return Container(
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF262626),
        border: Border(
          top: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Zoom level
          Text(
            '${(provider.zoom * 100).round()}%',
            style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC), fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 8),
          _divider(),
          const SizedBox(width: 8),

          // Document dimensions / MB size
          if (activePhoto != null) ...[
            Text(
              'Doc: ${(activePhoto.metadata.width * activePhoto.metadata.height * 3 / (1024 * 1024)).toStringAsFixed(1)}M / ${(activePhoto.metadata.width * activePhoto.metadata.height * 4 / (1024 * 1024)).toStringAsFixed(1)}M',
              style: const TextStyle(fontSize: 10, color: Color(0xFF999999), fontFamily: 'monospace'),
            ),
            const SizedBox(width: 8),
            _divider(),
            const SizedBox(width: 8),

            Text(
              '${activePhoto.metadata.width} × ${activePhoto.metadata.height} px (${activePhoto.metadata.colorProfile})',
              style: const TextStyle(fontSize: 10, color: Color(0xFF999999), fontFamily: 'monospace'),
            ),
            const SizedBox(width: 8),
            _divider(),
            const SizedBox(width: 8),
          ],

          Text(
            total > 0 ? 'Asset ${index + 1} of $total' : 'No document open',
            style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
          ),

          const Spacer(),

          // GPU & Color Sampler
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: provider.sampledColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'RGB (${provider.sampledColor.red}, ${provider.sampledColor.green}, ${provider.sampledColor.blue})',
                style: const TextStyle(fontSize: 10, color: Color(0xFF999999), fontFamily: 'monospace'),
              ),
              const SizedBox(width: 10),
              _divider(),
              const SizedBox(width: 10),
              const Icon(PhosphorIconsRegular.cpu, size: 11, color: Color(0xFF31A8FF)),
              const SizedBox(width: 4),
              const Text(
                'GPU Acceleration',
                style: TextStyle(fontSize: 10, color: Color(0xFF31A8FF), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 10, color: const Color(0xFF383838));
  }
}
