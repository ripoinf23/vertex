import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/asset.dart';
import '../themes/app_theme.dart';

/// بطاقة عرض الأصل الرقمي
class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap;

  const AssetCard({
    super.key,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الأصل
            _buildImage(),
            
            // معلومات الأصل
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الأصل
                  Text(
                    asset.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  // الفئة وعدد المضلعات
                  _buildMetadata(context),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // السعر والتقييم
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: asset.previewImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.shimmer,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.shimmer,
              child: const Icon(Icons.error, color: AppColors.error),
            ),
          ),
          
          // شارة مميز
          if (asset.isFeatured)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Text(
                  'مميز',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        // الفئة
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            asset.categoryArabic,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(width: AppSpacing.sm),
        
        // عدد المضلعات
        if (asset.polygonCount != null)
          Row(
            children: [
              const Icon(
                Icons.grid_on,
                size: 12,
                color: AppColors.iconSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                asset.polygonCountText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // التقييم
        const Icon(
          Icons.star,
          size: 14,
          color: AppColors.accent,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          asset.averageRating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        
        const Spacer(),
        
        // السعر
        Text(
          '\$${asset.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
