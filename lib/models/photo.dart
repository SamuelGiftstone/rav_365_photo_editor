import 'dart:typed_data';
import 'package:flutter/material.dart';

enum PhotoshopTool {
  move,        // V - Hand / Pan / Move
  marquee,     // M - Rectangular / Circular Selection
  crop,        // C - Crop & Perspective Straighten
  brush,       // B - Paint Brush / Airbrush
  healing,     // J - Spot Healing Brush
  clone,       // S - Clone Stamp
  eraser,      // E - Eraser Tool
  text,        // T - Type / Text Layer
  eyedropper,  // I - Color Sampler
  gradient,    // G - Gradient / Radial Mask
  filter,      // F - Quick Preset Filters
}

class LayerItem {
  final String id;
  String name;
  bool isVisible;
  bool isLocked;
  double opacity; // 0.0 to 1.0
  String blendMode; // 'normal', 'multiply', 'screen', 'overlay', 'soft_light', 'difference'
  String type; // 'image', 'text', 'draw', 'adjustment'
  String textContent;
  Color textColor;
  double fontSize;
  Offset textPosition;
  List<Offset> drawPoints;
  Color strokeColor;
  double strokeWidth;

  LayerItem({
    required this.id,
    required this.name,
    this.isVisible = true,
    this.isLocked = false,
    this.opacity = 1.0,
    this.blendMode = 'normal',
    this.type = 'image',
    this.textContent = 'Lumina Text Layer',
    this.textColor = Colors.white,
    this.fontSize = 24.0,
    this.textPosition = const Offset(100, 100),
    List<Offset>? drawPoints,
    this.strokeColor = Colors.cyanAccent,
    this.strokeWidth = 4.0,
  }) : drawPoints = drawPoints ?? [];

