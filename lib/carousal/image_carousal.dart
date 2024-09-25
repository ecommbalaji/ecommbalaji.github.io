import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:webcatalog/image/cached_image.dart';

class ImageCarousal extends StatelessWidget {
   final List<ZoomableCachedImageWidget> images;

  ImageCarousal({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Demo'),
        ),
        body: ImageSlideshow(

          /// Width of the [ImageSlideshow].
          width: 20,

          /// Height of the [ImageSlideshow].
          height: 20,

          /// The page to show when first creating the [ImageSlideshow].
          initialPage: 0,

          /// The color to paint the indicator.
          indicatorColor: Colors.blue,

          /// The color to paint behind th indicator.
          indicatorBackgroundColor: Colors.grey,

          /// Called whenever the page in the center of the viewport changes.
          onPageChanged: (value) {
            print('Page changed: $value');
          },

          /// Auto scroll interval.
          /// Do not auto scroll with null or 0.
          autoPlayInterval: null,

          /// Loops back to first slide.
          isLoop: true,

          /// The widgets to display in the [ImageSlideshow].
          /// Add the sample image file into the images folder
          children: List.generate(
            images.length,
                (index) => images[index],
          ),
        ),
      ),
    );
  }
}