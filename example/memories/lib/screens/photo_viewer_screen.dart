import 'package:flutter/material.dart';
import '../widgets/cloudinary_image.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final Future<void> Function(int index)? onDelete;

  const PhotoViewerScreen({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
    this.onDelete,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Delete Photo',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete this photo?',
          style: TextStyle(color: Colors.grey.shade300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCurrentPhoto();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCurrentPhoto() async {
    if (widget.onDelete != null) {
      await widget.onDelete!(_currentIndex);

      if (widget.imagePaths.length <= 1) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        if (_currentIndex >= widget.imagePaths.length - 1) {
          setState(() {
            _currentIndex = widget.imagePaths.length - 2;
          });
          _pageController.jumpToPage(_currentIndex);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.imagePaths.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              _resetZoom();
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 5.0,
                panEnabled: true,
                scaleEnabled: true,
                child: Center(
                  child: Hero(
                    tag: 'photo_${widget.imagePaths[index]}',
                    child: CloudinaryImageWidget(
                      imagePath: widget.imagePaths[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.imagePaths.length > 1)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.imagePaths.length > 10
                          ? 10
                          : widget.imagePaths.length,
                      (index) {
                        if (index == 9 && widget.imagePaths.length > 10) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              '...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 16,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  color: Colors.white,
                  onPressed: () {},
                  tooltip: 'Share',
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out_map),
                  color: Colors.white,
                  onPressed: _resetZoom,
                  tooltip: 'Reset Zoom',
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  color: Colors.white,
                  onPressed: () {},
                  tooltip: 'Favorite',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white,
                  onPressed: widget.onDelete != null ? _confirmDelete : null,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
