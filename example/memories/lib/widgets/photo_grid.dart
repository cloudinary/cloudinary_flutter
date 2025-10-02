import 'package:flutter/material.dart';
import 'cloudinary_image.dart';

class PhotoGrid extends StatelessWidget {
  final List<String> imagePaths;
  final Function(int index)? onImageTap;

  const PhotoGrid({super.key, required this.imagePaths, this.onImageTap});

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) return const SizedBox.shrink();

    final displayPaths = imagePaths.take(6).toList();
    final remaining = imagePaths.length > 6 ? imagePaths.length - 6 : 0;

    switch (displayPaths.length) {
      case 1:
        return _buildSingleImage(displayPaths[0], 0);
      case 2:
        return _buildTwoImages(displayPaths);
      case 3:
        return _buildThreeImages(displayPaths);
      case 4:
        return _buildFourImages(displayPaths);
      case 5:
        return _buildFiveImages(displayPaths);
      default:
        return _buildSixImages(displayPaths, remaining);
    }
  }

  Widget _buildSingleImage(String path, int index) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _buildTappableImage(path, index, BoxFit.cover),
    );
  }

  Widget _buildTwoImages(List<String> paths) {
    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Expanded(child: _buildTappableImage(paths[0], 0, BoxFit.cover)),
          const SizedBox(width: 4),
          Expanded(child: _buildTappableImage(paths[1], 1, BoxFit.cover)),
        ],
      ),
    );
  }

  Widget _buildThreeImages(List<String> paths) {
    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildTappableImage(paths[0], 0, BoxFit.cover),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildTappableImage(paths[1], 1, BoxFit.cover)),
                const SizedBox(height: 4),
                Expanded(child: _buildTappableImage(paths[2], 2, BoxFit.cover)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourImages(List<String> paths) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTappableImage(paths[0], 0, BoxFit.cover),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildTappableImage(paths[1], 1, BoxFit.cover),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildTappableImage(paths[2], 2, BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 100,
          child: _buildTappableImage(paths[3], 3, BoxFit.cover),
        ),
      ],
    );
  }

  Widget _buildFiveImages(List<String> paths) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTappableImage(paths[0], 0, BoxFit.cover),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildTappableImage(paths[1], 1, BoxFit.cover),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildTappableImage(paths[2], 2, BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(child: _buildTappableImage(paths[3], 3, BoxFit.cover)),
              const SizedBox(width: 4),
              Expanded(child: _buildTappableImage(paths[4], 4, BoxFit.cover)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSixImages(List<String> paths, int remaining) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTappableImage(paths[0], 0, BoxFit.cover),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildTappableImage(paths[1], 1, BoxFit.cover),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildTappableImage(paths[2], 2, BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 90,
          child: Row(
            children: [
              Expanded(child: _buildTappableImage(paths[3], 3, BoxFit.cover)),
              const SizedBox(width: 4),
              Expanded(child: _buildTappableImage(paths[4], 4, BoxFit.cover)),
              const SizedBox(width: 4),
              Expanded(child: _buildImageWithOverlay(paths[5], 5, remaining)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTappableImage(String path, int index, BoxFit fit) {
    return GestureDetector(
      onTap: onImageTap != null ? () => onImageTap!(index) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: CloudinaryImageWidget(
          imagePath: path,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildImageWithOverlay(String path, int index, int remaining) {
    return GestureDetector(
      onTap: onImageTap != null ? () => onImageTap!(index) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CloudinaryImageWidget(
              imagePath: path,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            if (remaining > 0)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
