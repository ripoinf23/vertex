/// نموذج الإشعار
class Notification {
  final String id;
  final String userId;
  
  // نوع الإشعار
  final String notificationType; // 'challenge_win', 'new_comment', 'new_follower', 'purchase', 'vote'
  
  // محتوى الإشعار
  final String title;
  final String message;
  
  // الرابط المرتبط
  final String? actionUrl;
  
  // معلومات إضافية
  final Map<String, dynamic>? metadata;
  
  // الحالة
  final bool isRead;
  final DateTime? readAt;
  
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.notificationType,
    required this.title,
    required this.message,
    this.actionUrl,
    this.metadata,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      notificationType: json['notification_type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      actionUrl: json['action_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'notification_type': notificationType,
      'title': title,
      'message': message,
      'action_url': actionUrl,
      'metadata': metadata,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? notificationType,
    String? title,
    String? message,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
      title: title ?? this.title,
      message: message ?? this.message,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// أيقونة الإشعار حسب نوعه
  String get icon {
    switch (notificationType) {
      case 'challenge_win':
        return '🏆';
      case 'new_comment':
        return '💬';
      case 'new_follower':
        return '👥';
      case 'purchase':
        return '💰';
      case 'vote':
        return '❤️';
      default:
        return '🔔';
    }
  }

  /// الوقت منذ الإنشاء بصيغة قابلة للقراءة
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return 'منذ ${difference.inDays ~/ 7} أسبوع';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