  LayerItem copyWith({
    String? name,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
    String? blendMode,
    String? textContent,
    Color? textColor,
    double? fontSize,
    Offset? textPosition,
    List<Offset>? drawPoints,
    Color? strokeColor,
    double? strokeWidth,
  }) {
    return LayerItem(
      id: id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      type: type,
      textContent: textContent ?? this.textContent,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      textPosition: textPosition ?? this.textPosition,
      drawPoints: drawPoints != null ? List.from(drawPoints) : List.from(this.drawPoints),
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

class HistoryState {
  final DateTime timestamp;
  final String actionName;
  final PhotoAdjustments adjustments;
  final List<LayerItem> layers;

  HistoryState({
    required this.timestamp,
    required this.actionName,
    required this.adjustments,
    required this.layers,
  });
}

class PhotoExif {
  final String cameraModel;
  final String lens;
  final int iso;
  final String aperture;
  final String shutterSpeed;
  final String focalLength;

  PhotoExif({
    required this.cameraModel,
    required this.lens,
    required this.iso,
    required this.aperture,
    required this.shutterSpeed,
    required this.focalLength,
  });
}

class PhotoMetadata {
  final String filename;
  final int width;
  final int height;
  final String fileSize;
  final int fileSizeBytes;
  final String format;
  final String dateCreated;
  final String dateModified;
  final String colorProfile;
  final String colorDepth;
  final String aspectRatio;
  final String megapixels;
  int rating;
  bool isFavorite;
  final List<String> tags;
  final List<String> dominantColors;
  final String folderId;

  PhotoMetadata({
    required this.filename,
    required this.width,
    required this.height,
    required this.fileSize,
    required this.fileSizeBytes,
    required this.format,
    required this.dateCreated,
    required this.dateModified,
    required this.colorProfile,
    required this.colorDepth,
    required this.aspectRatio,
    required this.megapixels,
    required this.rating,
    required this.isFavorite,
    required this.tags,
    required this.dominantColors,
    required this.folderId,
  });
}

class PhotoAdjustments {
  // Basic Light & Exposure
  double exposure;   // -100 to 100
  double brightness; // -100 to 100
  double contrast;   // -100 to 100
  double highlights; // -100 to 100
  double shadows;    // -100 to 100
  double whites;     // -100 to 100
  double blacks;     // -100 to 100

  // Color & HSL
  double saturation; // -100 to 100
  double vibrance;   // -100 to 100
  double warmth;     // -100 to 100 (Temp)
  double tint;       // -100 to 100 (Green-Magenta)
  double hslRed;     // -100 to 100
  double hslGreen;   // -100 to 100
  double hslBlue;    // -100 to 100

  // Detail & Clarity
  double clarity;    // -100 to 100
  double dehaze;     // -100 to 100
  double sharpness;  // 0 to 100
  double noiseReduction; // 0 to 100
  double grain;      // 0 to 100
  double blur;       // 0 to 20

  // Vignette & Geometry
  double vignette;   // 0 to 100
  double straightenAngle; // -45 to 45 deg
  int rotation;      // 0, 90, 180, 270
  bool flipH;
  bool flipV;

  // Split Toning / Color Grading
  double highlightTintHue; // 0 to 360
  double shadowTintHue;    // 0 to 360

  String filter;     // 'none', 'grayscale', 'sepia', 'cyberpunk', 'warm_vintage', 'cool_breeze', 'dramatic_bw', 'cinematic_teal', 'noir_gold'

  PhotoAdjustments({
    this.exposure = 0,
    this.brightness = 0,
    this.contrast = 0,
    this.highlights = 0,
    this.shadows = 0,
    this.whites = 0,
    this.blacks = 0,
    this.saturation = 0,
    this.vibrance = 0,
    this.warmth = 0,
    this.tint = 0,
    this.hslRed = 0,
    this.hslGreen = 0,
    this.hslBlue = 0,
    this.clarity = 0,
    this.dehaze = 0,
    this.sharpness = 0,
    this.noiseReduction = 0,
    this.grain = 0,
    this.blur = 0,
    this.vignette = 0,
    this.straightenAngle = 0,
    this.rotation = 0,
    this.flipH = false,
    this.flipV = false,
    this.highlightTintHue = 0,
    this.shadowTintHue = 0,
    this.filter = 'none',
  });

  PhotoAdjustments copyWith({
    double? exposure,
    double? brightness,
    double? contrast,
    double? highlights,
    double? shadows,
    double? whites,
    double? blacks,
    double? saturation,
    double? vibrance,
    double? warmth,
    double? tint,
    double? hslRed,
    double? hslGreen,
    double? hslBlue,
    double? clarity,
    double? dehaze,
    double? sharpness,
    double? noiseReduction,
    double? grain,
    double? blur,
    double? vignette,
    double? straightenAngle,
    int? rotation,
    bool? flipH,
    bool? flipV,
    double? highlightTintHue,
    double? shadowTintHue,
    String? filter,
  }) {
    return PhotoAdjustments(
      exposure: exposure ?? this.exposure,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      highlights: highlights ?? this.highlights,
      shadows: shadows ?? this.shadows,
      whites: whites ?? this.whites,
      blacks: blacks ?? this.blacks,
      saturation: saturation ?? this.saturation,
      vibrance: vibrance ?? this.vibrance,
      warmth: warmth ?? this.warmth,
      tint: tint ?? this.tint,
      hslRed: hslRed ?? this.hslRed,
      hslGreen: hslGreen ?? this.hslGreen,
      hslBlue: hslBlue ?? this.hslBlue,
      clarity: clarity ?? this.clarity,
      dehaze: dehaze ?? this.dehaze,
      sharpness: sharpness ?? this.sharpness,
      noiseReduction: noiseReduction ?? this.noiseReduction,
      grain: grain ?? this.grain,
      blur: blur ?? this.blur,
      vignette: vignette ?? this.vignette,
      straightenAngle: straightenAngle ?? this.straightenAngle,
      rotation: rotation ?? this.rotation,
      flipH: flipH ?? this.flipH,
      flipV: flipV ?? this.flipV,
      highlightTintHue: highlightTintHue ?? this.highlightTintHue,
      shadowTintHue: shadowTintHue ?? this.shadowTintHue,
      filter: filter ?? this.filter,
    );
  }

  void reset() {
    exposure = 0;
    brightness = 0;
    contrast = 0;
    highlights = 0;
    shadows = 0;
    whites = 0;
    blacks = 0;
    saturation = 0;
    vibrance = 0;
    warmth = 0;
    tint = 0;
    hslRed = 0;
    hslGreen = 0;
    hslBlue = 0;
    clarity = 0;
    dehaze = 0;
    sharpness = 0;
    noiseReduction = 0;
    grain = 0;
    blur = 0;
    vignette = 0;
    straightenAngle = 0;
    rotation = 0;
    flipH = false;
    flipV = false;
    highlightTintHue = 0;
    shadowTintHue = 0;
    filter = 'none';
  }
}

class Photo {
  final String id;
  final String url;
  final String title;
  final Uint8List? bytes;
  final PhotoMetadata metadata;
  final PhotoExif exif;
  final List<int> histogramRed;
  final List<int> histogramGreen;
  final List<int> histogramBlue;

  Photo({
    required this.id,
    required this.url,
    required this.title,
    this.bytes,
    required this.metadata,
    required this.exif,
    required this.histogramRed,
    required this.histogramGreen,
    required this.histogramBlue,
  });
}

class PhotoFolder {
  final String id;
  final String name;
  final String path;
  final int count;

  PhotoFolder({
    required this.id,
    required this.name,
    required this.path,
    required this.count,
  });
}

class PhotoAlbum {
  final String id;
  final String name;
  final int count;
  final String icon;

  PhotoAlbum({
    required this.id,
    required this.name,
    required this.count,
    required this.icon,
  });
}

final List<PhotoFolder> sampleFolders = [
  PhotoFolder(id: 'all', name: 'All Photos', path: 'C:\\Users\\Photos', count: 6),
  PhotoFolder(id: 'landscapes', name: 'Landscapes & Nature', path: 'C:\\Users\\Photos\\Landscapes', count: 2),
  PhotoFolder(id: 'architecture', name: 'Architecture & Urban', path: 'C:\\Users\\Photos\\Architecture', count: 2),
  PhotoFolder(id: 'portraits', name: 'Portraits & Studio', path: 'C:\\Users\\Photos\\Portraits', count: 2),
];

final List<PhotoAlbum> sampleAlbums = [
  PhotoAlbum(id: 'favs', name: 'Favorites', count: 4, icon: 'star'),
  PhotoAlbum(id: '5-stars', name: 'Top Rated (5★)', count: 4, icon: 'award'),
];

final List<Photo> samplePhotos = [
  Photo(
    id: 'p1',
    url: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=2400&q=85',
    title: 'Yosemite Valley Mist',
    metadata: PhotoMetadata(
      filename: 'Yosemite_Valley_Mist_2026.jpg',
      width: 6000,
      height: 4000,
      fileSize: '14.2 MB',
      fileSizeBytes: 14889728,
      format: 'JPEG',
      dateCreated: '2026-05-14 06:42:12',
      dateModified: '2026-05-14 08:15:00',
      colorProfile: 'Display P3',
      colorDepth: '14-bit RAW',
      aspectRatio: '3:2',
      megapixels: '24.0 MP',
      rating: 5,
      isFavorite: true,
      tags: ['Landscape', 'Nature', 'Mountains', 'Fog'],
      dominantColors: ['#2C3E50', '#7F8C8D', '#BDC3C7', '#16A085'],
      folderId: 'landscapes',
    ),
    exif: PhotoExif(
      cameraModel: 'Sony α7R V',
      lens: 'FE 24-70mm F2.8 GM II',
      iso: 100,
      aperture: 'f/8.0',
      shutterSpeed: '1/250s',
      focalLength: '35mm',
    ),
    histogramRed: List.generate(32, (i) => (20 + (i * 3) % 70)),
    histogramGreen: List.generate(32, (i) => (15 + (i * 4) % 80)),
    histogramBlue: List.generate(32, (i) => (30 + (i * 5) % 90)),
  ),
  Photo(
    id: 'p2',
    url: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=2400&q=85',
    title: 'Nordic Coast Sunset',
    metadata: PhotoMetadata(
      filename: 'Nordic_Coast_Sunset.jpg',
      width: 5472,
      height: 3648,
      fileSize: '11.8 MB',
      fileSizeBytes: 12373196,
      format: 'JPEG',
      dateCreated: '2026-06-02 19:10:04',
      dateModified: '2026-06-02 19:40:22',
      colorProfile: 'sRGB IEC61966-2.1',
      colorDepth: '12-bit RAW',
      aspectRatio: '3:2',
      megapixels: '20.0 MP',
      rating: 5,
      isFavorite: true,
      tags: ['Sunset', 'Ocean', 'Coast', 'Nordic'],
      dominantColors: ['#E67E22', '#D35400', '#2980B9', '#2C3E50'],
      folderId: 'landscapes',
    ),
    exif: PhotoExif(
      cameraModel: 'Canon EOS R5',
      lens: 'RF 15-35mm F2.8L IS USM',
      iso: 200,
      aperture: 'f/11',
      shutterSpeed: '1/60s',
      focalLength: '18mm',
    ),
    histogramRed: List.generate(32, (i) => (10 + (i * 6) % 85)),
    histogramGreen: List.generate(32, (i) => (12 + (i * 4) % 65)),
    histogramBlue: List.generate(32, (i) => (25 + (i * 2) % 75)),
  ),
  Photo(
    id: 'p3',
    url: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=2400&q=85',
    title: 'Modernist Glass Skyscraper',
    metadata: PhotoMetadata(
      filename: 'Glass_Facade_Metropolis.jpg',
      width: 4000,
      height: 6000,
      fileSize: '9.4 MB',
      fileSizeBytes: 9856614,
      format: 'JPEG',
      dateCreated: '2026-04-18 14:22:30',
      dateModified: '2026-04-18 15:00:10',
      colorProfile: 'Adobe RGB (1998)',
      colorDepth: '14-bit RAW',
      aspectRatio: '2:3',
      megapixels: '24.0 MP',
      rating: 4,
      isFavorite: false,
      tags: ['Architecture', 'City', 'Skyscraper', 'Reflections'],
      dominantColors: ['#34495E', '#5D6D7E', '#AEB6BF', '#E5E8E8'],
      folderId: 'architecture',
    ),
    exif: PhotoExif(
      cameraModel: 'Nikon Z9',
      lens: 'NIKKOR Z 14-24mm f/2.8 S',
      iso: 64,
      aperture: 'f/5.6',
      shutterSpeed: '1/500s',
      focalLength: '14mm',
    ),
    histogramRed: List.generate(32, (i) => (5 + (i * 2) % 40)),
    histogramGreen: List.generate(32, (i) => (10 + (i * 5) % 80)),
    histogramBlue: List.generate(32, (i) => (40 + (i * 7) % 95)),
  ),
  Photo(
    id: 'p4',
    url: 'https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=2400&q=85',
    title: 'Tokyo Cyberpunk Rain',
    metadata: PhotoMetadata(
      filename: 'Tokyo_Cyberpunk_Rain.jpg',
      width: 6192,
      height: 4128,
      fileSize: '16.5 MB',
      fileSizeBytes: 17301504,
      format: 'PNG',
      dateCreated: '2026-03-29 23:40:11',
      dateModified: '2026-03-30 01:12:00',
      colorProfile: 'Display P3',
      colorDepth: '16-bit TIFF',
      aspectRatio: '3:2',
      megapixels: '25.5 MP',
      rating: 5,
      isFavorite: true,
      tags: ['City', 'Neon', 'Tokyo', 'Night', 'Rain'],
      dominantColors: ['#8E44AD', '#3498DB', '#E74C3C', '#2C3E50'],
      folderId: 'architecture',
    ),
    exif: PhotoExif(
      cameraModel: 'Fujifilm X-T5',
      lens: 'XF 33mm F1.4 R LM WR',
      iso: 800,
      aperture: 'f/1.4',
      shutterSpeed: '1/160s',
      focalLength: '50mm Equivalent',
    ),
    histogramRed: List.generate(32, (i) => (30 + (i * 7) % 90)),
    histogramGreen: List.generate(32, (i) => (10 + (i * 3) % 50)),
    histogramBlue: List.generate(32, (i) => (45 + (i * 8) % 100)),
  ),
  Photo(
    id: 'p5',
    url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=2400&q=85',
    title: 'Studio Lighting Portrait',
    metadata: PhotoMetadata(
      filename: 'Studio_Lighting_Portrait.jpg',
      width: 5000,
      height: 7500,
      fileSize: '18.1 MB',
      fileSizeBytes: 18979225,
      format: 'JPEG',
      dateCreated: '2026-02-11 11:15:00',
      dateModified: '2026-02-11 14:00:00',
      colorProfile: 'ProPhoto RGB',
      colorDepth: '16-bit RAW',
      aspectRatio: '2:3',
      megapixels: '37.5 MP',
      rating: 5,
      isFavorite: true,
      tags: ['Portrait', 'Studio', 'Lighting', 'Model'],
      dominantColors: ['#D35400', '#2C3E50', '#ECF0F1', '#E67E22'],
      folderId: 'portraits',
    ),
    exif: PhotoExif(
      cameraModel: 'Hasselblad X2D 100C',
      lens: 'XCD 90mm f/2.5 V',
      iso: 64,
      aperture: 'f/5.6',
      shutterSpeed: '1/200s',
      focalLength: '90mm',
    ),
    histogramRed: List.generate(32, (i) => (20 + (i * 5) % 80)),
    histogramGreen: List.generate(32, (i) => (15 + (i * 4) % 70)),
    histogramBlue: List.generate(32, (i) => (10 + (i * 2) % 40)),
  ),
  Photo(
    id: 'p6',
    url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=2400&q=85',
    title: 'Natural Light Expression',
    metadata: PhotoMetadata(
      filename: 'Natural_Light_Expression.jpg',
      width: 4800,
      height: 3200,
      fileSize: '8.9 MB',
      fileSizeBytes: 9332326,
      format: 'JPEG',
      dateCreated: '2026-01-05 16:20:45',
      dateModified: '2026-01-05 17:00:00',
      colorProfile: 'sRGB IEC61966-2.1',
      colorDepth: '8-bit',
      aspectRatio: '3:2',
      megapixels: '15.3 MP',
      rating: 4,
      isFavorite: false,
      tags: ['Portrait', 'Natural Light', 'Expression'],
      dominantColors: ['#7F8C8D', '#2C3E50', '#F39C12', '#BDC3C7'],
      folderId: 'portraits',
    ),
    exif: PhotoExif(
      cameraModel: 'Leica M11',
      lens: 'NOCTILUX-M 50mm f/0.95 ASPH.',
      iso: 125,
      aperture: 'f/1.2',
      shutterSpeed: '1/1000s',
      focalLength: '50mm',
    ),
    histogramRed: List.generate(32, (i) => (15 + (i * 4) % 75)),
    histogramGreen: List.generate(32, (i) => (20 + (i * 5) % 80)),
    histogramBlue: List.generate(32, (i) => (15 + (i * 3) % 60)),
  ),
];
