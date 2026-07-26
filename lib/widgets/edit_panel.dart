import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class LuminaEditPanel extends StatelessWidget {
  const LuminaEditPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final adj = provider.currentAdjustments;

    return Container(
      color: const Color(0xFF262626),
      child: Column(
        children: [
          // Header
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF323232),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(PhosphorIconsRegular.sliders, size: 12, color: Color(0xFF00A2ED)),
                    SizedBox(width: 6),
                    Text(
                      'DEVELOP & ADJUSTMENTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCCCCCC),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => provider.resetCurrentAdjustments(),
                  child: const Text('Reset', style: TextStyle(fontSize: 10, color: Color(0xFF00A2ED), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Adjustment Controls List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // 1. Presets Gallery
                _buildSectionTitle('COLOR PRESETS'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildFilterChip(context, provider, 'None', 'none'),
                    _buildFilterChip(context, provider, 'Grayscale', 'grayscale'),
                    _buildFilterChip(context, provider, 'Sepia', 'sepia'),
                    _buildFilterChip(context, provider, 'Cyberpunk', 'cyberpunk'),
                    _buildFilterChip(context, provider, 'Vintage', 'warm_vintage'),
                    _buildFilterChip(context, provider, 'Cool Breeze', 'cool_breeze'),
                    _buildFilterChip(context, provider, 'Cinematic', 'cinematic_teal'),
                    _buildFilterChip(context, provider, 'Noir Gold', 'noir_gold'),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Color(0xFF383838), height: 1),
                const SizedBox(height: 10),

                // 2. Light & Tone Curves
                _buildSectionTitle('LIGHT & TONE'),
                _buildSlider(
                  label: 'Exposure',
                  value: adj.exposure,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.exposure = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Brightness',
                  value: adj.brightness,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.brightness = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Contrast',
                  value: adj.contrast,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.contrast = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Highlights',
                  value: adj.highlights,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.highlights = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Shadows',
                  value: adj.shadows,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.shadows = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Whites',
                  value: adj.whites,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.whites = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Blacks',
                  value: adj.blacks,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.blacks = v;
                    provider.updateAdjustments(adj);
                  },
                ),

                const SizedBox(height: 12),
                const Divider(color: Color(0xFF383838), height: 1),
                const SizedBox(height: 10),

                // 3. Color & HSL Mixer
                _buildSectionTitle('COLOR & HSL MIXER'),
                _buildSlider(
                  label: 'Temp (Warmth)',
                  value: adj.warmth,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.warmth = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Tint (Green/Magenta)',
                  value: adj.tint,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.tint = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Vibrance',
                  value: adj.vibrance,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.vibrance = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Saturation',
                  value: adj.saturation,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.saturation = v;
                    provider.updateAdjustments(adj);
                  },
                ),

                const SizedBox(height: 12),
                const Divider(color: Color(0xFF383838), height: 1),
                const SizedBox(height: 10),

                // 4. Detail & Clarity
                _buildSectionTitle('DETAIL & CLARITY'),
                _buildSlider(
                  label: 'Clarity',
                  value: adj.clarity,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.clarity = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Dehaze',
                  value: adj.dehaze,
                  min: -100,
                  max: 100,
                  onChanged: (v) {
                    adj.dehaze = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Sharpening',
                  value: adj.sharpness,
                  min: 0,
                  max: 100,
                  onChanged: (v) {
                    adj.sharpness = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Film Grain',
                  value: adj.grain,
                  min: 0,
                  max: 100,
                  onChanged: (v) {
                    adj.grain = v;
                    provider.updateAdjustments(adj);
                  },
                ),

                const SizedBox(height: 12),
                const Divider(color: Color(0xFF383838), height: 1),
                const SizedBox(height: 10),

                // 5. Effects & Geometry
                _buildSectionTitle('EFFECTS & CROP TILT'),
                _buildSlider(
                  label: 'Vignette',
                  value: adj.vignette,
                  min: 0,
                  max: 100,
                  onChanged: (v) {
                    adj.vignette = v;
                    provider.updateAdjustments(adj);
                  },
                ),
                _buildSlider(
                  label: 'Straighten Angle',
                  value: adj.straightenAngle,
                  min: -45,
                  max: 45,
                  onChanged: (v) {
                    adj.straightenAngle = v;
                    provider.updateAdjustments(adj);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.bold,
        color: Color(0xFF888888),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, PhotoProvider provider, String label, String value) {
    final adj = provider.currentAdjustments;
    final isSelected = adj.filter == value;

    return GestureDetector(
      onTap: () {
        adj.filter = value;
        provider.updateAdjustments(adj, actionLabel: 'Preset: $label');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0078D4) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: isSelected ? const Color(0xFF00A2ED) : const Color(0xFF383838)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC)),
              ),
              Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10, color: Color(0xFF00A2ED), fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: const SliderThemeData(
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 8),
              activeTrackColor: Color(0xFF00A2ED),
              inactiveTrackColor: Color(0xFF1E1E1E),
              thumbColor: Color(0xFF00A2ED),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
