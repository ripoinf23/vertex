/// نموذج المستخدم
class User {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? bio;
  final String? avatarUrl;
  final String? location;
  final String? websiteUrl;
  
  // نوع المستخدم
  final String userType; // 'user', 'designer', 'admin'
  
  // حالة الاشتراك
  final String subscriptionType; // 'free', 'prime', 'pro'
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  
  // الإحصائيات
  final int totalWins;
  final int totalSubmissions;
  final int totalFollowers;
  final int totalFollowing;
  final double averageRating;
  
  // حالة الحساب
  final bool isVerified;
  final bool isActive;
  final bool emailVerified;
  
  // التواريخ
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.bio,
    this.avatarUrl,
    this.location,
    this.websiteUrl,
    this.userType = 'user',
    this.subscriptionType = 'free',
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.totalWins = 0,
    this.totalSubmissions = 0,
    this.totalFollowers = 0,
    this.totalFollowing = 0,
    this.averageRating = 0.0,
    this.isVerified = false,
    this.isActive = true,
    this.emailVerified = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// تحويل من JSON إلى User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      location: json['location'] as String?,
      websiteUrl: json['website_url'] as String?,
      userType: json['user_type'] as String? ?? 'user',
      subscriptionType: json['subscription_type'] as String? ?? 'free',
      subscriptionStartDate: json['subscription_start_date'] != null
          ? DateTime.parse(json['subscription_start_date'] as String)
          : null,
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.parse(json['subscription_end_date'] as String)
          : null,
      totalWins: json['total_wins'] as int? ?? 0,
      totalSubmissions: json['total_submissions'] as int? ?? 0,
      totalFollowers: json['total_followers'] as int? ?? 0,
      totalFollowing: json['total_following'] as int? ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      emailVerified: json['email_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  /// تحويل من User إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'bio': bio,
      'avatar_url': avatarUrl,
      'location': location,
      'website_url': websiteUrl,
      'user_type': userType,
      'subscription_type': subscriptionType,
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'total_wins': totalWins,
      'total_submissions': totalSubmissions,
      'total_followers': totalFollowers,
      'total_following': totalFollowing,
      'average_rating': averageRating,
      'is_verified': isVerified,
      'is_active': isActive,
      'email_verified': emailVerified,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  /// نسخ المستخدم مع تعديل بعض الحقول
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? bio,
    String? avatarUrl,
    String? location,
    String? websiteUrl,
    String? userType,
    String? subscriptionType,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    int? totalWins,
    int? totalSubmissions,
    int? totalFollowers,
    int? totalFollowing,
    double? averageRating,
    bool? isVerified,
    bool? isActive,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      userType: userType ?? this.userType,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      totalWins: totalWins ?? this.totalWins,
      totalSubmissions: totalSubmissions ?? this.totalSubmissions,
      totalFollowers: totalFollowers ?? this.totalFollowers,
      totalFollowing: totalFollowing ?? this.totalFollowing,
      averageRating: averageRating ?? this.averageRating,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// هل المستخدم مشترك في Prime؟
  bool get isPrime => subscriptionType == 'prime';

  /// هل المستخدم مشترك في Pro؟
  bool get isPro => subscriptionType == 'pro';

  /// هل المستخدم مشترك في أي باقة؟
  bool get hasActiveSubscription => isPrime || isPro;
}
