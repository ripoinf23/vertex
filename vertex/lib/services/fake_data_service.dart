import '../models/user.dart';
import '../models/challenge.dart';
import '../models/submission.dart';
import '../models/course.dart';
import '../models/asset.dart';
import '../models/comment.dart';
import '../models/notification.dart';

/// خدمة توليد البيانات الوهمية للتطوير والاختبار
class FakeDataService {
  // قوائم أسماء وهمية
  static const List<String> _arabicNames = [
    'أحمد المصمم',
    'فاطمة الفنانة',
    'محمد المبدع',
    'سارة النحاتة',
    'علي المهندس',
    'نور المصممة',
    'خالد الرسام',
    'ليلى الفنانة',
    'عمر المبتكر',
    'ريم المصممة',
  ];

  static const List<String> _usernames = [
    'ahmed_3d_artist',
    'fatima_sculptor',
    'mohamed_creative',
    'sara_designer',
    'ali_engineer',
    'nour_artist',
    'khaled_painter',
    'laila_creator',
    'omar_innovator',
    'reem_designer',
  ];

  static const List<String> _challengeThemes = [
    'روبوت مساعد منزلي',
    'سفينة فضاء مستقبلية',
    'مخلوق خيالي',
    'مبنى معماري حديث',
    'سيارة كلاسيكية',
    'شخصية كرتونية',
    'أثاث عصري',
    'سلاح خيالي',
    'مشهد طبيعي',
    'آلة موسيقية',
  ];

  static const List<String> _imageUrls = [
    'https://picsum.photos/seed/1/800/600',
    'https://picsum.photos/seed/2/800/600',
    'https://picsum.photos/seed/3/800/600',
    'https://picsum.photos/seed/4/800/600',
    'https://picsum.photos/seed/5/800/600',
    'https://picsum.photos/seed/6/800/600',
    'https://picsum.photos/seed/7/800/600',
    'https://picsum.photos/seed/8/800/600',
    'https://picsum.photos/seed/9/800/600',
    'https://picsum.photos/seed/10/800/600',
  ];

