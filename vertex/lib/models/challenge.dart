/// نموذج التحدي الأسبوعي
class Challenge {
  final String id;
  final int challengeNumber;
  final String title;
  final String? description;
  final String theme;
  final String? coverImageUrl;
  
  // الحالة
  final String status; // 'scheduled', 'active', 'voting', 'completed'
  
  // التواريخ
  final DateTime submissionStartDate;
  final DateTime submissionEndDate;
  final DateTime votingStartDate;
  final DateTime votingEndDate;
  
  // الإحصائيات
  final int totalSubmissions;
  final int totalVotes;
  final int totalViews;
  
  // الفائزون
  final String? firstPlaceUserId;
  final String? secondPlaceUserId;
  final String? thirdPlaceUserId;
  
  // معلومات إضافية
  final String? rules;
  final String? prizes;
  
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.challengeNumber,
    required this.title,
    this.description,
    required this.theme,
    this.coverImageUrl,
    this.status = 'scheduled',
    required this.submissionStartDate,
    required this.submissionEndDate,
    required this.votingStartDate,
    required this.votingEndDate,
    this.totalSubmissions = 0,
    this.totalVotes = 0,
    this.totalViews = 0,
    this.firstPlaceUserId,
    this.secondPlaceUserId,
    this.thirdPlaceUserId,
    this.rules,
    this.prizes,
    required this.createdAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      challengeNumber: json['challenge_number'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      theme: json['theme'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      status: json['status'] as String? ?? 'scheduled',
      submissionStartDate: DateTime.parse(json['submission_start_date'] as String),
      submissionEndDate: DateTime.parse(json['submission_end_date'] as String),
      votingStartDate: DateTime.parse(json['voting_start_date'] as String),
      votingEndDate: DateTime.parse(json['voting_end_date'] as String),
      totalSubmissions: json['total_submissions'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
      totalViews: json['total_views'] as int? ?? 0,
      firstPlaceUserId: json['first_place_user_id'] as String?,
      secondPlaceUserId: json['second_place_user_id'] as String?,
      thirdPlaceUserId: json['third_place_user_id'] as String?,
      rules: json['rules'] as String?,
      prizes: json['prizes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_number': challengeNumber,
      'title': title,
      'description': description,
      'theme': theme,
      'cover_image_url': coverImageUrl,
      'status': status,
      'submission_start_date': submissionStartDate.toIso8601String(),
      'submission_end_date': submissionEndDate.toIso8601String(),
      'voting_start_date': votingStartDate.toIso8601String(),
      'voting_end_date': votingEndDate.toIso8601String(),
      'total_submissions': totalSubmissions,
      'total_votes': totalVotes,
      'total_views': totalViews,
      'first_place_user_id': firstPlaceUserId,
      'second_place_user_id': secondPlaceUserId,
      'third_place_user_id': thirdPlaceUserId,
      'rules': rules,
      'prizes': prizes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Challenge copyWith({
    String? id,
    int? challengeNumber,
    String? title,
    String? description,
    String? theme,
    String? coverImageUrl,
    String? status,
    DateTime? submissionStartDate,
    DateTime? submissionEndDate,
    DateTime? votingStartDate,
    DateTime? votingEndDate,
    int? totalSubmissions,
    int? totalVotes,
    int? totalViews,
    String? firstPlaceUserId,
    String? secondPlaceUserId,
    String? thirdPlaceUserId,
    String? rules,
    String? prizes,
    DateTime? createdAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      challengeNumber: challengeNumber ?? this.challengeNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      theme: theme ?? this.theme,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      status: status ?? this.status,
      submissionStartDate: submissionStartDate ?? this.submissionStartDate,
      submissionEndDate: submissionEndDate ?? this.submissionEndDate,
      votingStartDate: votingStartDate ?? this.votingStartDate,
      votingEndDate: votingEndDate ?? this.votingEndDate,
      totalSubmissions: totalSubmissions ?? this.totalSubmissions,
      totalVotes: totalVotes ?? this.totalVotes,
      totalViews: totalViews ?? this.totalViews,
      firstPlaceUserId: firstPlaceUserId ?? this.firstPlaceUserId,
      secondPlaceUserId: secondPlaceUserId ?? this.secondPlaceUserId,
      thirdPlaceUserId: thirdPlaceUserId ?? this.thirdPlaceUserId,
      rules: rules ?? this.rules,
      prizes: prizes ?? this.prizes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// هل التحدي نشط حالياً؟
  bool get isActive => status == 'active';

  /// هل التصويت نشط؟
  bool get isVoting => status == 'voting';

  /// هل التحدي مكتمل؟
  bool get isCompleted => status == 'completed';

  /// الوقت المتبقي حتى نهاية التحدي
  Duration get timeRemaining {
    final now = DateTime.now();
    if (status == 'active') {
      return submissionEndDate.difference(now);
    } else if (status == 'voting') {
      return votingEndDate.difference(now);
    }
    return Duration.zero;
  }

  /// نص الوقت المتبقي بصيغة قابلة للقراءة
  String get timeRemainingText {
    final remaining = timeRemaining;
    if (remaining.inDays > 0) {
      return '${remaining.inDays} أيام و ${remaining.inHours % 24} ساعات';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours} ساعات و ${remaining.inMinutes % 60} دقيقة';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes} دقيقة';
    }
    return 'انتهى';
  }
}
