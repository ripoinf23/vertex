import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/user.dart';
import '../../models/submission.dart';
import '../../services/fake_data_service.dart';
import '../../services/auth_service.dart';
import '../../themes/app_theme.dart';
import '../auth/login_screen.dart';

/// شاشة الملف الشخصي للمصمم
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late User _currentUser;
  late List<Submission> _userSubmissions;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    _currentUser = FakeDataService.getCurrentUser();
    _userSubmissions = FakeDataService.generateSubmissions(count: 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // شريط التطبيق مع الصورة الشخصية
          _buildSliverAppBar(),
          
          // معلومات المستخدم
          SliverToBoxAdapter(
            child: _buildUserInfo(),
          ),
          
          // الإحصائيات
          SliverToBoxAdapter(
            child: _buildStats(),
          ),
          
          // الأزرار
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),
          
          // التبويبات
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.secondary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.secondary,
                tabs: const [
                  Tab(text: 'المشاركات'),
                  Tab(text: 'الدورات'),
                  Tab(text: 'الإنجازات'),
                ],
              ),
            ),
          ),
          
          // محتوى التبويبات
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSubmissionsTab(),
                _buildCoursesTab(),
                _buildAchievementsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _handleSignOut,
          tooltip: 'تسجيل الخروج',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // خلفية متدرجة
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
              ),
            ),
            
            // الصورة الشخصية
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: AppShadows.large,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _currentUser.avatarUrl != null
                        ? CachedNetworkImageProvider(_currentUser.avatarUrl!)
                        : null,
                    child: _currentUser.avatarUrl == null
                        ? Text(
                            _currentUser.username[0].toUpperCase(),
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // فتح الإعدادات
          },
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // الاسم والتحقق
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentUser.fullName ?? _currentUser.username,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (_currentUser.isVerified) ...[
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.verified,
                  color: AppColors.info,
                  size: 24,
                ),
              ],
            ],
          ),
          
          const SizedBox(height: AppSpacing.xs),
          
          // اسم المستخدم
          Text(
            '@${_currentUser.username}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // شارة الاشتراك
          if (_currentUser.hasActiveSubscription)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: _currentUser.isPro
                    ? AppColors.accent
                    : AppColors.secondary,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: AppColors.textOnPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _currentUser.isPro ? 'Pro' : 'Prime',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: AppSpacing.md),
          
          // السيرة الذاتية
          if (_currentUser.bio != null)
            Text(
              _currentUser.bio!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // الموقع والموقع الإلكتروني
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentUser.location != null) ...[
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.iconSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _currentUser.location!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (_currentUser.location != null &&
                  _currentUser.websiteUrl != null)
                const SizedBox(width: AppSpacing.md),
              if (_currentUser.websiteUrl != null) ...[
                const Icon(
                  Icons.link,
                  size: 16,
                  color: AppColors.iconSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'الموقع الإلكتروني',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            label: 'المشاركات',
            value: _currentUser.totalSubmissions.toString(),
          ),
          _buildDivider(),
          _buildStatItem(
            label: 'الفوز',
            value: _currentUser.totalWins.toString(),
          ),
          _buildDivider(),
          _buildStatItem(
            label: 'المتابعون',
            value: _formatNumber(_currentUser.totalFollowers),
          ),
          _buildDivider(),
          _buildStatItem(
            label: 'المتابَعون',
            value: _formatNumber(_currentUser.totalFollowing),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.divider,
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('تعديل الملف'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('مشاركة'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.8,
      ),
      itemCount: _userSubmissions.length,
      itemBuilder: (context, index) {
        final submission = _userSubmissions[index];
        return GestureDetector(
          onTap: () {
            // فتح تفاصيل المشاركة
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: submission.mainImageUrl,
                  fit: BoxFit.cover,
                ),
                if (submission.isWinner)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 16,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          submission.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              submission.totalVotes.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoursesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.school_outlined,
            size: 80,
            color: AppColors.iconLight,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'لا توجد دورات بعد',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'ابدأ بإنشاء دورتك الأولى',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return GridView.count(
      padding: const EdgeInsets.all(AppSpacing.md),
      crossAxisCount: 3,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      children: [
        _buildAchievementBadge(
          icon: Icons.emoji_events,
          title: 'الفائز',
          subtitle: '${_currentUser.totalWins}x',
          color: AppColors.accent,
        ),
        _buildAchievementBadge(
          icon: Icons.verified,
          title: 'موثق',
          subtitle: 'تم التحقق',
          color: AppColors.info,
        ),
        _buildAchievementBadge(
          icon: Icons.star,
          title: _currentUser.isPro ? 'Pro' : 'Prime',
          subtitle: 'عضو',
          color: _currentUser.isPro ? AppColors.accent : AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

  Future<void> _handleSignOut() async {
    // عرض مربع حوار للتأكيد
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      // تسجيل الخروج
      await AuthService().signOut();
      
      if (!mounted) return;
      
      // الانتقال إلى شاشة تسجيل الدخول
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
