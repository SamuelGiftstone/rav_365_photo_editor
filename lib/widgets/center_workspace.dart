import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../models/photo.dart';
import 'photo_image.dart';
import 'edit_panel.dart';
import 'photoshop_tools_bar.dart';
import 'layers_history_panel.dart';
import 'modals/slideshow_overlay.dart';
import 'modals/export_modal.dart';

class LuminaCenterWorkspace extends StatelessWidget {
  const LuminaCenterWorkspace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);

    return Container(
      color: const Color(0xFF0F172A), // Studio Ultra Dark Canvas
      child: Stack(
        children: [
          // Main Content View depending on ViewMode
          Positioned.fill(
            child: _buildWorkspaceContent(context, provider),
          ),

          // Floating View Control Toolbar at the top center
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIconButton(
                      icon: PhosphorIconsRegular.image,
                      tooltip: 'Single View (1)',
                      isActive: provider.viewMode == ViewMode.single,
                      onPressed: () => provider.setViewMode(ViewMode.single),
                    ),
                    _buildIconButton(
                      icon: PhosphorIconsRegular.squaresFour,
                      tooltip: 'Grid View (2)',
                      isActive: provider.viewMode == ViewMode.grid,
                      onPressed: () => provider.setViewMode(ViewMode.grid),
                    ),
                    _buildIconButton(
                      icon: PhosphorIconsRegular.sliders,
                      tooltip: 'Photoshop Edit Mode (3)',
                      isActive: provider.viewMode == ViewMode.edit,
                      onPressed: () => provider.setViewMode(ViewMode.edit),
                    ),
                    _buildIconButton(
                      icon: PhosphorIconsRegular.columns,
                      tooltip: 'Compare Mode (4)',
                      isActive: provider.viewMode == ViewMode.compare,
                      onPressed: () => provider.setViewMode(ViewMode.compare),
                    ),

                    const SizedBox(width: 8),
                    Container(width: 1, height: 16, color: Colors.white24),
                    const SizedBox(width: 8),

                    // Zoom Controls
                    _buildIconButton(
                      icon: PhosphorIconsRegular.magnifyingGlassMinus,
                      tooltip: 'Zoom Out',
                      onPressed: () => provider.setZoom(provider.zoom - 0.25),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '${(provider.zoom * 100).round()}%',
                        style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildIconButton(
                      icon: PhosphorIconsRegular.magnifyingGlassPlus,
                      tooltip: 'Zoom In',
                      onPressed: () => provider.setZoom(provider.zoom + 0.25),
                    ),

                    const SizedBox(width: 8),
                    Container(width: 1, height: 16, color: Colors.white24),
                    const SizedBox(width: 8),

                    _buildIconButton(
                      icon: PhosphorIconsRegular.export,
                      tooltip: 'Export Studio Assets',
                      onPressed: () => LuminaExportModal.show(context),
                    ),
                    _buildIconButton(
                      icon: PhosphorIconsRegular.playCircle,
                      tooltip: 'Start Slideshow',
                      onPressed: () => LuminaSlideshowOverlay.show(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Toast Banner Overlay
          if (provider.toastMessage != null)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 12)],
                  ),
                  child: Text(
                    provider.toastMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceContent(BuildContext context, PhotoProvider provider) {
    switch (provider.viewMode) {
      case ViewMode.grid:
        return _buildGridView(context, provider);
      case ViewMode.compare:
        return _buildCompareView(context, provider);
      case ViewMode.edit:
      case ViewMode.single:
      default:
        return Row(
          children: [
            // Photoshop Vertical Tool Palette Dock
            const LuminaPhotoshopToolsBar(),

            // Central Photoshop Document Area (Tabs + Canvas)
            Expanded(
              child: Column(
                children: [
                  // Document Tab Bar
                  _buildDocumentTabBar(provider),

                  // Main Interactive Canvas
                  Expanded(
                    child: Container(
                      color: const Color(0xFF181818), // Photoshop Document Background
                      child: _buildSingleViewCanvas(context, provider, isEditMode: provider.viewMode == ViewMode.edit || provider.activeTool != PhotoshopTool.move),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildDocumentTabBar(PhotoProvider provider) {
    final photo = provider.activePhoto;
    return Container(
      height: 26,
      color: const Color(0xFF2B2B2B),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E), // Active document tab
              border: Border(
                top: BorderSide(color: Color(0xFF00A2ED), width: 2),
                right: BorderSide(color: Color(0xFF383838)),
                left: BorderSide(color: Color(0xFF383838)),
              ),
            ),
            child: Row(
              children: [
                const Icon(PhosphorIconsRegular.image, size: 12, color: Color(0xFF00A2ED)),
                const SizedBox(width: 6),
                Text(
                  photo != null ? '${photo.metadata.filename} @ ${(provider.zoom * 100).round()}% (RGB/8#)' : 'Untitled-1 @ 100%',
                  style: const TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'monospace'),
                ),
                const SizedBox(width: 8),
                const Icon(PhosphorIconsRegular.x, size: 10, color: Colors.white54),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => provider.pickLocalFiles(isFolder: false),
            icon: const Icon(PhosphorIconsRegular.plus, size: 12, color: Colors.white70),
            tooltip: 'Open New Document',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // Single View Interactive Studio Canvas
  Widget _buildSingleViewCanvas(BuildContext context, PhotoProvider provider, {bool isEditMode = false}) {
    final photo = provider.activePhoto;
    if (photo == null) {
      return const Center(
        child: Text('No photo loaded in workspace', style: TextStyle(color: Colors.white70)),
      );
    }

    final adj = provider.currentAdjustments;
    final layers = provider.currentLayers;
    final activeTool = provider.activeTool;

    return GestureDetector(
      onPanUpdate: isEditMode && (activeTool == PhotoshopTool.brush || activeTool == PhotoshopTool.healing || activeTool == PhotoshopTool.eraser)
          ? (details) {
              provider.addDrawingPointToTopLayer(details.localPosition);
            }
          : null,
      child: InteractiveViewer(
        minScale: 0.2,
        maxScale: 5.0,
        transformationController: TransformationController()..value = (Matrix4.identity()..scale(provider.zoom)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: AnimatedRotation(
              turns: (provider.rotation + adj.straightenAngle) / 360,
              duration: const Duration(milliseconds: 200),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(provider.flipH ? -1.0 : 1.0, provider.flipV ? -1.0 : 1.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Base Image Layer with Filters & Color Adjustments
                    ColorFiltered(
                      colorFilter: _getColorFilter(adj.filter),
                      child: LuminaPhotoWidget(
                        photo: photo,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Render Layer Overlays (Drawings, Text, Masks)
                    for (final layer in layers.reversed)
                      if (layer.isVisible)
                        Opacity(
                          opacity: layer.opacity,
                          child: _buildLayerContent(layer),
                        ),

                    // Crop Grid Overlay when Crop Tool is active
                    if (isEditMode && activeTool == PhotoshopTool.crop)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyanAccent, width: 2),
                          ),
                          child: CustomPaint(
                            painter: LuminaCropGridPainter(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayerContent(LayerItem layer) {
    if (layer.type == 'text') {
      return Positioned(
        left: layer.textPosition.dx,
        top: layer.textPosition.dy,
        child: Text(
          layer.textContent,
          style: TextStyle(
            color: layer.textColor,
            fontSize: layer.fontSize,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(2, 2)),
            ],
          ),
        ),
      );
    } else if (layer.type == 'draw' && layer.drawPoints.isNotEmpty) {
      return CustomPaint(
        painter: LuminaDrawPainter(
          points: layer.drawPoints,
          color: layer.strokeColor,
          strokeWidth: layer.strokeWidth,
        ),
      );
    }
    return const SizedBox();
  }

  // Grid View Gallery
  Widget _buildGridView(BuildContext context, PhotoProvider provider) {
    final photos = provider.filteredPhotos;

    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          final isSelected = photo.id == provider.activePhotoId;

          return GestureDetector(
            onTap: () {
              provider.setActivePhotoId(photo.id);
              provider.setViewMode(ViewMode.single);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF334155),
                  width: isSelected ? 2.5 : 1.0,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: LuminaPhotoWidget(
                              photo: photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () => provider.toggleFavorite(photo.id),
                              icon: Icon(
                                photo.metadata.isFavorite
                                    ? PhosphorIconsFill.star
                                    : PhosphorIconsRegular.star,
                                color: photo.metadata.isFavorite
                                    ? const Color(0xFFEAB308)
                                    : Colors.white70,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              photo.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < photo.metadata.rating
                                    ? PhosphorIconsFill.star
                                    : PhosphorIconsRegular.star,
                                size: 10,
                                color: const Color(0xFFEAB308),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Compare View Side-By-Side
  Widget _buildCompareView(BuildContext context, PhotoProvider provider) {
    final photoA = provider.activePhoto;
    final photoB = provider.comparePhoto;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildComparePanel('PHOTO A (PRIMARY)', photoA, provider, true),
          ),
          const SizedBox(width: 12),
          Container(width: 1, color: Colors.white24),
          const SizedBox(width: 12),
          Expanded(
            child: _buildComparePanel('PHOTO B (COMPARE)', photoB, provider, false),
          ),
        ],
      ),
    );
  }

  Widget _buildComparePanel(String label, Photo? photo, PhotoProvider provider, bool isPrimary) {
    if (photo == null) return const SizedBox();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF1E293B),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label — ${photo.title}',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
              ),
              DropdownButton<String>(
                value: photo.id,
                isDense: true,
                dropdownColor: const Color(0xFF0F172A),
                underline: const SizedBox(),
                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.w600),
                items: provider.photos.map((p) {
                  return DropdownMenuItem(value: p.id, child: Text(p.title));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    if (isPrimary) {
                      provider.setActivePhotoId(val);
                    } else {
                      provider.setComparePhotoId(val);
                    }
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: LuminaPhotoWidget(photo: photo, fit: BoxFit.contain),
          ),
        ),
      ],
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
        size: 16,
        color: isActive ? const Color(0xFF38BDF8) : Colors.white70,
      ),
      tooltip: tooltip,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(),
    );
  }

  ColorFilter _getColorFilter(String filter) {
    switch (filter) {
      case 'grayscale':
        return const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]);
      case 'sepia':
        return const ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0,     0,     0,     1, 0,
        ]);
      case 'cyberpunk':
        return const ColorFilter.matrix([
          1.2, 0.0, 0.2, 0, 0,
          0.0, 0.8, 0.5, 0, 0,
          0.3, 0.1, 1.4, 0, 0,
          0,   0,   0,   1, 0,
        ]);
      case 'cinematic_teal':
        return const ColorFilter.matrix([
          0.8, 0.1, 0.1, 0, 0,
          0.0, 1.1, 0.2, 0, 10,
          0.1, 0.2, 1.3, 0, 20,
          0,   0,   0,   1, 0,
        ]);
      case 'noir_gold':
        return const ColorFilter.matrix([
          1.2, 0.3, 0.0, 0, 15,
          0.2, 1.0, 0.0, 0, 10,
          0.0, 0.1, 0.5, 0, 0,
          0,   0,   0,   1, 0,
        ]);
      case 'warm_vintage':
        return const ColorFilter.matrix([
          1.1, 0.1, 0.0, 0, 10,
          0.0, 1.0, 0.1, 0, 5,
          0.0, 0.0, 0.8, 0, 0,
          0,   0,   0,   1, 0,
        ]);
      case 'cool_breeze':
        return const ColorFilter.matrix([
          0.9, 0.0, 0.1, 0, 0,
          0.0, 1.0, 0.1, 0, 0,
          0.1, 0.2, 1.2, 0, 10,
          0,   0,   0,   1, 0,
        ]);
      case 'none':
      default:
        return const ColorFilter.matrix([
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ]);
    }
  }
}

// Custom Painter for Paint Brush Strokes
class LuminaDrawPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  LuminaDrawPainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant LuminaDrawPainter oldDelegate) => true;
}

// Custom Painter for Crop Grid Rule-of-Thirds
class LuminaCropGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.4)
      ..strokeWidth = 1.0;

    final w = size.width;
    final h = size.height;

    // Rule of thirds lines
    canvas.drawLine(Offset(w / 3, 0), Offset(w / 3, h), paint);
    canvas.drawLine(Offset(2 * w / 3, 0), Offset(2 * w / 3, h), paint);
    canvas.drawLine(Offset(0, h / 3), Offset(w, h / 3), paint);
    canvas.drawLine(Offset(0, 2 * h / 3), Offset(w, 2 * h / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
