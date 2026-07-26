import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class LuminaTitleBar extends StatelessWidget {
  const LuminaTitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final activePhoto = provider.activePhoto;

    return Container(
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      child: WindowTitleBarBox(
        child: Row(
          children: [
            // Photoshop Brand Box & Document Title
            Expanded(
              child: MoveWindow(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      // Iconic 'Ps' App Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF001E36),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: const Color(0xFF31A8FF), width: 1.2),
                        ),
                        child: const Text(
                          'Rv',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 49, 104, 255),
                            fontFamily: 'monospace',
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Rav 365 Photo Editor',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE2E2E2),
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (activePhoto != null) ...[
                        const SizedBox(width: 10),
                        const Text('—', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            '${activePhoto.metadata.filename} @ ${(provider.zoom * 100).round()}% (RGB/8#)',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF999999),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Workspace Selector Switcher
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFF383838)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: 'Essentials',
                  dropdownColor: const Color(0xFF2B2B2B),
                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                  isDense: true,
                  items: ['Essentials', 'Photography', 'Graphic & Web', 'Motion', '3D'].map((w) {
                    return DropdownMenuItem(value: w, child: Text(w));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) provider.showToast('Workspace: $val');
                  },
                ),
              ),
            ),

            // Window Controls (Minimize, Maximize, Close)
            Row(
              children: [
                MinimizeWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: const Color(0xFF999999),
                    mouseOver: const Color(0xFF383838),
                    mouseDown: const Color(0xFF424242),
                    iconMouseOver: Colors.white,
                  ),
                ),
                MaximizeWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: const Color(0xFF999999),
                    mouseOver: const Color(0xFF383838),
                    mouseDown: const Color(0xFF424242),
                    iconMouseOver: Colors.white,
                  ),
                ),
                CloseWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: const Color(0xFF999999),
                    mouseOver: const Color(0xFFE81123),
                    mouseDown: const Color(0xFFF1707A),
                    iconMouseOver: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
