import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starfolio/features/discover/screens/portfolio/widgets/portfolio_app_bar.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/helpers/helper_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
    required this.image,
    this.fit = BoxFit.cover,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = width < height ? width / 2 : height / 2;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (THelperFunctions.isDarkMode(context)
                ? TColors.black
                : TColors.white),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            color: overlayColor,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
            const TShimmerEffect(width: 55, height: 55, radius: 55),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
              : Image(
            fit: fit,
            image: isNetworkImage
                ? NetworkImage(image)
                : AssetImage(image) as ImageProvider,
            color: overlayColor,
          ),
        ),
      ),
    );
  }
}