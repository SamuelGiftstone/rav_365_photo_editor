import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../models/photo.dart';

enum ViewMode { single, grid, edit, compare }

class PhotoProvider extends ChangeNotifier {
  List<Photo> _photos = List.from(samplePhotos);
  String _activePhotoId = samplePhotos.first.id;
  String _comparePhotoId = samplePhotos.length > 1 ? samplePhotos[1].id : samplePhotos.first.id;

  String _selectedFolderId = 'all';
  String _selectedAlbumId = '';
  int _selectedMinRating = 0;
  String? _selectedTag;
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'date', 'rating', 'size'

  ViewMode _viewMode = ViewMode.single;
  double _zoom = 1.0;
  int _rotation = 0; // 0, 90, 180, 270
  bool _flipH = false;
  bool _flipV = false;

  bool _showLeftSidebar = true;
  bool _showRightSidebar = true;
  bool _showFilmstrip = true;
  bool _showSplash = true;

  // Active Photoshop Tool
  PhotoshopTool _activeTool = PhotoshopTool.move;

  // Brush settings
  double _brushSize = 20.0;
  double _brushOpacity = 0.9;
  Color _brushColor = const Color(0xFF00E5FF);

  // Eyedropper Sampled Color
  Color _sampledColor = const Color(0xFF00E5FF);

  // Crop Ratio
  String _cropAspectRatio = 'Free';

  // Active Photo Adjustments (for Edit mode)
  final Map<String, PhotoAdjustments> _adjustments = {};

  // Layers per Photo
  final Map<String, List<LayerItem>> _layers = {};

  // History per Photo
  final Map<String, List<HistoryState>> _history = {};
  final Map<String, int> _historyIndex = {};

  // Notification Toast
  String? _toastMessage;

  // Getters
  bool get showSplash => _showSplash;
  PhotoshopTool get activeTool => _activeTool;
  double get brushSize => _brushSize;
  double get brushOpacity => _brushOpacity;
  Color get brushColor => _brushColor;
  Color get sampledColor => _sampledColor;
  String get cropAspectRatio => _cropAspectRatio;

  List<Photo> get photos => _photos;
  List<PhotoFolder> get folders => sampleFolders;
  List<PhotoAlbum> get albums => sampleAlbums;

  String get activePhotoId => _activePhotoId;
  String get comparePhotoId => _comparePhotoId;
  String get selectedFolderId => _selectedFolderId;
  String get selectedAlbumId => _selectedAlbumId;
  String get activeFolderId => _selectedFolderId;
  String? get activeAlbumId => _selectedAlbumId.isEmpty ? null : _selectedAlbumId;
  int get selectedMinRating => _selectedMinRating;
  String? get selectedTag => _selectedTag;

  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;

  ViewMode get viewMode => _viewMode;
  double get zoom => _zoom;
  int get rotation => _rotation;
  bool get flipH => _flipH;
  bool get flipV => _flipV;

  bool get showLeftSidebar => _showLeftSidebar;
  bool get showRightSidebar => _showRightSidebar;
  bool get showFilmstrip => _showFilmstrip;

  String? get toastMessage => _toastMessage;

  // Get Layers for Active Photo
  List<LayerItem> get currentLayers {
    return _layers.putIfAbsent(_activePhotoId, () {
      return [
        LayerItem(
          id: 'bg-layer',
          name: 'Background Photo',
          type: 'image',
          isLocked: true,
        ),
      ];
    });
  }

  // Get History for Active Photo
  List<HistoryState> get currentHistory {
    return _history.putIfAbsent(_activePhotoId, () {
      return [
        HistoryState(
          timestamp: DateTime.now(),
          actionName: 'Original Import',
          adjustments: currentAdjustments.copyWith(),
          layers: List.from(currentLayers),
        )
      ];
    });
  }

  int get currentHistoryIndex {
    return _historyIndex.putIfAbsent(_activePhotoId, () => 0);
  }

