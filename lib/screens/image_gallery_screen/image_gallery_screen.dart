import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageGalleryScreen extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;

  const ImageGalleryScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            pageController: PageController(initialPage: widget.initialIndex),
            itemCount: widget.imageUrls.length,
            builder: (context, index) {
              final url = widget.imageUrls[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(url),
                heroAttributes: PhotoViewHeroAttributes(tag: url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
              );
            },
            onPageChanged: (index) => setState(() => currentIndex = index),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${currentIndex + 1} / ${widget.imageUrls.length}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
