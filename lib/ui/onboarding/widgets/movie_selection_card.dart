import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/movie.dart';
import '../../core/themes/app_colors.dart';

class MovieSelectionCard extends StatelessWidget {
  final Movie movie;
  final bool isSelected;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final double curveDepth;

  const MovieSelectionCard({
    super.key,
    required this.movie,
    required this.isSelected,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.curveDepth = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: CylindricalClipper(curveDepth: curveDepth),
        child: Stack(
          children: [
            // Background color for selected state
            if (isSelected)
              Positioned.fill(child: Container(color: const Color(0xFFF3E9E9))),
            // Content (image or placeholder)
            ClipPath(
              clipper: CylindricalClipper(curveDepth: curveDepth),
              child: _buildContent(),
            ),
            // Selected overlay with inner shadow effect and checkmark
            if (isSelected) ...[
              // Inner shadow effect using CustomPaint
              Positioned.fill(
                child: CustomPaint(
                  painter: InnerShadowPainter(
                    shadowColor: const Color(0xFFCB2C2C).withValues(alpha: 0.3),
                    shadowBlur: 60,
                    shadowSpread: 24,
                  ),
                ),
              ),
              // Checkmark at bottom
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (movie.fullPosterPath != null) {
      return CachedNetworkImage(
        imageUrl: movie.fullPosterPath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Text(
          'Image',
          style: TextStyle(color: AppColors.grayDark, fontSize: 16),
        ),
      ),
    );
  }
}

/// Custom clipper that creates a cylindrical shape
/// Top and bottom edges curve outward (convex)
class CylindricalClipper extends CustomClipper<Path> {
  final double curveDepth;

  CylindricalClipper({this.curveDepth = 15.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top-left
    path.moveTo(0, 0);

    // Top edge (curved outward - convex, bulging down)
    path.quadraticBezierTo(size.width / 2, curveDepth, size.width, 0);

    // Right edge (straight line down)
    path.lineTo(size.width, size.height);

    // Bottom edge (curved outward - convex, bulging up)
    path.quadraticBezierTo(
      size.width / 2,
      size.height - curveDepth,
      0,
      size.height,
    );

    // Left edge (straight line up)
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CylindricalClipper oldClipper) {
    return oldClipper.curveDepth != curveDepth;
  }
}

/// Custom painter for inner shadow effect
class InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double shadowBlur;
  final double shadowSpread;

  InnerShadowPainter({
    required this.shadowColor,
    required this.shadowBlur,
    required this.shadowSpread,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint =
        Paint()
          ..shader = RadialGradient(
            center: Alignment.center,
            radius: 0.7,
            colors: [
              Colors.transparent,
              shadowColor.withValues(alpha: 0.1),
              shadowColor.withValues(alpha: 0.2),
              shadowColor,
            ],
            stops: const [0.3, 0.6, 0.8, 1.0],
          ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(InnerShadowPainter oldDelegate) {
    return oldDelegate.shadowColor != shadowColor ||
        oldDelegate.shadowBlur != shadowBlur ||
        oldDelegate.shadowSpread != shadowSpread;
  }
}
