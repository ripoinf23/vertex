/// نموذج المشاركة في التحدي
class Submission {
  final String id;
  final String challengeId;
  final String userId;
  
  // محتوى المشاركة
  final String title;
  final String? description;
  
  // الملفات
  final String mainImageUrl;
  final List<String>? additionalImagesUrls;
  final String? videoUrl;
  
  // الإحصائيات
  final int totalVotes;
  final int totalComments;
  final int totalViews;
  
  // الترتيب والجوائز
  final int? rank;
  final bool isWinner;
  final int? prizePosition; // 1, 2, أو 3
  
  // الحالة
  final String status; // 'pending', 'approved', 'rejected', 'flagged'
  
  final DateTime createdAt;

  Submission({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.title,
    this.description,
    required this.mainImageUrl,
    this.additionalImagesUrls,
    this.videoUrl,
    this.totalVotes = 0,
    this.totalComments = 0,
    this.totalViews = 0,
    this.rank,
    this.isWinner = false,
    this.prizePosition,
    this.status = 'pending',
    required this.createdAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      mainImageUrl: json['main_image_url'] as String,
      additionalImagesUrls: json['additional_images_urls'] != null
          ? List<String>.from(json['additional_images_urls'] as List)
          : null,
      videoUrl: json['video_url'] as String?,
      totalVotes: json['total_votes'] as int? ?? 0,
      totalComments: json['total_comments'] as int? ?? 0,
      totalViews: json['total_views'] as int? ?? 0,
      rank: json['rank'] as int?,
      isWinner: json['is_winner'] as bool? ?? false,
      prizePosition: json['prize_position'] as int?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'user_id': userId,
      'title': title,
      'description': description,
      'main_image_url': mainImageUrl,
      'additional_images_urls': additionalImagesUrls,
      'video_url': videoUrl,
      'total_votes': totalVotes,
      'total_comments': totalComments,
      'total_views': totalViews,
      'rank': rank,
      'is_winner': isWinner,
      'prize_position': prizePosition,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Submission copyWith({
    String? id,
    String? challengeId,
    String? userId,
    String? title,
    String? description,
    String? mainImageUrl,
    List<String>? additionalImagesUrls,
    String? videoUrl,
    int? totalVotes,
    int? totalComments,
    int? totalViews,
    int? rank,
    bool? isWinner,
    int? prizePosition,
    String? status,
    DateTime? createdAt,
  }) {
    return Submission(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      additionalImagesUrls: additionalImagesUrls ?? this.additionalImagesUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      totalVotes: totalVotes ?? this.totalVotes,
      totalComments: totalComments ?? this.totalComments,
      totalViews: totalViews ?? this.totalViews,
      rank: rank ?? this.rank,
      isWinner: isWinner ?? this.isWinner,
      prizePosition: prizePosition ?? this.prizePosition,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// هل المشاركة موافق عليها؟
  bool get isApproved => status == 'approved';

  /// هل المشاركة مرفوضة؟
  bool get isRejected => status == 'rejected';

  /// هل المشاركة مبلّغ عنها؟
  bool get isFlagged => status == 'flagged';
}