  static const List<String> _avatarUrls = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
    'https://i.pravatar.cc/150?img=7',
    'https://i.pravatar.cc/150?img=8',
    'https://i.pravatar.cc/150?img=9',
    'https://i.pravatar.cc/150?img=10',
  ];

  /// توليد قائمة مستخدمين وهميين
  static List<User> generateUsers({int count = 10}) {
    return List.generate(count, (index) {
      return User(
        id: 'user_$index',
        username: _usernames[index % _usernames.length],
        email: '${_usernames[index % _usernames.length]}@vertex.app',
        fullName: _arabicNames[index % _arabicNames.length],
        bio: 'مصمم ثلاثي الأبعاد متخصص في التصاميم الإبداعية والمبتكرة.',
        avatarUrl: _avatarUrls[index % _avatarUrls.length],
        location: 'الرياض، السعودية',
        websiteUrl: 'https://behance.net/${_usernames[index % _usernames.length]}',
        userType: 'designer',
        subscriptionType: index % 3 == 0 ? 'pro' : (index % 3 == 1 ? 'prime' : 'free'),
        totalWins: (index * 3) % 20,
        totalSubmissions: (index * 5) % 50,
        totalFollowers: (index * 100) % 5000,
        totalFollowing: (index * 50) % 1000,
        averageRating: 4.0 + (index % 10) * 0.1,
        isVerified: index % 2 == 0,
        isActive: true,
        emailVerified: true,
        createdAt: DateTime.now().subtract(Duration(days: index * 30)),
        lastLoginAt: DateTime.now().subtract(Duration(hours: index * 2)),
      );
    });
  }

  /// توليد قائمة تحديات وهمية
  static List<Challenge> generateChallenges({int count = 10}) {
    return List.generate(count, (index) {
      final now = DateTime.now();
      final isActive = index == 0; // التحدي الأول نشط
      final isVoting = index == 1; // التحدي الثاني في مرحلة التصويت
      
      return Challenge(
        id: 'challenge_$index',
        challengeNumber: index + 1,
        title: 'التحدي الأسبوعي #${index + 1}',
        description: 'صمم ${_challengeThemes[index % _challengeThemes.length]} بأسلوبك الخاص وأبهر المجتمع!',
        theme: _challengeThemes[index % _challengeThemes.length],
        coverImageUrl: _imageUrls[index % _imageUrls.length],
        status: isActive ? 'active' : (isVoting ? 'voting' : 'completed'),
        submissionStartDate: now.subtract(Duration(days: 7 * index)),
        submissionEndDate: now.subtract(Duration(days: 7 * index - 5)),
        votingStartDate: now.subtract(Duration(days: 7 * index - 5)),
        votingEndDate: now.subtract(Duration(days: 7 * index - 7)),
        totalSubmissions: (index * 20) % 150,
        totalVotes: (index * 50) % 500,
        totalViews: (index * 200) % 2000,
        rules: 'يجب أن يكون التصميم أصلياً ومن إبداعك الخاص.',
        prizes: 'الفائز الأول: شارة ذهبية وإمكانية إنشاء دورة تعليمية',
        createdAt: now.subtract(Duration(days: 7 * index + 1)),
      );
    });
  }

  /// توليد قائمة مشاركات وهمية
  static List<Submission> generateSubmissions({
    int count = 20,
    String? challengeId,
  }) {
    final users = generateUsers();
    
    return List.generate(count, (index) {
      return Submission(
        id: 'submission_$index',
        challengeId: challengeId ?? 'challenge_0',
        userId: users[index % users.length].id,
        title: 'تصميم ${_challengeThemes[index % _challengeThemes.length]}',
        description: 'تصميم إبداعي يجمع بين الأصالة والحداثة مع اهتمام بالتفاصيل الدقيقة.',
        mainImageUrl: _imageUrls[index % _imageUrls.length],
        additionalImagesUrls: [
          _imageUrls[(index + 1) % _imageUrls.length],
          _imageUrls[(index + 2) % _imageUrls.length],
        ],
        totalVotes: (index * 10) % 300,
        totalComments: (index * 3) % 50,
        totalViews: (index * 50) % 1000,
        rank: index < 3 ? index + 1 : null,
        isWinner: index < 3,
        prizePosition: index < 3 ? index + 1 : null,
        status: 'approved',
        createdAt: DateTime.now().subtract(Duration(hours: index * 6)),
      );
    });
  }

  /// توليد قائمة دورات وهمية
  static List<Course> generateCourses({int count = 10}) {
    final users = generateUsers();
    
    return List.generate(count, (index) {
      return Course(
        id: 'course_$index',
        userId: users[index % users.length].id,
        title: 'دورة تصميم ${_challengeThemes[index % _challengeThemes.length]}',
        description: 'تعلم كيفية تصميم ${_challengeThemes[index % _challengeThemes.length]} خطوة بخطوة مع أفضل الممارسات والتقنيات الحديثة.',
        category: ['sculpting', 'lighting', 'animation', 'architecture'][index % 4],
        difficultyLevel: ['beginner', 'intermediate', 'advanced'][index % 3],
        coverImageUrl: _imageUrls[index % _imageUrls.length],
        trailerVideoUrl: 'https://example.com/trailer_$index.mp4',
        totalDuration: 60 + (index * 30) % 300, // من 60 إلى 360 دقيقة
        totalLessons: 5 + (index * 2) % 20,
        price: 10.0 + (index * 5.0) % 50.0,
        currency: 'USD',
        isIncludedInPrime: index % 2 == 0,
        totalEnrollments: (index * 50) % 500,
        totalSales: (index * 30) % 300,
        totalRevenue: (index * 150.0) % 1500.0,
        averageRating: 4.0 + (index % 10) * 0.1,
        totalRatings: (index * 20) % 200,
        completionRate: 60.0 + (index * 5.0) % 40.0,
        status: 'active',
        isFeatured: index % 3 == 0,
        tags: ['3d', 'design', 'tutorial'],
        requirements: 'معرفة أساسية ببرامج التصميم ثلاثي الأبعاد',
        whatYouWillLearn: [
          'أساسيات التصميم ثلاثي الأبعاد',
          'تقنيات الإضاءة والتظليل',
          'إنشاء مواد واقعية',
          'التصدير للطباعة ثلاثية الأبعاد',
        ],
        createdAt: DateTime.now().subtract(Duration(days: index * 15)),
        publishedAt: DateTime.now().subtract(Duration(days: index * 14)),
      );
    });
  }

  /// توليد قائمة أصول رقمية وهمية
  static List<Asset> generateAssets({int count = 20}) {
    final users = generateUsers();
    
    return List.generate(count, (index) {
      return Asset(
        id: 'asset_$index',
        userId: users[index % users.length].id,
        title: 'نموذج ${_challengeThemes[index % _challengeThemes.length]}',
        description: 'نموذج ثلاثي الأبعاد عالي الجودة جاهز للاستخدام في مشاريعك.',
        category: ['model', 'material', 'source_file', 'texture'][index % 4],
        previewImageUrl: _imageUrls[index % _imageUrls.length],
        additionalImagesUrls: [
          _imageUrls[(index + 1) % _imageUrls.length],
          _imageUrls[(index + 2) % _imageUrls.length],
        ],
        price: 5.0 + (index * 3.0) % 30.0,
        currency: 'USD',
        totalDownloads: (index * 50) % 500,
        totalSales: (index * 30) % 300,
        totalRevenue: (index * 100.0) % 1000.0,
        averageRating: 4.0 + (index % 10) * 0.1,
        totalRatings: (index * 15) % 150,
        status: 'active',
        isFeatured: index % 4 == 0,
        tags: ['3d', 'model', 'design'],
        fileFormats: ['STL', 'OBJ', 'FBX'],
        polygonCount: 10000 + (index * 5000) % 100000,
        createdAt: DateTime.now().subtract(Duration(days: index * 10)),
      );
    });
  }

  /// توليد قائمة تعليقات وهمية
  static List<Comment> generateComments({
    int count = 15,
    String? submissionId,
  }) {
    final users = generateUsers();
    
    return List.generate(count, (index) {
      return Comment(
        id: 'comment_$index',
        userId: users[index % users.length].id,
        commentType: 'submission',
        submissionId: submissionId ?? 'submission_0',
        content: [
          'تصميم رائع! أحببت التفاصيل الدقيقة.',
          'عمل مذهل، استمر في الإبداع!',
          'الإضاءة ممتازة، كيف حققت هذا التأثير؟',
          'هل يمكنك مشاركة ملف المصدر؟',
          'تصميم احترافي جداً، تستحق الفوز!',
        ][index % 5],
        parentCommentId: index > 5 ? 'comment_${index - 5}' : null,
        totalLikes: (index * 5) % 50,
        status: 'active',
        createdAt: DateTime.now().subtract(Duration(hours: index * 3)),
      );
    });
  }

  /// توليد قائمة إشعارات وهمية
  static List<Notification> generateNotifications({int count = 10}) {
    return List.generate(count, (index) {
      final types = ['challenge_win', 'new_comment', 'new_follower', 'purchase', 'vote'];
      final type = types[index % types.length];
      
      String title;
      String message;
      
      switch (type) {
        case 'challenge_win':
          title = 'تهانينا! 🏆';
          message = 'تصميمك فاز بالمركز الأول في التحدي #${index + 1}';
          break;
        case 'new_comment':
          title = 'تعليق جديد 💬';
          message = 'علّق ${_arabicNames[index % _arabicNames.length]} على تصميمك';
          break;
        case 'new_follower':
          title = 'متابع جديد 👥';
          message = '${_arabicNames[index % _arabicNames.length]} بدأ بمتابعتك';
          break;
        case 'purchase':
          title: 'عملية شراء جديدة 💰';
          message = 'تم شراء دورتك "${_challengeThemes[index % _challengeThemes.length]}"';
          break;
        case 'vote':
          title = 'إعجاب جديد ❤️';
          message = 'أعجب ${_arabicNames[index % _arabicNames.length]} بتصميمك';
          break;
        default:
          title = 'إشعار جديد';
          message = 'لديك إشعار جديد';
      }
      
      return Notification(
        id: 'notification_$index',
        userId: 'user_0',
        notificationType: type,
        title: title,
        message: message,
        actionUrl: '/submission/submission_$index',
        metadata: {'challenge_id': 'challenge_$index'},
        isRead: index > 3,
        readAt: index > 3 ? DateTime.now().subtract(Duration(hours: index)) : null,
        createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
      );
    });
  }

  /// الحصول على تحدي نشط وهمي
  static Challenge getActiveChallenge() {
    return generateChallenges(count: 1).first;
  }

  /// الحصول على مستخدم حالي وهمي
  static User getCurrentUser() {
    return User(
      id: 'current_user',
      username: 'my_username',
      email: 'me@vertex.app',
      fullName: 'أنا المصمم',
      bio: 'مصمم ثلاثي الأبعاد شغوف بالإبداع والابتكار',
      avatarUrl: _avatarUrls[0],
      location: 'الرياض، السعودية',
      websiteUrl: 'https://behance.net/myusername',
      userType: 'designer',
      subscriptionType: 'pro',
      totalWins: 5,
      totalSubmissions: 25,
      totalFollowers: 1234,
      totalFollowing: 567,
      averageRating: 4.8,
      isVerified: true,
      isActive: true,
      emailVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      lastLoginAt: DateTime.now(),
    );
  }
}
