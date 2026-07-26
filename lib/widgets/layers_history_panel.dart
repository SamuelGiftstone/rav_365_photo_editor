import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../models/photo.dart';
import '../providers/photo_provider.dart';

class LuminaLayersHistoryPanel extends StatefulWidget {
  const LuminaLayersHistoryPanel({Key? key}) : super(key: key);

  @override
  State<LuminaLayersHistoryPanel> createState() => _LuminaLayersHistoryPanelState();
}

class _LuminaLayersHistoryPanelState extends State<LuminaLayersHistoryPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);

    return Container(
      color: const Color(0xFF262626),
      child: Column(
        children: [
          // Tab Header (Layers / History)
          Container(
            height: 28,
            color: const Color(0xFF323232),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF00A2ED),
              indicatorWeight: 2,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF888888),
              labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'LAYERS'),
                Tab(text: 'HISTORY'),
              ],
            ),
          ),

          // Tab Body
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLayersTab(context, provider),
                _buildHistoryTab(context, provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- LAYERS TAB ---
  Widget _buildLayersTab(BuildContext context, PhotoProvider provider) {
    final layers = provider.currentLayers;

    return Column(
      children: [
        // Top Layer Control Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          color: const Color(0xFF262626),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(PhosphorIconsRegular.textT, size: 14, color: Color(0xFFCCCCCC)),
                tooltip: 'New Text Layer',
                onPressed: () => _promptAddTextLayer(context, provider),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(PhosphorIconsRegular.paintBrush, size: 14, color: Color(0xFFCCCCCC)),
                tooltip: 'New Paint Layer',
                onPressed: () => provider.addDrawingLayer(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              Text(
                '${layers.length} Layer(s)',
                style: const TextStyle(fontSize: 9, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF383838), height: 1),

        // Layers List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(6),
            itemCount: layers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final layer = layers[index];
              return _buildLayerCard(context, provider, layer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLayerCard(BuildContext context, PhotoProvider provider, LayerItem layer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: layer.isVisible ? const Color(0xFF383838) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Eye Visibility Toggle
              InkWell(
                onTap: () => provider.toggleLayerVisibility(layer.id),
                child: Icon(
                  layer.isVisible ? PhosphorIconsRegular.eye : PhosphorIconsRegular.eyeSlash,
                  size: 14,
                  color: layer.isVisible ? const Color(0xFF00A2ED) : Colors.white30,
                ),
              ),
              const SizedBox(width: 8),

              // Layer Type Icon
              Icon(
                _getLayerIcon(layer.type),
                size: 13,
                color: const Color(0xFFCCCCCC),
              ),
              const SizedBox(width: 6),

              // Layer Name
              Expanded(
                child: Text(
                  layer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: layer.isVisible ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Lock Toggle
              InkWell(
                onTap: () => provider.toggleLayerLock(layer.id),
                child: Icon(
                  layer.isLocked ? PhosphorIconsRegular.lock : PhosphorIconsRegular.lockSimpleOpen,
                  size: 12,
                  color: layer.isLocked ? const Color(0xFFEAB308) : Colors.white30,
                ),
              ),
              const SizedBox(width: 6),

              // Delete button
              if (!layer.isLocked)
                InkWell(
                  onTap: () => provider.deleteLayer(layer.id),
                  child: const Icon(PhosphorIconsRegular.trash, size: 12, color: Color(0xFFEF4444)),
                ),
            ],
          ),

          // Layer Opacity Slider
          if (layer.isVisible) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Opacity', style: TextStyle(fontSize: 9, color: Color(0xFF888888))),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
                    ),
                    child: Slider(
                      value: layer.opacity,
                      min: 0.0,
                      max: 1.0,
                      activeColor: const Color(0xFF00A2ED),
                      inactiveColor: const Color(0xFF2B2B2B),
                      onChanged: layer.isLocked
                          ? null
                          : (v) => provider.setLayerOpacity(layer.id, v),
                    ),
                  ),
                ),
                Text(
                  '${(layer.opacity * 100).toInt()}%',
                  style: const TextStyle(fontSize: 9, color: Color(0xFFCCCCCC), fontFamily: 'monospace'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getLayerIcon(String type) {
    switch (type) {
      case 'text':
        return PhosphorIconsRegular.textT;
      case 'draw':
        return PhosphorIconsRegular.paintBrush;
      case 'adjustment':
        return PhosphorIconsRegular.sliders;
      default:
        return PhosphorIconsRegular.image;
    }
  }

  void _promptAddTextLayer(BuildContext context, PhotoProvider provider) {
    final controller = TextEditingController(text: 'Photoshop Text');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text('New Text Layer', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
            hintText: 'Enter text...',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00A2ED))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54, fontSize: 11)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.addTextLayer(controller.text);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0078D4)),
            child: const Text('Add Layer', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  // --- HISTORY TAB ---
  Widget _buildHistoryTab(BuildContext context, PhotoProvider provider) {
    final history = provider.currentHistory;
    final currentIndex = provider.currentHistoryIndex;

    return Column(
      children: [
        // Undo / Redo Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          color: const Color(0xFF262626),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: currentIndex > 0 ? () => provider.undo() : null,
                icon: const Icon(PhosphorIconsRegular.arrowCounterClockwise, size: 12),
                label: const Text('Undo', style: TextStyle(fontSize: 10)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00A2ED),
                  disabledForegroundColor: Colors.white24,
                ),
              ),
              TextButton.icon(
                onPressed: currentIndex < history.length - 1 ? () => provider.redo() : null,
                icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 12),
                label: const Text('Redo', style: TextStyle(fontSize: 10)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00A2ED),
                  disabledForegroundColor: Colors.white24,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF383838), height: 1),

        // History Log List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 2),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final state = history[index];
              final isCurrent = index == currentIndex;

              return InkWell(
                onTap: () => provider.jumpToHistory(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  color: isCurrent ? const Color(0xFF005A9E) : Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        isCurrent ? PhosphorIconsRegular.arrowRight : PhosphorIconsRegular.clock,
                        size: 12,
                        color: isCurrent ? Colors.white : const Color(0xFF888888),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.actionName,
                          style: TextStyle(
                            fontSize: 10,
                            color: isCurrent ? Colors.white : const Color(0xFFCCCCCC),
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 9,
                          color: isCurrent ? Colors.white70 : const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
