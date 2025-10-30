/// نموذج الدورة التعليمية
class Course {
  final String id;
  final String userId; // المصمم المعلم
  final String? submissionId; // المشاركة الفائزة المرتبطة
  
  // معلومات الدورة
  final String title;
  final String? description;
  final String category; // 'sculpting', 'lighting', 'animation', etc.
  final String difficultyLevel; // 'beginner', 'intermediate', 'advanced'
  
  // الملفات
  final String coverImageUrl;
  final String? trailerVideoUrl;
  
  // محتوى الدورة
  final int totalDuration; // بالدقائق
  final int totalLessons;
  
  // السعر
  final double price;
  final String currency;
  final bool isIncludedInPrime;
  
  // الإحصائيات
  final int totalEnrollments;
  final int totalSales;
  final double totalRevenue;
  final double averageRating;
  final int totalRatings;
  final double completionRate;
  
  // الحالة
  final String status; // 'active', 'inactive', 'under_review'
  final bool isFeatured;
  
  // معلومات إضافية
  final List<String>? tags;
  final String? requirements;
  final List<String>? whatYouWillLearn;
  
  final DateTime createdAt;
  final DateTime? publishedAt;

  Course({
    required this.id,
    required this.userId,
    this.submissionId,
    required this.title,
    this.description,
    required this.category,
    required this.difficultyLevel,
    required this.coverImageUrl,
    this.trailerVideoUrl,
    required this.totalDuration,
    required this.totalLessons,
    required this.price,
    this.currency = 'USD',
    this.isIncludedInPrime = true,
    this.totalEnrollments = 0,
    this.totalSales = 0,
    this.totalRevenue = 0.0,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.completionRate = 0.0,
    this.status = 'active',
    this.isFeatured = false,
    this.tags,
    this.requirements,
    this.whatYouWillLearn,
    required this.createdAt,
    this.publishedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      submissionId: json['submission_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      difficultyLevel: json['difficulty_level'] as String,
      coverImageUrl: json['cover_image_url'] as String,
      trailerVideoUrl: json['trailer_video_url'] as String?,
      totalDuration: json['total_duration'] as int,
      totalLessons: json['total_lessons'] as int,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      isIncludedInPrime: json['is_included_in_prime'] as bool? ?? true,
      totalEnrollments: json['total_enrollments'] as int? ?? 0,
      totalSales: json['total_sales'] as int? ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['total_ratings'] as int? ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'active',
      isFeatured: json['is_featured'] as bool? ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      requirements: json['requirements'] as String?,
      whatYouWillLearn: json['what_you_will_learn'] != null
          ? List<String>.from(json['what_you_will_learn'] as List)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'submission_id': submissionId,
      'title': title,
      'description': description,
      'category': category,
      'difficulty_level': difficultyLevel,
      'cover_image_url': coverImageUrl,
      'trailer_video_url': trailerVideoUrl,
      'total_duration': totalDuration,
      'total_lessons': totalLessons,
      'price': price,
      'currency': currency,
      'is_included_in_prime': isIncludedInPrime,
      'total_enrollments': totalEnrollments,
      'total_sales': totalSales,
      'total_revenue': totalRevenue,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'completion_rate': completionRate,
      'status': status,
      'is_featured': isFeatured,
      'tags': tags,
      'requirements': requirements,
      'what_you_will_learn': whatYouWillLearn,
      'created_at': createdAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
    };
  }

  /// مدة الدورة بصيغة قابلة للقراءة
  String get durationText {
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    if (hours > 0) {
      return '$hours ساعة و $minutes دقيقة';
    }
    return '$minutes دقيقة';
  }

  /// مستوى الصعوبة بالعربية
  String get difficultyLevelArabic {
    switch (difficultyLevel) {
      case 'beginner':
        return 'مبتدئ';
      case 'intermediate':
        return 'متوسط';
      case 'advanced':
        return 'متقدم';
      default:
        return difficultyLevel;
    }
  }

  /// هل الدورة نشطة؟
  bool get isActive => status == 'active';

  /// هل الدورة مجانية لمشتركي Prime؟
  bool get isFreeForPrime => isIncludedInPrime;
}