  Photo? get activePhoto {
    try {
      return _photos.firstWhere((p) => p.id == _activePhotoId);
    } catch (_) {
      return _photos.isNotEmpty ? _photos.first : null;
    }
  }

  Photo? get comparePhoto {
    try {
      return _photos.firstWhere((p) => p.id == _comparePhotoId);
    } catch (_) {
      return _photos.length > 1 ? _photos[1] : null;
    }
  }

  int get activeIndex {
    final list = filteredPhotos;
    return list.indexWhere((p) => p.id == _activePhotoId);
  }

  PhotoAdjustments get currentAdjustments {
    return _adjustments.putIfAbsent(_activePhotoId, () => PhotoAdjustments());
  }

  // Filtered and Sorted list
  List<Photo> get filteredPhotos {
    List<Photo> list = List.from(_photos);

    // Folder Filter
    if (_selectedFolderId != 'all') {
      list = list.where((p) => p.metadata.folderId == _selectedFolderId).toList();
    }

    // Album Filter
    if (_selectedAlbumId == 'favs') {
      list = list.where((p) => p.metadata.isFavorite).toList();
    } else if (_selectedAlbumId == '5-stars') {
      list = list.where((p) => p.metadata.rating == 5).toList();
    }

    // Min Rating Filter
    if (_selectedMinRating > 0) {
      list = list.where((p) => p.metadata.rating >= _selectedMinRating).toList();
    }

    // Tag Filter
    if (_selectedTag != null && _selectedTag!.isNotEmpty) {
      list = list.where((p) => p.metadata.tags.contains(_selectedTag)).toList();
    }

    // Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.metadata.filename.toLowerCase().contains(q) ||
            p.metadata.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }

    // Sort
    list.sort((a, b) {
      switch (_sortBy) {
        case 'date':
          return b.metadata.dateCreated.compareTo(a.metadata.dateCreated);
        case 'rating':
          return b.metadata.rating.compareTo(a.metadata.rating);
        case 'size':
          return b.metadata.fileSizeBytes.compareTo(a.metadata.fileSizeBytes);
        case 'name':
        default:
          return a.title.compareTo(b.title);
      }
    });

