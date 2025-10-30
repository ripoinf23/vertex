/// نموذج الأصل الرقمي
class Asset {
  final String id;
  final String userId; // المصمم البائع
  
  // معلومات الأصل
  final String title;
  final String? description;
  final String category; // 'model', 'material', 'source_file', 'texture'
  
  // الملفات
  final String previewImageUrl;
  final List<String>? additionalImagesUrls;
  
  // السعر
  final double price;
  final String currency;
  
  // الإحصائيات
  final int totalDownloads;
  final int totalSales;
  final double totalRevenue;
  final double averageRating;
  final int totalRatings;
  
  // الحالة
  final String status; // 'active', 'inactive', 'under_review'
  final bool isFeatured;
  
  // معلومات إضافية
  final List<String>? tags;
  final List<String>? fileFormats; // ['STL', 'OBJ', 'FBX']
  final int? polygonCount;
  
  final DateTime createdAt;

  Asset({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    required this.previewImageUrl,
    this.additionalImagesUrls,
    required this.price,
    this.currency = 'USD',
    this.totalDownloads = 0,
    this.totalSales = 0,
    this.totalRevenue = 0.0,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.status = 'active',
    this.isFeatured = false,
    this.tags,
    this.fileFormats,
    this.polygonCount,
    required this.createdAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      previewImageUrl: json['preview_image_url'] as String,
      additionalImagesUrls: json['additional_images_urls'] != null
          ? List<String>.from(json['additional_images_urls'] as List)
          : null,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      totalDownloads: json['total_downloads'] as int? ?? 0,
      totalSales: json['total_sales'] as int? ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['total_ratings'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      isFeatured: json['is_featured'] as bool? ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      fileFormats: json['file_formats'] != null
          ? List<String>.from(json['file_formats'] as List)
          : null,
      polygonCount: json['polygon_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'preview_image_url': previewImageUrl,
      'additional_images_urls': additionalImagesUrls,
      'price': price,
      'currency': currency,
      'total_downloads': totalDownloads,
      'total_sales': totalSales,
      'total_revenue': totalRevenue,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'status': status,
      'is_featured': isFeatured,
      'tags': tags,
      'file_formats': fileFormats,
      'polygon_count': polygonCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// الفئة بالعربية
  String get categoryArabic {
    switch (category) {
      case 'model':
        return 'نموذج';
      case 'material':
        return 'مادة';
      case 'source_file':
        return 'ملف مصدر';
      case 'texture':
        return 'نسيج';
      default:
        return category;
    }
  }

  /// هل الأصل نشط؟
  bool get isActive => status == 'active';

  /// صيغ الملفات كنص
  String get fileFormatsText {
    if (fileFormats == null || fileFormats!.isEmpty) {
      return 'غير محدد';
    }
    return fileFormats!.join(', ');
  }

  /// عدد المضلعات بصيغة قابلة للقراءة
  String get polygonCountText {
    if (polygonCount == null) {
      return 'غير محدد';
    }
    if (polygonCount! >= 1000000) {
      return '${(polygonCount! / 1000000).toStringAsFixed(1)}M';
    } else if (polygonCount! >= 1000) {
      return '${(polygonCount! / 1000).toStringAsFixed(1)}K';
    }
    return polygonCount.toString();
  }
}
