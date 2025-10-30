import 'package:flutter/material.dart';
import '../../models/challenge.dart';
import '../../models/submission.dart';
import '../../models/user.dart';
import '../../services/fake_data_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/submission_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// شاشة التحدي الأسبوعي مع نظام التصويت بالبطاقات القابلة للسحب
class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late Challenge _currentChallenge;
  late List<Submission> _submissions;
  late Map<String, User> _users;
  int _currentIndex = 0;
  final Set<String> _likedSubmissions = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // تحميل البيانات الوهمية
    _currentChallenge = FakeDataService.getActiveChallenge();
    _submissions = FakeDataService.generateSubmissions(
      count: 20,
      challengeId: _currentChallenge.id,
    );
    
    // تحميل بيانات المستخدمين
    final users = FakeDataService.generateUsers();
    _users = {for (var user in users) user.id: user};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // معلومات التحدي
            _buildChallengeHeader(),
            
            // البطاقات القابلة للسحب
            Expanded(
              child: _buildSwipeableCards(),
            ),
            
            // أزرار التحكم
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          // رقم التحدي والحالة
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'التحدي #${_currentChallenge.challengeNumber}',
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                _currentChallenge.isActive
                    ? Icons.play_circle_filled
                    : Icons.how_to_vote,
                color: _currentChallenge.isActive
                    ? AppColors.success
                    : AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _currentChallenge.isActive ? 'نشط' : 'التصويت',
                style: TextStyle(
                  color: _currentChallenge.isActive
                      ? AppColors.success
                      : AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // عنوان التحدي
          Text(
            _currentChallenge.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xs),
          
          // الموضوع
          Text(
            _currentChallenge.theme,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.secondary,
                ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // الوقت المتبقي
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.iconSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'الوقت المتبقي: ${_currentChallenge.timeRemainingText}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(
                icon: Icons.people,
                label: 'المشاركات',
                value: _currentChallenge.totalSubmissions.toString(),
              ),
              _buildStat(
                icon: Icons.favorite,
                label: 'الأصوات',
                value: _currentChallenge.totalVotes.toString(),
              ),
              _buildStat(
                icon: Icons.visibility,
                label: 'المشاهدات',
                value: _currentChallenge.totalViews.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.iconSecondary),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSwipeableCards() {
    if (_currentIndex >= _submissions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'لقد شاهدت جميع المشاركات!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'شكراً لمشاركتك في التصويت',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // البطاقة التالية (في الخلفية)
        if (_currentIndex + 1 < _submissions.length)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Opacity(
                opacity: 0.5,
                child: _buildSubmissionCard(_currentIndex + 1),
              ),
            ),
          ),
        
        // البطاقة الحالية
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildSubmissionCard(_currentIndex),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionCard(int index) {
    final submission = _submissions[index];
    final user = _users[submission.userId];
    
    if (user == null) return const SizedBox();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // سحب لليمين = إعجاب
          _handleLike();
        } else if (details.primaryVelocity! < 0) {
          // سحب لليسار = تخطي
          _handleSkip();
        }
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // الصورة الرئيسية
            Expanded(
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
                  ),
                  
                  // تدرج في الأسفل
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // معلومات المشاركة
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            submission.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: user.avatarUrl != null
                                    ? CachedNetworkImageProvider(user.avatarUrl!)
                                    : null,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                user.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // زر التخطي
          _buildActionButton(
            icon: Icons.close,
            color: AppColors.error,
            onTap: _handleSkip,
            label: 'تخطي',
          ),
          
          // زر الإعجاب
          _buildActionButton(
            icon: Icons.favorite,
            color: AppColors.secondary,
            onTap: _handleLike,
            label: 'أعجبني',
            size: 70,
          ),
          
          // زر المعلومات
          _buildActionButton(
            icon: Icons.info_outline,
            color: AppColors.info,
            onTap: _handleInfo,
            label: 'التفاصيل',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
    double size = 60,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: AppShadows.medium,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  void _handleLike() {
    if (_currentIndex < _submissions.length) {
      setState(() {
        _likedSubmissions.add(_submissions[_currentIndex].id);
        _currentIndex++;
      });
      
      // عرض رسالة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم التصويت بنجاح! ❤️'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _handleSkip() {
    if (_currentIndex < _submissions.length) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _handleInfo() {
    if (_currentIndex < _submissions.length) {
      final submission = _submissions[_currentIndex];
      final user = _users[submission.userId];
      
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                submission.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              if (submission.description != null)
                Text(submission.description!),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text('بواسطة: ${user?.username ?? "غير معروف"}'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.favorite, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${submission.totalVotes} صوت'),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.comment, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${submission.totalComments} تعليق'),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