    return list;
  }

  // Pick Local Image File or Folder from PC Storage
  Future<void> pickLocalFiles({bool isFolder = false}) async {
    try {
      if (isFolder) {
        showToast('Select photo files from your folder');
      }

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final List<Photo> loadedPhotos = [];
        for (int i = 0; i < result.files.length; i++) {
          final file = result.files[i];
          final filename = file.name;
          final title = filename.contains('.')
              ? filename.substring(0, filename.lastIndexOf('.'))
              : filename;

          final sizeMb = (file.size / (1024 * 1024)).toStringAsFixed(1);
          final Uint8List? fileBytes = file.bytes;

          String url;
          if (fileBytes != null && fileBytes.isNotEmpty) {
            final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : 'jpeg';
            final mime = ext == 'png'
                ? 'image/png'
                : (ext == 'gif'
                    ? 'image/gif'
                    : (ext == 'webp'
                        ? 'image/webp'
                        : 'image/jpeg'));
            url = 'data:$mime;base64,${base64Encode(fileBytes)}';
          } else if (file.path != null &&
              (file.path!.startsWith('http://') ||
                  file.path!.startsWith('https://') ||
                  file.path!.startsWith('blob:'))) {
            url = file.path!;
          } else {
            url = 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80';
          }

          final newPhoto = Photo(
            id: 'local-${DateTime.now().millisecondsSinceEpoch}-$i',
            url: url,
            bytes: fileBytes,
            title: title,
            metadata: PhotoMetadata(
              filename: filename,
              width: 3840,
              height: 2160,
              fileSize: '$sizeMb MB',
              fileSizeBytes: file.size,
              format: filename.contains('.') ? filename.split('.').last.toUpperCase() : 'JPG',
              dateCreated: DateTime.now().toString().substring(0, 19),
              dateModified: DateTime.now().toString().substring(0, 19),
              colorProfile: 'sRGB IEC61966-2.1',
              colorDepth: '8-bit',
              aspectRatio: '16:9',
              megapixels: '8.3 MP',
              rating: 4,
              isFavorite: false,
              tags: ['Local Storage', 'PC Import'],
              dominantColors: ['#2563EB', '#1E293B', '#F8FAFC'],
              folderId: 'all',
            ),
            exif: PhotoExif(
              cameraModel: 'Windows PC Storage',
              lens: 'Local Drive Import',
              iso: 100,
              aperture: 'f/2.0',
              shutterSpeed: '1/250s',
              focalLength: '24mm',
            ),
            histogramRed: List.generate(32, (index) => 20 + (index * 4) % 60),
            histogramGreen: List.generate(32, (index) => 15 + (index * 5) % 70),
            histogramBlue: List.generate(32, (index) => 30 + (index * 3) % 80),
          );
          loadedPhotos.add(newPhoto);
        }
        if (loadedPhotos.isNotEmpty) {
          _photos.insertAll(0, loadedPhotos);
          setActivePhotoId(loadedPhotos.first.id);
          showToast('Imported ${loadedPhotos.length} photo(s) from PC Storage');
        }
      }
    } catch (e) {
      showToast('File selection: $e');
    }
  }

  // Delete Active Photo
  void deleteActivePhoto() {
    final photo = activePhoto;
    if (photo == null) return;
    final deletedTitle = photo.title;
    _photos.removeWhere((p) => p.id == photo.id);
    if (filteredPhotos.isNotEmpty) {
      setActivePhotoId(filteredPhotos.first.id);
    } else {
      _activePhotoId = '';
    }
    showToast('Deleted "$deletedTitle"');
    notifyListeners();
  }

  // Copy Path to Clipboard
  void copyActivePath() {
    final photo = activePhoto;
    if (photo == null) return;
    Clipboard.setData(ClipboardData(text: 'C:\\Users\\Photos\\${photo.metadata.filename}'));
    showToast('Copied file path to clipboard');
  }

  // Share Photo Link
  void shareActivePhoto() {
    final photo = activePhoto;
    if (photo == null) return;
    Clipboard.setData(ClipboardData(text: photo.url));
    showToast('Share link copied to clipboard');
  }

  // Setters & Actions
  void setActivePhotoId(String id) {
    _activePhotoId = id;
    _zoom = 1.0;
    _rotation = 0;
    _flipH = false;
    _flipV = false;
    notifyListeners();
  }

  void setComparePhotoId(String id) {
    _comparePhotoId = id;
    notifyListeners();
  }

  void setSelectedFolder(String folderId) {
    _selectedFolderId = folderId;
    _selectedAlbumId = '';
    notifyListeners();
  }

  void setFolder(String folderId) => setSelectedFolder(folderId);

  void setSelectedAlbum(String albumId) {
    _selectedAlbumId = albumId;
    _selectedFolderId = 'all';
    notifyListeners();
  }

  void setAlbum(String albumId) => setSelectedAlbum(albumId);

  void setMinRating(int rating) {
    _selectedMinRating = rating;
    notifyListeners();
  }

  void setTag(String? tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void setViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setZoom(double z) {
    _zoom = z.clamp(0.25, 4.0);
    notifyListeners();
  }

  void rotateClockwise() {
    _rotation = (_rotation + 90) % 360;
    notifyListeners();
  }

  void rotateCounterClockwise() {
    _rotation = (_rotation - 90) % 360;
    if (_rotation < 0) _rotation += 360;
    notifyListeners();
  }

  void toggleFlipH() {
    _flipH = !_flipH;
    notifyListeners();
  }

  void toggleFlipV() {
    _flipV = !_flipV;
    notifyListeners();
  }

  void toggleLeftSidebar() {
    _showLeftSidebar = !_showLeftSidebar;
    notifyListeners();
  }

  void toggleRightSidebar() {
    _showRightSidebar = !_showRightSidebar;
    notifyListeners();
  }

  void toggleFilmstrip() {
    _showFilmstrip = !_showFilmstrip;
    notifyListeners();
  }

  void nextPhoto() {
    final list = filteredPhotos;
    if (list.isEmpty) return;
    final idx = list.indexWhere((p) => p.id == _activePhotoId);
    if (idx != -1 && idx < list.length - 1) {
      setActivePhotoId(list[idx + 1].id);
    } else if (list.isNotEmpty) {
      setActivePhotoId(list.first.id);
    }
  }

  void prevPhoto() {
    final list = filteredPhotos;
    if (list.isEmpty) return;
    final idx = list.indexWhere((p) => p.id == _activePhotoId);
    if (idx > 0) {
      setActivePhotoId(list[idx - 1].id);
    } else if (list.isNotEmpty) {
      setActivePhotoId(list.last.id);
    }
  }

  void toggleFavorite(String photoId) {
    final idx = _photos.indexWhere((p) => p.id == photoId);
    if (idx != -1) {
      _photos[idx].metadata.isFavorite = !_photos[idx].metadata.isFavorite;
      showToast(_photos[idx].metadata.isFavorite
          ? 'Added to Favorites'
          : 'Removed from Favorites');
      notifyListeners();
    }
  }

  void setRating(String photoId, int rating) {
    final idx = _photos.indexWhere((p) => p.id == photoId);
    if (idx != -1) {
      _photos[idx].metadata.rating = rating;
      showToast('Set rating to $rating stars');
      notifyListeners();
    }
  }

  // Edit adjustments update
  void updateAdjustments(PhotoAdjustments newAdj, {String? actionLabel}) {
    _adjustments[_activePhotoId] = newAdj;
    if (actionLabel != null) {
      recordHistory(actionLabel);
    }
    notifyListeners();
  }

  void resetCurrentAdjustments() {
    currentAdjustments.reset();
    recordHistory('Reset Adjustments');
    notifyListeners();
  }

  // Photoshop Tool actions
  void setActiveTool(PhotoshopTool tool) {
    _activeTool = tool;
    showToast('Tool: ${_toolName(tool)}');
    notifyListeners();
  }

  String _toolName(PhotoshopTool tool) {
    switch (tool) {
      case PhotoshopTool.move: return 'Move / Pan (V)';
      case PhotoshopTool.marquee: return 'Marquee Selection (M)';
      case PhotoshopTool.crop: return 'Crop & Straighten (C)';
      case PhotoshopTool.brush: return 'Paint Brush (B)';
      case PhotoshopTool.healing: return 'Spot Healing (J)';
      case PhotoshopTool.clone: return 'Clone Stamp (S)';
      case PhotoshopTool.eraser: return 'Eraser (E)';
      case PhotoshopTool.text: return 'Text Layer (T)';
      case PhotoshopTool.eyedropper: return 'Color Sampler (I)';
      case PhotoshopTool.gradient: return 'Gradient Overlay (G)';
      case PhotoshopTool.filter: return 'Color Presets (F)';
    }
  }

  void setBrushSize(double s) {
    _brushSize = s;
    notifyListeners();
  }

  void setBrushOpacity(double o) {
    _brushOpacity = o;
    notifyListeners();
  }

  void setBrushColor(Color c) {
    _brushColor = c;
    notifyListeners();
  }

  void setSampledColor(Color c) {
    _sampledColor = c;
    _brushColor = c;
    showToast('Sampled Color: #${c.value.toRadixString(16).substring(2).toUpperCase()}');
    notifyListeners();
  }

  void setCropAspectRatio(String ratio) {
    _cropAspectRatio = ratio;
    notifyListeners();
  }

  // Layer Management
  void addTextLayer(String text) {
    final layers = currentLayers;
    final newLayer = LayerItem(
      id: 'text-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Text: "$text"',
      type: 'text',
      textContent: text,
      textColor: _brushColor,
      textPosition: const Offset(120, 140),
    );
    layers.insert(0, newLayer);
    recordHistory('Added Text Layer');
    showToast('Added Text Layer');
    notifyListeners();
  }

  void addDrawingLayer() {
    final layers = currentLayers;
    final newLayer = LayerItem(
      id: 'draw-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Brush Drawing Layer',
      type: 'draw',
      strokeColor: _brushColor,
      strokeWidth: _brushSize,
    );
    layers.insert(0, newLayer);
    recordHistory('Added Brush Layer');
    showToast('Created New Painting Layer');
    notifyListeners();
  }

  void addDrawingPointToTopLayer(Offset point) {
    final layers = currentLayers;
    if (layers.isEmpty) return;
    final topDrawIndex = layers.indexWhere((l) => l.type == 'draw' && !l.isLocked && l.isVisible);
    if (topDrawIndex != -1) {
      layers[topDrawIndex].drawPoints.add(point);
      notifyListeners();
    } else {
      addDrawingLayer();
      currentLayers.first.drawPoints.add(point);
      notifyListeners();
    }
  }

  void toggleLayerVisibility(String layerId) {
    final layers = currentLayers;
    final idx = layers.indexWhere((l) => l.id == layerId);
    if (idx != -1) {
      layers[idx].isVisible = !layers[idx].isVisible;
      notifyListeners();
    }
  }

  void toggleLayerLock(String layerId) {
    final layers = currentLayers;
    final idx = layers.indexWhere((l) => l.id == layerId);
    if (idx != -1) {
      layers[idx].isLocked = !layers[idx].isLocked;
      notifyListeners();
    }
  }

  void setLayerOpacity(String layerId, double opacity) {
    final layers = currentLayers;
    final idx = layers.indexWhere((l) => l.id == layerId);
    if (idx != -1) {
      layers[idx].opacity = opacity;
      notifyListeners();
    }
  }

  void setLayerBlendMode(String layerId, String blendMode) {
    final layers = currentLayers;
    final idx = layers.indexWhere((l) => l.id == layerId);
    if (idx != -1) {
      layers[idx].blendMode = blendMode;
      recordHistory('Changed Blend Mode');
      notifyListeners();
    }
  }

  void deleteLayer(String layerId) {
    final layers = currentLayers;
    final idx = layers.indexWhere((l) => l.id == layerId);
    if (idx != -1 && !layers[idx].isLocked) {
      final name = layers[idx].name;
      layers.removeAt(idx);
      recordHistory('Deleted Layer');
      showToast('Deleted "$name"');
      notifyListeners();
    }
  }

  // History & Undo / Redo
  void recordHistory(String actionName) {
    final hist = currentHistory;
    int idx = currentHistoryIndex;

    // Truncate future states if we were back in history
    if (idx < hist.length - 1) {
      hist.removeRange(idx + 1, hist.length);
    }

    hist.add(HistoryState(
      timestamp: DateTime.now(),
      actionName: actionName,
      adjustments: currentAdjustments.copyWith(),
      layers: currentLayers.map((l) => l.copyWith()).toList(),
    ));

    _historyIndex[_activePhotoId] = hist.length - 1;
  }

  void jumpToHistory(int index) {
    final hist = currentHistory;
    if (index >= 0 && index < hist.length) {
      _historyIndex[_activePhotoId] = index;
      final state = hist[index];
      _adjustments[_activePhotoId] = state.adjustments.copyWith();
      _layers[_activePhotoId] = state.layers.map((l) => l.copyWith()).toList();
      showToast('History: ${state.actionName}');
      notifyListeners();
    }
  }

  void undo() {
    final idx = currentHistoryIndex;
    if (idx > 0) {
      jumpToHistory(idx - 1);
    }
  }

  void redo() {
    final idx = currentHistoryIndex;
    final hist = currentHistory;
    if (idx < hist.length - 1) {
      jumpToHistory(idx + 1);
    }
  }

  void triggerSplash() {
    _showSplash = true;
    notifyListeners();
  }

  void hideSplash() {
    _showSplash = false;
    notifyListeners();
  }

  void showToast(String msg) {
    _toastMessage = msg;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      if (_toastMessage == msg) {
        _toastMessage = null;
        notifyListeners();
      }
    });
  }
}
