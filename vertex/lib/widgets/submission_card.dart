import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/submission.dart';
import '../models/user.dart';
import '../themes/app_theme.dart';

/// بطاقة عرض المشاركة في التحدي
class SubmissionCard extends StatelessWidget {
  final Submission submission;
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final bool isLiked;

  const SubmissionCard({
    super.key,
    required this.submission,
    required this.user,
    this.onTap,
    this.onLike,
    this.onComment,
    this.isLiked = false,
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
            // صورة المشاركة
            _buildImage(),
            
            // معلومات المشاركة
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات المستخدم
                  _buildUserInfo(context),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  // عنوان المشاركة
                  Text(
                    submission.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  if (submission.description != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      submission.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // الإحصائيات والأزرار
                  _buildActions(context),
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
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: submission.mainImageUrl,
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
          
          // شارة الفوز إذا كانت المشاركة فائزة
          if (submission.isWinner)
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppShadows.medium,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.textOnPrimary,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'المركز ${submission.prizePosition}',
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      children: [
        // صورة المستخدم
        CircleAvatar(
          radius: 16,
          backgroundImage: user.avatarUrl != null
              ? CachedNetworkImageProvider(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Text(user.username[0].toUpperCase())
              : null,
        ),
        
        const SizedBox(width: AppSpacing.sm),
        
        // اسم المستخدم
        Expanded(
          child: Row(
            children: [
              Text(
                user.username,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              if (user.isVerified) ...[
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.verified,
                  size: 16,
                  color: AppColors.info,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // زر الإعجاب
        _ActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatNumber(submission.totalVotes),
          color: isLiked ? AppColors.error : null,
          onTap: onLike,
        ),
        
        const SizedBox(width: AppSpacing.md),
        
        // زر التعليقات
        _ActionButton(
          icon: Icons.comment_outlined,
          label: _formatNumber(submission.totalComments),
          onTap: onComment,
        ),
        
        const Spacer(),
        
        // عدد المشاهدات
        Row(
          children: [
            const Icon(
              Icons.visibility_outlined,
              size: 16,
              color: AppColors.iconSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _formatNumber(submission.totalViews),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? AppColors.iconSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                color: color ?? AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
