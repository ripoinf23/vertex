/// نموذج التعليق
class Comment {
  final String id;
  final String userId;
  
  // نوع التعليق
  final String commentType; // 'submission', 'course', 'asset'
  final String? submissionId;
  final String? courseId;
  final String? assetId;
  
  // محتوى التعليق
  final String content;
  
  // التعليقات المتداخلة (الردود)
  final String? parentCommentId;
  
  // الإحصائيات
  final int totalLikes;
  
  // الحالة
  final String status; // 'active', 'deleted', 'flagged'
  
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.commentType,
    this.submissionId,
    this.courseId,
    this.assetId,
    required this.content,
    this.parentCommentId,
    this.totalLikes = 0,
    this.status = 'active',
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      commentType: json['comment_type'] as String,
      submissionId: json['submission_id'] as String?,
      courseId: json['course_id'] as String?,
      assetId: json['asset_id'] as String?,
      content: json['content'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      totalLikes: json['total_likes'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'comment_type': commentType,
      'submission_id': submissionId,
      'course_id': courseId,
      'asset_id': assetId,
      'content': content,
      'parent_comment_id': parentCommentId,
      'total_likes': totalLikes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// هل التعليق رد على تعليق آخر؟
  bool get isReply => parentCommentId != null;

  /// هل التعليق نشط؟
  bool get isActive => status == 'active';

  /// هل التعليق محذوف؟
  bool get isDeleted => status == 'deleted';
}
