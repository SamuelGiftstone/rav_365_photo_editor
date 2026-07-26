import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import 'modals/keyboard_shortcuts_modal.dart';
import 'modals/about_modal.dart';
import 'modals/wallpaper_modal.dart';
import 'modals/slideshow_overlay.dart';
import 'modals/export_modal.dart';

class LuminaMenuBar extends StatelessWidget {
  const LuminaMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);

    return Container(
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFF323232),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          // File
          _buildMenuButton(context, 'File', [
            PopupMenuItem(
              value: 'open_file',
              child: _buildMenuRow(PhosphorIconsRegular.image, 'Open...', 'Ctrl+O'),
            ),
            PopupMenuItem(
              value: 'open_folder',
              child: _buildMenuRow(PhosphorIconsRegular.folderOpen, 'Open Folder...', 'Ctrl+Shift+O'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'export',
              child: _buildMenuRow(PhosphorIconsRegular.export, 'Export As...', 'Ctrl+Shift+E'),
            ),
            PopupMenuItem(
              value: 'wallpaper',
              child: _buildMenuRow(PhosphorIconsRegular.desktop, 'Set as Wallpaper', 'Ctrl+W'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'favorite',
              child: _buildMenuRow(
                PhosphorIconsRegular.star,
                provider.activePhoto?.metadata.isFavorite == true ? 'Remove Favorite' : 'Mark Favorite',
                'F',
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: _buildMenuRow(PhosphorIconsRegular.trash, 'Close / Delete', 'Del'),
            ),
          ]),

          // Edit
          _buildMenuButton(context, 'Edit', [
            PopupMenuItem(
              value: 'undo',
              child: _buildMenuRow(PhosphorIconsRegular.arrowCounterClockwise, 'Undo', 'Ctrl+Z'),
            ),
            PopupMenuItem(
              value: 'redo',
              child: _buildMenuRow(PhosphorIconsRegular.arrowClockwise, 'Redo', 'Ctrl+Y'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'copy_path',
              child: _buildMenuRow(PhosphorIconsRegular.copy, 'Copy Image Path', 'Ctrl+C'),
            ),
            PopupMenuItem(
              value: 'reset_adj',
              child: _buildMenuRow(PhosphorIconsRegular.sliders, 'Reset All Adjustments', 'Ctrl+R'),
            ),
          ]),

          // Image
          _buildMenuButton(context, 'Image', [
            PopupMenuItem(
              value: 'rotate_cw',
              child: _buildMenuRow(PhosphorIconsRegular.arrowClockwise, 'Rotate 90° Clockwise', 'Ctrl+]'),
            ),
            PopupMenuItem(
              value: 'rotate_ccw',
              child: _buildMenuRow(PhosphorIconsRegular.arrowCounterClockwise, 'Rotate 90° Counter-CW', 'Ctrl+['),
            ),
            PopupMenuItem(
              value: 'flip_h',
              child: _buildMenuRow(PhosphorIconsRegular.flipHorizontal, 'Flip Canvas Horizontal', ''),
            ),
            PopupMenuItem(
              value: 'flip_v',
              child: _buildMenuRow(PhosphorIconsRegular.flipVertical, 'Flip Canvas Vertical', ''),
            ),
          ]),

          // Layer
          _buildMenuButton(context, 'Layer', [
            PopupMenuItem(
              value: 'add_text_layer',
              child: _buildMenuRow(PhosphorIconsRegular.textT, 'New Text Layer', 'T'),
            ),
            PopupMenuItem(
              value: 'add_draw_layer',
              child: _buildMenuRow(PhosphorIconsRegular.paintBrush, 'New Painting Layer', 'B'),
            ),
          ]),

          // Select
          _buildMenuButton(context, 'Select', [
            PopupMenuItem(
              value: 'select_all',
              child: _buildMenuRow(PhosphorIconsRegular.selectionAll, 'All', 'Ctrl+A'),
            ),
            PopupMenuItem(
              value: 'deselect',
              child: _buildMenuRow(PhosphorIconsRegular.selectionSlash, 'Deselect', 'Ctrl+D'),
            ),
          ]),

          // Filter
          _buildMenuButton(context, 'Filter', [
            PopupMenuItem(
              value: 'edit_mode',
              child: _buildMenuRow(PhosphorIconsRegular.sliders, 'Camera Raw / Preset Lab', 'E'),
            ),
          ]),

          // View
          _buildMenuButton(context, 'View', [
            PopupMenuItem(
              value: 'single',
              child: _buildMenuRow(PhosphorIconsRegular.image, 'Fit Document View', '1'),
            ),
            PopupMenuItem(
              value: 'grid',
              child: _buildMenuRow(PhosphorIconsRegular.squaresFour, 'Gallery Grid View', '2'),
            ),
            PopupMenuItem(
              value: 'edit',
              child: _buildMenuRow(PhosphorIconsRegular.sliders, 'Photoshop Edit Workspace', '3'),
            ),
            PopupMenuItem(
              value: 'compare',
              child: _buildMenuRow(PhosphorIconsRegular.columns, 'Side-by-Side Compare', '4'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'zoom_in',
              child: _buildMenuRow(PhosphorIconsRegular.magnifyingGlassPlus, 'Zoom In', 'Ctrl++'),
            ),
            PopupMenuItem(
              value: 'zoom_out',
              child: _buildMenuRow(PhosphorIconsRegular.magnifyingGlassMinus, 'Zoom Out', 'Ctrl+-'),
            ),
            PopupMenuItem(
              value: 'zoom_fit',
              child: _buildMenuRow(PhosphorIconsRegular.cornersOut, 'Fit on Screen', 'Ctrl+0'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'toggle_left',
              child: _buildMenuRow(PhosphorIconsRegular.sidebar, 'Toggle Navigation Panel', 'Ctrl+L'),
            ),
            PopupMenuItem(
              value: 'toggle_right',
              child: _buildMenuRow(PhosphorIconsRegular.sidebarSimple, 'Toggle Inspector Dock', 'Ctrl+R'),
            ),
            PopupMenuItem(
              value: 'toggle_filmstrip',
              child: _buildMenuRow(PhosphorIconsRegular.filmStrip, 'Toggle Filmstrip', 'Ctrl+F'),
            ),
          ]),

          // Window & Help
          _buildMenuButton(context, 'Help', [
            PopupMenuItem(
              value: 'shortcuts',
              child: _buildMenuRow(PhosphorIconsRegular.keyboard, 'Keyboard Shortcuts...', 'F1'),
            ),
            PopupMenuItem(
              value: 'splash',
              child: _buildMenuRow(PhosphorIconsRegular.sparkle, 'Lumina Welcome Screen', 'F12'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'about',
              child: _buildMenuRow(PhosphorIconsRegular.info, 'About Lumina Studio Pro', ''),
            ),
          ]),

          const Spacer(),

          // Active Folder Breadcrumb
          Row(
            children: [
              const Icon(PhosphorIconsRegular.folderOpen, size: 11, color: Color(0xFF999999)),
              const SizedBox(width: 4),
              Text(
                'Folder: ${provider.selectedFolderId}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF999999), fontFamily: 'monospace'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, List<PopupMenuEntry<String>> items) {
    final provider = Provider.of<PhotoProvider>(context, listen: false);

    return PopupMenuButton<String>(
      offset: const Offset(0, 24),
      elevation: 8,
      color: const Color(0xFF2B2B2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFFCCCCCC),
          ),
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case 'open_file':
            provider.pickLocalFiles(isFolder: false);
            break;
          case 'open_folder':
            provider.pickLocalFiles(isFolder: true);
            break;
          case 'export':
            LuminaExportModal.show(context);
            break;
          case 'wallpaper':
            LuminaWallpaperModal.show(context);
            break;
          case 'favorite':
            if (provider.activePhotoId.isNotEmpty) {
              provider.toggleFavorite(provider.activePhotoId);
            }
            break;
          case 'delete':
            provider.deleteActivePhoto();
            break;
          case 'undo':
            provider.undo();
            break;
          case 'redo':
            provider.redo();
            break;
          case 'copy_path':
            provider.copyActivePath();
            break;
          case 'reset_adj':
            provider.resetCurrentAdjustments();
            break;
          case 'rotate_cw':
            provider.rotateClockwise();
            break;
          case 'rotate_ccw':
            provider.rotateCounterClockwise();
            break;
          case 'flip_h':
            provider.toggleFlipH();
            break;
          case 'flip_v':
            provider.toggleFlipV();
            break;
          case 'add_text_layer':
            provider.addTextLayer('Photoshop Layer');
            break;
          case 'add_draw_layer':
            provider.addDrawingLayer();
            break;
          case 'single':
            provider.setViewMode(ViewMode.single);
            break;
          case 'grid':
            provider.setViewMode(ViewMode.grid);
            break;
          case 'edit':
            provider.setViewMode(ViewMode.edit);
            break;
          case 'compare':
            provider.setViewMode(ViewMode.compare);
            break;
          case 'zoom_in':
            provider.setZoom(provider.zoom * 1.25);
            break;
          case 'zoom_out':
            provider.setZoom(provider.zoom * 0.8);
            break;
          case 'zoom_fit':
            provider.setZoom(1.0);
            break;
          case 'toggle_left':
            provider.toggleLeftSidebar();
            break;
          case 'toggle_right':
            provider.toggleRightSidebar();
            break;
          case 'toggle_filmstrip':
            provider.toggleFilmstrip();
            break;
          case 'shortcuts':
            LuminaShortcutsModal.show(context);
            break;
          case 'splash':
            provider.triggerSplash();
            break;
          case 'about':
            LuminaAboutModal.show(context);
            break;
        }
      },
      itemBuilder: (context) => items,
    );
  }

  Widget _buildMenuRow(IconData icon, String title, String shortcut) {
    return SizedBox(
      width: 210,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: const Color(0xFF00A2ED)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.white)),
            ],
          ),
          if (shortcut.isNotEmpty)
            Text(
              shortcut,
              style: const TextStyle(fontSize: 10, color: Colors.white38, fontFamily: 'monospace'),
            ),
        ],
      ),
    );
  }
}
