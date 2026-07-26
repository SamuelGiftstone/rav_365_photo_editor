import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/photo.dart';

class LuminaPhotoWidget extends StatelessWidget {
  final Photo photo;
  final BoxFit fit;
  final Alignment alignment;

  const LuminaPhotoWidget({
    Key? key,
    required this.photo,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (photo.bytes != null && photo.bytes!.isNotEmpty) {
      return Image.memory(
        photo.bytes!,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      );
    }

    final url = photo.url;
    if (url.startsWith('data:') ||
        url.startsWith('http://') ||
        url.startsWith('https://') ||
        url.startsWith('blob:')) {
      return Image.network(
        url,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      );
    }

    return _errorPlaceholder();
  }

  Widget _errorPlaceholder() {
    return Container(
      color: const Color(0xFF334155),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(PhosphorIconsRegular.image, color: Colors.white54, size: 28),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                photo.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
