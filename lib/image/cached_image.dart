import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ZoomableCachedImageWidget extends StatelessWidget {
  final String imageUrl;

  const ZoomableCachedImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showZoomedImage(context, imageUrl);
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Container(
       //   height: 200.0,
          color: Colors.grey[300], // Placeholder color or widget
        ),
        errorWidget: (context, url, error) => Container(
        //  height: 200.0,
          color: Colors.grey[300], // Error placeholder color or widget
          child: const Center(child: Icon(Icons.error)),
        ),
        imageBuilder: (context, imageProvider) => Container(
         // height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
          // You can add additional child widgets here if needed
        ),
        fit: BoxFit.contain, // Adjust as per your needs
        fadeInDuration: const Duration(milliseconds: 300), // Duration of the fade-in effect
        fadeInCurve: Curves.easeIn, // Curve for the fade-in effect
      ),
    );
  }

  void showZoomedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GestureDetector(
            onTap: () {
              // Handle double-tap to zoom out
              Navigator.pop(context);
            },
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 2.5, // Adjust the maximum zoom level as needed
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}