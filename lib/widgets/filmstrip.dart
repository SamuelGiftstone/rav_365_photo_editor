import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import 'photo_image.dart';

class LuminaFilmstrip extends StatelessWidget {
  const LuminaFilmstrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);
    final photos = provider.filteredPhotos;

    return Container(
      height: 96,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 44, 44, 44),
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 44, 44, 44), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // Sorting & Info Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FILMSTRIP (${photos.length} ITEMS)',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.8,
                ),
              ),
              Row(
                children: [
                  const Text('Sort by: ', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  DropdownButton<String>(
                    value: provider.sortBy,
                    isDense: true,
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                    items: const [
                      DropdownMenuItem(value: 'name', child: Text('Name')),
                      DropdownMenuItem(value: 'date', child: Text('Date Created')),
                      DropdownMenuItem(value: 'rating', child: Text('Rating')),
                      DropdownMenuItem(value: 'size', child: Text('File Size')),
                    ],
                    onChanged: (val) => val != null ? provider.setSortBy(val) : null,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Horizontal Thumbnail Scroll
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                final isSelected = photo.id == provider.activePhotoId;

                return GestureDetector(
                  onTap: () => provider.setActivePhotoId(photo.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 72,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LuminaPhotoWidget(
                              photo: photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (photo.metadata.isFavorite)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              PhosphorIconsFill.star,
                              size: 12,
                              color: Color(0xFFEAB308),
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
      ),
    );
  }
}
