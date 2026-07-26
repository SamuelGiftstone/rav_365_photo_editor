import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class LuminaLeftSidebar extends StatelessWidget {
  const LuminaLeftSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Color(0xFF262626),
        border: Border(
          right: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          // Header title
          Container(
            height: 28,
            color: const Color(0xFF323232),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('NAVIGATOR & ASSETS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFCCCCCC))),
                InkWell(
                  onTap: () => provider.toggleLeftSidebar(),
                  child: const Icon(PhosphorIconsRegular.x, size: 12, color: Colors.white54),
                ),
              ],
            ),
          ),

          // Search Input Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: provider.setSearchQuery,
              style: const TextStyle(fontSize: 11, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search asset catalog...',
                hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 12, color: Color(0xFF888888)),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: Color(0xFF383838)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: Color(0xFF383838)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: Color(0xFF00A2ED)),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              children: [
                // FOLDERS SECTION
                _buildSectionHeader('FOLDERS'),
                ...provider.folders.map((folder) {
                  final isSelected = provider.activeFolderId == folder.id && provider.activeAlbumId == null;
                  return _buildListTile(
                    icon: PhosphorIconsRegular.folder,
                    label: folder.name,
                    count: folder.count,
                    isSelected: isSelected,
                    onTap: () => provider.setFolder(folder.id),
                  );
                }),

                const SizedBox(height: 12),

                // ALBUMS SECTION
                _buildSectionHeader('ALBUMS & COLLECTIONS'),
                ...provider.albums.map((album) {
                  final isSelected = provider.activeAlbumId == album.id;
                  return _buildListTile(
                    icon: album.id == 'favs' ? PhosphorIconsFill.star : PhosphorIconsRegular.gift,
                    iconColor: album.id == 'favs' ? const Color(0xFFEAB308) : null,
                    label: album.name,
                    count: album.count,
                    isSelected: isSelected,
                    onTap: () => provider.setAlbum(album.id),
                  );
                }),

                const SizedBox(height: 12),

                // RATING FILTER
                _buildSectionHeader('MINIMUM RATING'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      final isSelected = provider.selectedMinRating == star;
                      return GestureDetector(
                        onTap: () => provider.setMinRating(isSelected ? 0 : star),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF3A3A00) : const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFEAB308) : const Color(0xFF383838),
                            ),
                          ),
                          child: Icon(
                            PhosphorIconsFill.star,
                            size: 13,
                            color: star <= provider.selectedMinRating
                                ? const Color(0xFFEAB308)
                                : const Color(0xFF555555),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // TAGS CLOUD
                _buildSectionHeader('TAGS'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      'Landscape', 'Nature', 'Sunset', 'Architecture', 'City', 'Fog', 'Studio'
                    ].map((tag) {
                      final isSelected = provider.selectedTag == tag;
                      return GestureDetector(
                        onTap: () => provider.setTag(isSelected ? null : tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0078D4) : const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: isSelected ? const Color(0xFF00A2ED) : const Color(0xFF383838)),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFF888888),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    Color? iconColor,
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF005A9E) : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: iconColor ?? (isSelected ? Colors.white : const Color(0xFF999999)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0078D4) : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF888888),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
