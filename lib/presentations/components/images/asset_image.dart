import 'package:flutter/material.dart';

import '../../../core/app_theme/app_colors.dart';

class AppAssetImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final double borderRadius;

  const AppAssetImage({super.key, required this.path, this.width, this.height, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: AppColors.secondColor(context),
      alignment: Alignment.center,
      child: Icon(Icons.school_outlined, color: AppColors.mainColor(context), size: 32),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: path.isEmpty ? placeholder : Image.asset(path, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder),
    );
  }
}
