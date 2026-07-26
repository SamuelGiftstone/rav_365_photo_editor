import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LuminaSplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const LuminaSplashScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<LuminaSplashScreen> createState() => _LuminaSplashScreenState();
}

class _LuminaSplashScreenState extends State<LuminaSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  final List<String> _loadingLogs = [
    'Initializing Skia GPU Engine...',
    'Loading badlogic.jpg',
    'Loading photo_engine.dll',
    'Connecting to Local Storage Driver...',
    'Reading metadata & EXIF cache...',
    'Loading color profiles (sRGB & Display P3)...',
    'Preparing workspace canvas...',
    'Ready!'
  ];

  int _currentLogIndex = 0;
  Timer? _logTimer;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _progressController.addListener(() {
      final progress = _progressController.value;
      final newIndex = (progress * (_loadingLogs.length - 1)).floor().clamp(0, _loadingLogs.length - 1);
      if (newIndex != _currentLogIndex) {
        setState(() {
          _currentLogIndex = newIndex;
        });
      }
    });

    _progressController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          widget.onFinish();
        }
      });
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _logTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Desktop Background Simulation (Transparent / Blurred Desktop wallpaper behind)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1920&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                ),
              ),
            ),
          ),

          // 2. Simulated Desktop Windows / Applications in the background
          Positioned(
            top: 40,
            left: 60,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: 320,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 80,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 400,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
              ),
            ),
          ),

          // 3. Centered Small Dark Splash Card (Exact match to GdxSplash reference)
          Center(
            child: Container(
              width: 580,
              height: 340,
              decoration: BoxDecoration(
                color: const Color(0xFF232527), // Dark grey solid background
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    // Glowing Teal Abstract Polygon Artwork (GdxSplash background)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: LuminaNebulaPainter(),
                      ),
                    ),

                    // Centered Content (Title & Version)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Rav365 Photo Editor',
                            style: GoogleFonts.inter(
                              fontSize: 46,
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'v 1.0',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF9CA3AF),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Left Log Text & Bottom White Progress Bar
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: Text(
                                _loadingLogs[_currentLogIndex],
                                key: ValueKey(_currentLogIndex),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFD1D5DB),
                                ),
                              ),
                            ),
                          ),

                          // Progress Bar
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return Container(
                                height: 4,
                                width: double.infinity,
                                color: const Color(0xFF374151),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 4,
                                    width: 580 * _progressAnimation.value,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Skip button on top right
                    Positioned(
                      top: 10,
                      right: 12,
                      child: TextButton(
                        onPressed: widget.onFinish,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white38,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Skip', style: TextStyle(fontSize: 10)),
                      ),
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

// Custom Painter for abstract glowing emerald/teal geometric polygon cloud splash
class LuminaNebulaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Glowing deep radial gradient
    final radialPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00796B).withOpacity(0.45),
          const Color(0xFF004D40).withOpacity(0.20),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4));

    canvas.drawCircle(center, size.width * 0.4, radialPaint);

    // Abstract Polygon Shards
    final shardPaint1 = Paint()
      ..color = const Color(0xFF00BFA5).withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final shardPaint2 = Paint()
      ..color = const Color(0xFF00695C).withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final shardPaint3 = Paint()
      ..color = const Color(0xFF1DE9B6).withOpacity(0.12)
      ..style = PaintingStyle.fill;

    // Polygon Path 1
    final path1 = Path()
      ..moveTo(center.dx - 180, center.dy + 80)
      ..lineTo(center.dx - 40, center.dy - 120)
      ..lineTo(center.dx + 90, center.dy - 60)
      ..lineTo(center.dx + 40, center.dy + 90)
      ..close();

    // Polygon Path 2
    final path2 = Path()
      ..moveTo(center.dx - 120, center.dy - 40)
      ..lineTo(center.dx + 160, center.dy - 100)
      ..lineTo(center.dx + 220, center.dy + 40)
      ..lineTo(center.dx + 80, center.dy + 110)
      ..close();

    // Polygon Path 3
    final path3 = Path()
      ..moveTo(center.dx - 220, center.dy + 20)
      ..lineTo(center.dx - 80, center.dy - 80)
      ..lineTo(center.dx + 120, center.dy + 30)
      ..lineTo(center.dx - 40, center.dy + 120)
      ..close();

    canvas.drawPath(path1, shardPaint1);
    canvas.drawPath(path2, shardPaint2);
    canvas.drawPath(path3, shardPaint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
