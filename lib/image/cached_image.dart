import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;

  const CachedImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        height: 200.0,
        color: Colors.grey[300], // Placeholder color or widget
      ),
      errorWidget: (context, url, error) => Container(
        height: 200.0,
        color: Colors.grey[300], // Error placeholder color or widget
        child: Center(child: Icon(Icons.error)),
      ),
      imageBuilder: (context, imageProvider) => Container(
        height: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
        // You can add additional child widgets here if needed
      ),
      fit: BoxFit.contain, // Adjust as per your needs
      fadeInDuration: Duration(milliseconds: 300), // Duration of the fade-in effect
      fadeInCurve: Curves.easeIn, // Curve for the fade-in effect
    );
  }
}
