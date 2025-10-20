import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_to_plantin/models/photo_model.dart';
import 'package:test_to_plantin/services/gagllery_service.dart';

final galleryServiceProvider = Provider((ref) => GalleryService());

final galleryProvider = StateNotifierProvider<GalleryNotifier, AsyncValue<List<Photo>>>(
  (ref) => GalleryNotifier(ref.read(galleryServiceProvider)),
);

class GalleryNotifier extends StateNotifier<AsyncValue<List<Photo>>> {
  final GalleryService _galleryService;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  GalleryNotifier(this._galleryService) : super(const AsyncValue.loading());

  Future<void> loadPhotos() async {
    if (state.isLoading && state.valueOrNull != null) return;

    state = const AsyncValue.loading();
    try {
      final photos = await _galleryService.fetchPhotos(_currentPage);
      state = AsyncValue.data(photos);
      _hasMore = photos.isNotEmpty;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMorePhotos() async {
    if (_isLoadingMore || !_hasMore) return;

    final currentPhotos = state.valueOrNull ?? [];
    if (currentPhotos.isEmpty) return;

    _isLoadingMore = true;
    try {
      _currentPage++;
      final newPhotos = await _galleryService.fetchPhotos(_currentPage);

      if (newPhotos.isEmpty) {
        _hasMore = false;
      } else {
        state = AsyncValue.data([...currentPhotos, ...newPhotos]);
      }
    } catch (e) {
      _currentPage--;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    await loadPhotos();
  }

  void addLocalPhoto(File file) {
    final currentPhotos = state.valueOrNull ?? [];
    final newPhoto = Photo.fromLocalFile(file);
    state = AsyncValue.data([newPhoto, ...currentPhotos]);
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}
