import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/photo_provider.dart';
import '../photo_image.dart';

class LuminaSlideshowOverlay extends StatefulWidget {
  const LuminaSlideshowOverlay({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => const LuminaSlideshowOverlay(),
      ),
    );
  }

  @override
  State<LuminaSlideshowOverlay> createState() => _LuminaSlideshowOverlayState();
}

class _LuminaSlideshowOverlayState extends State<LuminaSlideshowOverlay> {
  bool _isPlaying = true;
  int _intervalSeconds = 4;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_isPlaying) {
      _timer = Timer.periodic(Duration(seconds: _intervalSeconds), (_) {
        final provider = Provider.of<PhotoProvider>(context, listen: false);
        provider.nextPhoto();
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final photos = provider.filteredPhotos;
    final photo = provider.activePhoto;
    final currentIndex = provider.activeIndex;

    if (photo == null) return const SizedBox();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Ambient Blurred Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: LuminaPhotoWidget(
                photo: photo,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Photo Display
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: LuminaPhotoWidget(
                    key: ValueKey(photo.id),
                    photo: photo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Top Header Info
          Positioned(
            top: 24,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${currentIndex + 1} / ${photos.length} — ${photo.metadata.filename}',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(PhosphorIconsRegular.x, color: Colors.white, size: 24),
                  tooltip: 'Exit Slideshow (Esc)',
                ),
              ],
            ),
          ),

          // Bottom Transport Controls Bar
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 20)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        provider.prevPhoto();
                        _startTimer();
                      },
                      icon: const Icon(PhosphorIconsRegular.caretLeft, color: Colors.white, size: 20),
                      tooltip: 'Previous Photo',
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton.small(
                      onPressed: _togglePlayPause,
                      backgroundColor: const Color(0xFF2563EB),
                      child: Icon(
                        _isPlaying ? PhosphorIconsFill.pause : PhosphorIconsFill.play,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        provider.nextPhoto();
                        _startTimer();
                      },
                      icon: const Icon(PhosphorIconsRegular.caretRight, color: Colors.white, size: 20),
                      tooltip: 'Next Photo',
                    ),

                    const SizedBox(width: 16),
                    Container(width: 1, height: 20, color: Colors.white24),
                    const SizedBox(width: 16),

                    // Speed / Interval Picker
                    DropdownButton<int>(
                      value: _intervalSeconds,
                      dropdownColor: const Color(0xFF1E293B),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      items: const [
                        DropdownMenuItem(value: 2, child: Text('2s Interval')),
                        DropdownMenuItem(value: 4, child: Text('4s Interval')),
                        DropdownMenuItem(value: 6, child: Text('6s Interval')),
                        DropdownMenuItem(value: 10, child: Text('10s Interval')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _intervalSeconds = val);
                          _startTimer();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
